////
////  JVSQLiteSource.swift
////  MacSunnySender
////
////  Created by Jan Verrept on 9/12/17.
////  Copyright © 2017 OneClick. All rights reserved.
////
//
//import Foundation
//import GRDB
//
//typealias Database = DatabaseQueue
//
//extension Database{
//    
//    public func source(using model:Any)->JVSQLiteSource<Any> {
//        return JVSQLiteSource(model:model, in:self)
//    }
//    
//}
//
//
//class JVSQLiteSource<dataModel>{
//    
//    typealias ID = Int
//
//    private let backendStore:DatabaseQueue
//    private let source:dataModel
//    private let sourceName:String
//    private let primaryKeyNames:[String]
//    private var sqlExpressions = (names:"", placeholders:"", pairs:"", values:[], matchConditions:"")
//    
//    var matchFields:[String]?=nil{
//        didSet {
//            updateSqlExpressions()
//        }
//    }
//    
//    init(model:dataModel, in dataBase:DatabaseQueue){
//        
//        self.backendStore = dataBase
//        
//        let modelType = Mirror(reflecting: source).displayStyle
//        switch modelType {
//        case 'struct':
//            self.model = model
//        case 'class':
//            self.model = model
//        default:
//            <#code#>
//        }
//        
//        
//        if let sourceString = source as? String{
//            self.sourceName = sourceString
//        }else{
//            self.source = source
//            self.sourceName = String(describing: type(of: source))
//        }
//    }
//    
//    //MARK: - Low level SQL functions from the GRDB framework
//    
//    private func execute(sqlString:String)->[Row]?{
//        
//        let values = sqlExpressions.values
//        do{
//            try backendStore.inDatabase {db in
//                debugger.log(debugLevel: .Message, sqlString, values)
//                try db.execute(sqlString, arguments: StatementArguments(values))
//            }
//        }catch{
//            debugger.log(debugLevel: .Error, error, values)
//        }
//        
//        // Registers the rows that where affected by the previous execute
//        var affectedRows:[Row]? = nil
//        if primaryKeyNames != []{
//            let pkFields = primaryKeyNames.joined(separator: ",")
//            
//            let sqlCommandType:String = String(describing: sqlString.split(separator: " ").first!).uppercased()
//            if sqlCommandType == "INSERT"{
//                self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
//            }
//            affectedRows = select(sqlString:"SELECT \(pkFields) FROM \(sourceName) WHERE \(sqlExpressions.matchConditions)")
//        }
//        return affectedRows
//    }
//    
//    private func select(sqlString:String)->[Row]?{
//        
//        let values = sqlExpressions.values
//        do{
//            return try backendStore.inDatabase {db in
//                debugger.log(debugLevel: .Message, sqlString, values)
//                return try Row.fetchAll(db, sqlString)
//            }
//        }catch{
//            debugger.log(debugLevel: .Error, error, values)
//            return nil
//        }
//        
//    }
//    
//    private func updateSqlExpressions(){
//        
//        // Return all properties as
//        // an array of labels and an array of values
//        // an array of label and value-pairs
//        let introSpectionData = Mirror(reflecting: source)
//        var propertyNames:[String] = []
//        var propertyPairs:[String] = []
//        var propertyValues:[Any] = []
//        var propertyMatches:[String] = []
//        
//        for case let (propertyName?, propertyValue) in introSpectionData.children{
//            
//            if !primaryKeyNames.contains(propertyName){
//                propertyNames.append(propertyName)
//                propertyPairs.append("\(propertyName) = ?")
//                
//                // Try to downcast propertyValue (that might hide an optional) to a string
//                let unwrappedAnyValue:Any = unwrap(any:propertyValue)
//                propertyValues.append(unwrappedAnyValue)
//                
//                if let matchNames = matchFields{
//                    var searchValue =  String(describing:unwrappedAnyValue)
//                    if type(of:unwrappedAnyValue) == String.self{
//                        searchValue = searchValue.quote()
//                    }
//                    
//                    if (searchValue != "nil") && matchNames.contains(propertyName) && (searchValue != ""){
//                        
//                        // Use FileMaker compatible search-symbols
//                        var searchExpression:String = "\(propertyName) = \(searchValue)"
//                        
//                        if searchValue == "="{ // Use = to find empty fields
//                            searchExpression = "\(propertyName) = \"\""
//                        }else if searchValue.leftString(numberOfchars: 1) == "!"{ // Use ! to find non-matching fields
//                            searchExpression = "\(propertyName) <> \(searchValue)"
//                        }
//                        
//                        propertyMatches.append(searchExpression)
//                    }
//                }
//            }
//        }
//        
//        let fieldNames:String = propertyNames.joined(separator: ",")
//        let placeholders:String = Array(repeating: "?", count:Int(propertyNames.count)).joined(separator: ",")
//        let fieldPairs = propertyPairs.joined(separator: ",")
//        let fieldValues = propertyValues
//        let matchConditions = propertyMatches.joined(separator: " AND ")
//        
//        sqlExpressions = (fieldNames, placeholders, fieldPairs, fieldValues, matchConditions)
//    }    
//}
