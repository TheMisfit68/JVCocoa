 //
 //  JVSQLiteRecord.swift
 //  JVCocoa
 //
 //  Created by Jan Verrept on 25/08/17.
 //  Copyright © 2017 OneClick. All rights reserved.
 //
 
 import Foundation
 import GRDB
 
 
 /// This structure get initialized with a struct of some generic type and
 /// mirrors that struct in the SQLite-database
 
 struct JVSQliteRecord<ModelType>{
    
    typealias ID = Int
    typealias DataBase = DatabaseQueue
    
    private let dataBase:DataBase
    private let dataStruct:ModelType
    private let typeAndTableName:String
    private let primaryKeyNames:[String]
    
    var matchFields:[String]?=nil{
        didSet {
            updateSqlExpressions()
        }
    }
    private var sqlExpressions = (names:"", placeholders:"", pairs:"", values:[], matchConditions:"")
    
    init(data:ModelType, in dataBase:DataBase){
        self.dataBase = dataBase
        self.dataStruct = data
        self.typeAndTableName = String(describing: type(of: dataStruct))
        
        let tableName = typeAndTableName
        self.primaryKeyNames = dataBase.inDatabase {db in return try? db.primaryKey(tableName).columns} ?? []
    }
    
    //MARK: - Use FileMaker-terminolgie to add persistensie to this structure
    
    public mutating func changeOrCreateRecord(matchFields:[String]? = nil)->[Row]?{
        
        // This an Update or Insert a.k.a an 'UpSert'
        var affectedRows:[Row]?
        self.matchFields = matchFields
        affectedRows = execute(sqlString: "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.matchConditions)")
        
        if (affectedRows == nil) || (affectedRows! == []){
            self.matchFields = nil
            affectedRows = execute(sqlString: "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
        }
        return affectedRows
    }
    
    public mutating func createRecord()->[Row]?{
        
        self.matchFields = nil
        return execute(sqlString: "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
    }
    
    public mutating func changeRecord(matchFields:[String])->[Row]?{
        
        self.matchFields = matchFields
        return execute(sqlString: "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.matchConditions)")
        
    }
    
    public mutating func findRecords()->[Row]?{
        
        self.matchFields = nil // makes sure to calculate the names first before usin them the first time
        self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
        return select(sqlString: "SELECT * FROM \(typeAndTableName) WHERE \(sqlExpressions.matchConditions)")
    }
    
    
    //MARK: - Low level SQL functions from the GRDB framework
    
    private mutating func execute(sqlString:String)->[Row]?{
        
        let values = sqlExpressions.values
        do{
            try dataBase.inDatabase {db in
                debugger.log(debugLevel: .Message, sqlString, values)
                try db.execute(sqlString, arguments: StatementArguments(values))
            }
        }catch{
            debugger.log(debugLevel: .Error, error, values)
        }
        
        // Registers the rows that where affected by the previous execute
        var affectedRows:[Row]? = nil
        if primaryKeyNames != []{
            let pkFields = primaryKeyNames.joined(separator: ",")
            
            let sqlCommandType:String = String(describing: sqlString.split(separator: " ").first!).uppercased()
            if sqlCommandType == "INSERT"{
                self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
            }
            affectedRows = select(sqlString:"SELECT \(pkFields) FROM \(typeAndTableName) WHERE \(sqlExpressions.matchConditions)")
        }
        return affectedRows
    }
    
    private func select(sqlString:String)->[Row]?{
        
        let values = sqlExpressions.values
        do{
            return try dataBase.inDatabase {db in
                debugger.log(debugLevel: .Message, sqlString, values)
                return try Row.fetchAll(db, sqlString)
            }
        }catch{
            debugger.log(debugLevel: .Error, error, values)
            return nil
        }
        
    }
    
    
    private mutating func updateSqlExpressions(){
        
        // Return all properties as
        // an array of labels and an array of values
        // an array of label and value-pairs
        let introSpectionData = Mirror(reflecting: dataStruct)
        var propertyNames:[String] = []
        var propertyPairs:[String] = []
        var propertyValues:[Any] = []
        var propertyMatches:[String] = []
        
        for case let (propertyName?, propertyValue) in introSpectionData.children{
            
            if !primaryKeyNames.contains(propertyName){
                propertyNames.append(propertyName)
                propertyPairs.append("\(propertyName) = ?")
                
                // Try to downcast propertyValue (that might hide an optional) to a string
                let unwrappedAnyValue:Any = unwrap(any:propertyValue)
                propertyValues.append(unwrappedAnyValue)
                
                if let matchNames = matchFields{
                    var searchValue =  String(describing:unwrappedAnyValue)
                    if type(of:unwrappedAnyValue) == String.self{
                        searchValue = searchValue.quote()
                    }
                    
                    if (searchValue != "nil") && matchNames.contains(propertyName) && (searchValue != ""){
                        
                        // Use FileMaker compatible search-symbols
                        var searchExpression:String = "\(propertyName) = \(searchValue)"
                        
                        if searchValue == "="{ // Use = to find empty fields
                            searchExpression = "\(propertyName) = \"\""
                        }else if searchValue.leftString(numberOfchars: 1) == "!"{ // Use ! to find non-matching fields
                            searchExpression = "\(propertyName) <> \(searchValue)"
                        }
                        
                        propertyMatches.append(searchExpression)
                    }
                }
            }
        }
        
        let fieldNames:String = propertyNames.joined(separator: ",")
        let placeholders:String = Array(repeating: "?", count:Int(propertyNames.count)).joined(separator: ",")
        let fieldPairs = propertyPairs.joined(separator: ",")
        let fieldValues = propertyValues
        let matchConditions = propertyMatches.joined(separator: " AND ")
        
        sqlExpressions = (fieldNames, placeholders, fieldPairs, fieldValues, matchConditions)
    }    
    
 }
 
 
 
 
 
 
