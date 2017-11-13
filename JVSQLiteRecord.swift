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
    
    
    let dataStruct:ModelType
    let dataBase:DatabaseQueue
    var matchFields:[String]?
    var newPrimaryKey:ID?
    
    init(data:ModelType, in dataBase:DataBase){
        self.dataStruct = data
        self.dataBase = dataBase
    }
    
    private var typeAndTableName:String{
        get{
            return String(describing: type(of: dataStruct))
        }
    }
    
    
    //MARK: - Use FileMaker-terminolgie to add persistensie to this structure
    
    public mutating func changeOrCreateRecord(matchFields:[String]? = nil)->Bool{
        
        // This an Update or Insert a.k.a an 'UpSert'
        var recordChanged:Bool = false
        if matchFields != nil{
            recordChanged = changeRecord(matchFields:matchFields!)
        }
        if (matchFields == nil) || !recordChanged{
            return createRecord()
        }
        return true
    }
    
    public mutating func createRecord()->Bool{
        
        self.matchFields = nil
        // Make this a single return statement again
        let sqlSuccesfullyExecuted = execute(sqlString: "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
        
        // Check extra conditions and store any newPrimaryKey
        if sqlSuccesfullyExecuted{
            return dataBase.inDatabase {db in
                
                if let primaryKeyName = try? db.primaryKey(typeAndTableName){
                    if let latestPK = try? Int.fetchOne(db, "SELECT \(primaryKeyName) FROM '\(typeAndTableName)' ORDER BY DESC"){
                        if latestPK != newPrimaryKey{
                            newPrimaryKey = latestPK
                            return true
                        }
                    }
                }
                return false
            }
            
        }else{
            return false
        }
    }
    
    public mutating func changeRecord(matchFields:[String])->Bool{
        
        self.matchFields = matchFields
        let sqlSuccesfullyExecuted = execute(sqlString: "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.conditions)")
        
        // Check extra conditions
        if sqlSuccesfullyExecuted{
            return dataBase.inDatabase {db in return (db.changesCount > 0)}
        }else{
            return false
        }
    }
    
    public mutating func findRecords()->[Row]?{
        
        self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
        let  recordsFound:[Row]? = select(sqlString: "SELECT * FROM \(typeAndTableName) WHERE \(sqlExpressions.conditions)")
        
        return recordsFound
    }
    
    //MARK: - Low level SQL functions from the GRDB framework
    
    private func execute(sqlString:String)->Bool{
        
        let values = sqlExpressions.values
        do{
            try dataBase.inDatabase {db in
                debugger.log(debugLevel: .Message, sqlString, values)
                try db.execute(sqlString, arguments: StatementArguments(values))
            }
        }catch{
            debugger.log(debugLevel: .Error, error, values)
            return false
        }
        return true
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
    
    // Format fieldnames, values, matching-conditions, ...
    // for easy use within SQL -statements
    private var sqlExpressions:(names:String, placeholders:String, pairs:String, values:[Any], conditions:String){
        get{
            
            // Return all properties as an array of labels and an array of values
            let introSpectionData = Mirror(reflecting: dataStruct)
            var propertyNames:[String] = []
            var propertyPairs:[String] = []
            var propertyValues:[Any] = []
            var propertyMatches:[String] = []
            
            for case let (propertyName?, propertyValue) in introSpectionData.children{
                
                propertyNames.append(propertyName)
                propertyPairs.append("\(propertyName) = ?")
                
                // Try to downcast propertyValue (that might hide an optional) to a string
                let unwrappedAnyValue:Any = unwrap(any:propertyValue)
                propertyValues.append(unwrappedAnyValue)
                
                if let matchNames = matchFields{
                    let searchValue =  String(describing:unwrappedAnyValue)
                    if matchNames.contains(propertyName) && (searchValue != ""){
                        
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
            
            let fieldNames:String = propertyNames.joined(separator: ",")
            let placeholders:String = Array(repeating: "?", count:Int(propertyNames.count)).joined(separator: ",")
            let fieldPairs = propertyPairs.joined(separator: ",")
            let fieldValues = propertyValues
            let matchConditions = propertyMatches.joined(separator: " AND ")
            
            return (fieldNames, placeholders, fieldPairs, fieldValues, matchConditions)
        }
    }
    
    
 }
 
 
 
