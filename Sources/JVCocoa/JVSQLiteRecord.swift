 //
 //  JVSQLiteRecord.swift
 //  JVCocoa
 //
 //  Created by Jan Verrept on 25/08/17.
 //  Copyright © 2017 OneClick. All rights reserved.
 //
 
 import Foundation 
 
 /// This structure get initialized with a struct of some generic type and
 /// mirrors that struct in the SQLite-database
 
 class JVSQliteRecord<ModelType>: JVSQLiteSource{
    
    
    private let dataStruct:ModelType
    private let primaryKeyNames:[String]
    
    var matchFields:[String]?=nil{
        didSet {
            updateSqlExpressions()
        }
    }
    
    
    init(data:ModelType, in dataBase:DataBase){
        self.dataBase = dataBase
        self.dataStruct = data
        self.sourceName = String(describing: type(of: dataStruct))

        let tableName = _sourceName
        self.primaryKeyNames = dataBase.inDatabase {db in return try? db.primaryKey(tableName).columns} ?? []
    }
    
    var dataBase: DataBase{
        return _dataBase
    }
    
    var sourceName: String{
        return _sourceName
    }
    
    //MARK: - Use FileMaker-terminolgie to add persistensie to this structure
    
    public func changeOrCreateRecord(matchFields:[String]? = nil)->[Row]?{
        
        // This an Update or Insert a.k.a an 'UpSert'
        var affectedRows:[Row]?
        self.matchFields = matchFields
        affectedRows = execute(sqlString: "UPDATE \(sourceName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.matchConditions)")
        
        if (affectedRows == nil) || (affectedRows! == []){
            self.matchFields = nil
            affectedRows = execute(sqlString: "INSERT INTO \(sourceName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
        }
        return affectedRows
    }
    
    public func createRecord()->[Row]?{
        
        self.matchFields = nil
        return execute(sqlString: "INSERT INTO \(sourceName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))")
    }
    
    public func changeRecord(matchFields:[String])->[Row]?{
        
        self.matchFields = matchFields
        return execute(sqlString: "UPDATE \(sourceName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.matchConditions)")
        
    }
    
    public func findRecords()->[Row]?{
        
        self.matchFields = nil // makes sure to calculate the names first before usin them the first time
        self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
        return select(sqlString: "SELECT * FROM \(sourceName) WHERE \(sqlExpressions.matchConditions)")
    }
    
    
  
    
    
   
    
 }
 
 
 
 
 
 
