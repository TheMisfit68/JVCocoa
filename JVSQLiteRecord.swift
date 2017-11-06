 //
 //  JVSQLiteRecord.swift
 //  JVCocoa
 //
 //  Created by Jan Verrept on 25/08/17.
 //  Copyright © 2017 OneClick. All rights reserved.
 //
 
 import Foundation
 import GRDB
 
 
 typealias ID = Int
 typealias DataBase = DatabaseQueue
 
 protocol JVSQliteRecordable: FullyExtendable{
    
    var dataBase:DataBase{get set}
    var lastprimaryKey:Int?{get}
    
 }
 
 /// This structure get initialized with a struct of some generic type and
 /// mirrors that struct in the SQLite-database
 
 extension JVSQliteRecordable{
    
//    init(in dBase:DataBase){
//        dataBase = dBase
//    }
    
    //MARK: - Associated properties due to the lack of stored properties in an extension

    public var dataBase:DataBase{
        get{
           return property(name: "dataBase") as! DataBase
        }
        set{
            setProperty(name: "dataBase", to: newValue)
        }
    }
    
    private var typeAndTableName:String{
        get{
            return String(describing: type(of: self))
        }
    }
    
    private var matchFields:[String]?{
        get{
            return property(name: "matchFields") as! [String]?
        }
        set{
            setProperty(name: "matchFields", to: newValue as Any)
        }
    }
    
    private var lastStoredID:ID?{
        get{
            return property(name: "lastStoredID") as! Int?
        }
        set{
            setProperty(name: "lastStoredID", to: newValue as Any)
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
    
    public mutating func findRecords()->[Row]?{
        
        self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
        let  recordsFound:[Row]? = select(sqlString: "SELECT * FROM \(typeAndTableName) WHERE \(sqlExpressions.conditions)")

        return recordsFound
    }
    
    public mutating func createRecord()->Bool{
        
        self.matchFields = nil
        return execute(sqlString: "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
        
    }
    
    
    public mutating func changeRecord(matchFields:[String])->Bool{
        
        self.matchFields = matchFields
        return execute(sqlString: "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.conditions)")
        
    }
    
    
    //MARK: - Low level SQL functions from the GRDB framework
    
    private func execute(sqlString:String)->Bool{
        
        let values = sqlExpressions.values
        do{
            try dataBase.inDatabase {db in
                debugger.log(debugLevel: .message, sqlString, values)
                try db.execute(sqlString, arguments: StatementArguments(values))
            }
        }catch{
            debugger.log(debugLevel: .error, error, values)
            return false
        }
        return true
    }
    
    private func select(sqlString:String)->[Row]?{
        
        let values = sqlExpressions.values
        do{
            return try dataBase.inDatabase {db in
                debugger.log(debugLevel: .message, sqlString, values)
                return try Row.fetchAll(db, sqlString)
            }
        }catch{
            debugger.log(debugLevel: .error, error, values)
            return nil
        }
        
    }
    
    // Format fieldnames, values, matching-conditions, ...
    // for easy use within SQL -statements
    private var sqlExpressions:(names:String, placeholders:String, pairs:String, values:[Any], conditions:String){
        get{
            
            // Return all properties as an array of labels and an array of values
            let introSpectionData = Mirror(reflecting: self)
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
    
    public mutating func lastPrimaryKey()->ID?{
        
        do{
            return try dataBase.inDatabase {db in
                let newID = try Int.fetchOne(db, "SELECT seq FROM sqlite_sequence WHERE name='\(typeAndTableName)'")
                if lastStoredID != newID{
                    lastStoredID = newID
                    return newID
                }else{
                    return nil
                }
                
            }
        }catch{
            return nil
        }
    }
    
 }
 
 
 
