//
//  JVSQL.swift
//
//
//  Created by Jan Verrept on 10/12/2019.
//

import Foundation
import SQLite3

public typealias SQLID = Int
public typealias SQLBackend = OpaquePointer
public typealias SQLStatement = OpaquePointer
public typealias SQLRow = [Any?]

public struct SQLRecordSet{
    
    public var header:[String]
    public var data: [SQLRow]
    
    public func value<T>(rowNumber:Int = 0, columnName:String, copyInto result:inout T?){
        if (rowNumber >= 0), let columNumber = header.firstIndex(of: columnName){
            result = data[rowNumber][columNumber] as? T
        }else{
            result = nil
        }
    }
    
}

// MARK: - SQLDatabase

public class JVSQLdbase{
    
    var backend: SQLBackend?
    
    public class func Open(file:String)->JVSQLdbase{
        return JVSQLdbase(file: file)
    }
    
    init(file:String){
        backend = nil
        if sqlite3_open(file, &backend) == SQLITE_OK{
            
        }
    }
    
    public func close(){
        sqlite3_close(backend)
    }
    
    
    //MARK: Standard dbase functions
    
    public func changeOrCreateRecord<T:SQLRecordable>(record:T, matchFields:[String] = [])->SQLRecordSet?{
        
        // This an Update or Insert a.k.a an 'UpSert'
        var affectedRows = changeRecord(record: record, matchFields:matchFields)
        
        if (affectedRows == nil){
            affectedRows = create(record: record)
        }
        return affectedRows
    }
    
    public func changeRecord<T:SQLRecordable>(record:T, matchFields:[String])->SQLRecordSet?{
        
        // Determine the rows that wil be affected by the update before making in any actual changes
        var request = record
        request.matchFields = matchFields
        let affectedRows:SQLRecordSet? = select(statement:"SELECT * FROM \(record.tableName) WHERE \(request.matchConditions)")
        
        execute(statement: "UPDATE \(record.tableName) SET \(record.pairs) WHERE \(request.matchConditions)", data: record.values)
        
        return affectedRows
    }
    
    public func create<T:SQLRecordable>(record:T)->SQLRecordSet?{
        execute(statement: "INSERT INTO \(record.tableName) (\(record.names)) VALUES (\(record.placeholders))", data: record.values)
        //        let  pk = sqlite3_last_insert_rowid(backend)
        let request = record
        return find(record: request, matchFields: request.primaryKeyNames)
    }
    
    public func find<T:SQLRecordable>(record:T, matchFields: [String])->SQLRecordSet?{
        
        var request = record
        request.matchFields = matchFields
        
        let selectedRows:SQLRecordSet? = select(statement: "SELECT * FROM \(request.tableName) WHERE \(request.matchConditions)")
        return selectedRows
    }
    
    
    //MARK: Base level SQL functions
    
    public func select(statement selectStatementString:String)->SQLRecordSet?{
        
        JVDebugger.shared.log(debugLevel: .Info, selectStatementString)
        
        var header:[String] = []
        var rows:[SQLRow] = []
        
        // Create a prepared statement
        var selectStatement: SQLStatement? = nil
        if sqlite3_prepare_v2(backend, selectStatementString, -1, &selectStatement, nil) == SQLITE_OK {
            
            // Parse the result
            while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                let columnCount:Int32 = sqlite3_column_count(selectStatement)
                
                var row:SQLRow = []
                for zeroBasedColumnNumber in 0...columnCount-1 {
                    
                    let columnName: String = String(cString: sqlite3_column_name(selectStatement, zeroBasedColumnNumber))
                    let columnType:Int32 = sqlite3_column_type(selectStatement, zeroBasedColumnNumber)
                    var columnValue:Any? = nil
                    
                    // On first run also compose the header
                    if rows.count == 0{
                        header.append(columnName)
                    }
                    
                    switch columnType{
                    case SQLITE_INTEGER:
                        columnValue = Int(sqlite3_column_int(selectStatement, zeroBasedColumnNumber))
                    case SQLITE_FLOAT:
                        columnValue = Double(sqlite3_column_double(selectStatement, zeroBasedColumnNumber))
                    case SQLITE_TEXT:
                        columnValue = String(cString: sqlite3_column_text(selectStatement, zeroBasedColumnNumber))
                    case SQLITE_BLOB:
                        let count = sqlite3_column_bytes(selectStatement, zeroBasedColumnNumber)
                        if let bytes = sqlite3_column_blob(selectStatement, zeroBasedColumnNumber) {
                            columnValue = Data(bytes: bytes, count: Int(count))
                        }
                        else {
                            columnValue = nil
                        }
                    case SQLITE_NULL:
                        columnValue = nil
                    default:
                        columnValue = nil
                    }
                    
                    row.append(columnValue)
                }
                
                rows.append(row)
            }
            
        } else{
            JVDebugger.shared.log(debugLevel: .Error,  "Statement '\(selectStatementString)' could not be prepared")
        }
        
        sqlite3_finalize(selectStatement)
        
        if (rows.count > 0) {
            return SQLRecordSet(header: header, data: rows)
        }else{
            return nil
        }
        
    }
    
    public func execute(statement executeStatementString:String, data:[Any?]){
        
        var executeStatement: SQLStatement? = nil
        if sqlite3_prepare_v2(backend, executeStatementString, -1, &executeStatement, nil) == SQLITE_OK {
            
            // Parse the Data
            let valueCount:Int = data.count
            
            for valueNumber in 0...valueCount-1 {
                let oneBasedColumNumber = Int32(valueNumber+1) // COLUMS FOR BINDINGS ARE 1-BASED
                let value:Any? = data[valueNumber]
                
                switch value{
                case let intvalue as Int:
                    sqlite3_bind_int(executeStatement, oneBasedColumNumber, Int32(intvalue))
                case let intvalue as UInt:
                    sqlite3_bind_int(executeStatement, oneBasedColumNumber, Int32(intvalue))
                case let intvalue as UInt32:
                    sqlite3_bind_int(executeStatement, oneBasedColumNumber, Int32(intvalue))
                case let doubleValue as Double:
                    sqlite3_bind_double(executeStatement, oneBasedColumNumber, doubleValue)
                case let stringValue as String:
                    sqlite3_bind_text(executeStatement, oneBasedColumNumber, (stringValue as NSString).utf8String, -1, nil)
                case let dataValue as Data:
                    _ = dataValue.withUnsafeBytes{
                        sqlite3_bind_blob(executeStatement, oneBasedColumNumber, $0.baseAddress, Int32($0.count), nil)
                    }
                default:
                    JVDebugger.shared.log(debugLevel: .Error,  "Binding of \(value ?? "nil") is not supported by JVSQL")
                    break
                }
            }
        } else{
            JVDebugger.shared.log(debugLevel: .Error,  "Statement '\(executeStatementString)' could not be prepared")
        }
        let result = sqlite3_step(executeStatement)
        if result != SQLITE_DONE {
            JVDebugger.shared.log(debugLevel: .Error,  "Error \(result) while executing '\(executeStatementString)'")
        }
        
        sqlite3_finalize(executeStatement)
    }
    
    
    public func autoCreateSqlTables<T>(forTypes recordTypes:[T]){
        
        recordTypes.forEach{ recordType in
            
            let tableName = String(describing: recordType)
            let existingTables:SQLRecordSet? = select(statement:"SELECT name FROM sqlite_master WHERE type='table' AND name='\(tableName)'")
            
            if existingTables == nil{
                
                let typeProperties = propertyInfo(of: recordType)
                var fieldDefinitions:[String] = []
                
                for case let (name?, value) in typeProperties {
                    let fieldName:String = name
                    var fieldType:String = "INTEGER"
                    
                    switch value{
                    case is Int, is UInt, is UInt32:
                        fieldType = "INTEGER"
                    case is Float, is Double:
                        fieldType = "REAL"
                    case is String:
                        fieldType = "TEXT"
                    case is Data:
                        fieldType = "BLOB"
                    default:
                        let keyStyle = Mirror(reflecting: value).displayStyle
                        let isToOneRelationShip = (keyStyle == .struct) || (keyStyle == .class)
                        let isToManyRelationShip = (keyStyle == .collection)
                        
                        JVDebugger.shared.log(debugLevel: .Error,  "SQL-fields of type \(typeName(of: value)) couldn't be created")
                        break
                    }
                    
                    fieldDefinitions.append("\(fieldName) \(fieldType)")
                }
                
                let executeStatementString = "CREATE TABLE \(tableName)( \(fieldDefinitions.joined(separator: ",")) )"
                
                execute(statement:executeStatementString, data:[])
            }
        }
    }
    
    
}

// MARK: - SQLRecordable protocol
public protocol SQLRecordable: SQLExpressable {
    
    func updateOrAdd(matchFields: [String])->SQLRecordSet?
    func update(matchFields: [String])->SQLRecordSet?
    func add()->SQLRecordSet?
    
    func find(matchFields: [String])->SQLRecordSet?
    
}

public extension SQLRecordable{
    
    func updateOrAdd(matchFields: [String])->SQLRecordSet?{
        return dbase?.changeOrCreateRecord(record: self, matchFields:matchFields)
    }
    
    func update(matchFields: [String])->SQLRecordSet?{
        return dbase?.changeRecord(record: self, matchFields: matchFields)
    }
    
    func add()->SQLRecordSet?{
        return dbase?.create(record: self)
    }
    
    func find(matchFields: [String])->SQLRecordSet?{
        return dbase?.find(record: self, matchFields: matchFields)
        
    }
    
}

// MARK: - SQLExpressable protocol

public protocol SQLExpressable: SQLSource{
    
    var names:String { get }
    var placeholders:String { get }
    var pairs:String { get }
    var values:[Any] { get }
    
    var matchFields: [String]? { get set }
    var matchConditions:String { get }
    
}

public extension SQLExpressable{
    
    var matchFields: [String]?{
        get{
            return property(name: "matchFields") as? [String]
        }
        set{
            setProperty(name: "matchFields", to: newValue as Any)
        }
    }
    
    var names: String{
        let propertiesIntrospection = propertyInfo(of: self)
        return propertiesIntrospection.compactMap( {shouldBeIncluded($0) ? $0.label! : nil} ).joined(separator: ",")
    }
    
    var placeholders: String{
        let propertiesIntrospection = propertyInfo(of: self)
        return propertiesIntrospection.compactMap( {shouldBeIncluded($0) ? "?" : nil} ).joined(separator: ",")
    }
    
    var pairs: String{
        let propertiesIntrospection = propertyInfo(of: self)
        return propertiesIntrospection.compactMap( {shouldBeIncluded($0) ? "\($0.label!)=?" : nil} ).joined(separator: ",")
    }
    
    var values: [Any]{
        let propertiesIntrospection = propertyInfo(of: self)
        return propertiesIntrospection.compactMap( {shouldBeIncluded($0) ? unwrap(any:$0.value) : nil} ) // Try to downcast the Any-property (that might hide an optional) to a string
    }
    
    var matchConditions:String{
        let propertiesIntrospection = propertyInfo(of: self)
        return propertiesIntrospection.compactMap( {
            var matchCondition:String? = nil
            if shouldGetMatchedAgainst($0) {
                
                // Get the propertyname
                let propertyName = $0.label!
                
                // Convert the propertvalue into a string that one can search for
                let propertyValue = $0.value
                let unwrappedAnyValue:Any = unwrap(any:propertyValue) // unwrap optionals that might hide in the Any-value
                var searchValue =  String(describing:unwrappedAnyValue)
                if type(of:unwrappedAnyValue) == String.self{
                    searchValue = searchValue.quote()
                }
                
                // Create different kind of conditions to search for using the propertyname and a value
                if primaryKeyNames.contains(propertyName) && ((searchValue != "") || (searchValue != "nil")){ // Find unknown PKs
                    if let bakend = dbase?.backend{
                        //TODO: include support for multiple-field-PKs
                        let newPK = sqlite3_last_insert_rowid(bakend)
                        matchCondition = "\(propertyName) = \(newPK)"
                    }
                }else if searchValue == "="{ // Use = to find empty fields
                    matchCondition = "\(propertyName) = \"\""
                }else if searchValue.leftString(numberOfchars: 1) == "!"{ // Use ! to find non-matching fields
                    matchCondition = "\(propertyName) <> \(searchValue)"
                }else if (searchValue != "") && (searchValue != "nil") {
                    matchCondition = "\(propertyName) = \(searchValue)" // Default condition
                }
            }
            return matchCondition
        } ).joined(separator: " AND ")
    }
    
    private func shouldBeIncluded(_ property:Mirror.Child)->Bool{
        guard (property.label != nil) else {return false}
        
        return !primaryKeyNames.contains(property.label!)
    }
    
    private func shouldGetMatchedAgainst(_ property:Mirror.Child)->Bool{
        guard (property.label != nil) else {return false}
        
        if (matchFields == nil) && (!primaryKeyNames.contains(property.label!)) {
            return true
        }else {
            return matchFields?.contains(property.label!) ?? false
        }
    }
    
}

// MARK: - SQLSource protocol

public protocol SQLSource: FullyExtendable{
    
    var dbase:JVSQLdbase? { get set }
    var tableName:String { get }
    var primaryKeyNames:[String] { get }
    
}

public extension SQLSource{
    
    var dbase: JVSQLdbase?{
        get{
            return property(name: "dbase") as? JVSQLdbase
        }
        set{
            setProperty(name: "dbase", to: newValue as Any)
        }
    }
    
    var tableName:String{
        return String(describing: type(of: self))
    }
    
    var primaryKeyNames: [String]{
        get{
            return property(name: "primaryKeyNames") as? [String] ?? [tableName.lowercased()+"ID"]
        }
        set{
            setProperty(name: "primaryKeyNames", to: newValue as Any)
        }
    }
    
}


//TODO: - Mimic FileMaker-methodologie based on JVSQLdbase

//public class JVFPproxy:JVSQLdbase{
//
//    public enum Mode{
//        case layout
//        case browse
//        case find
//    }
//
//
//    public func gotoLayout(name:String){
//
//    }
//
//    public func enterMode(_ mode:Mode){
//
//    }
//
//    public func addRecord{
//
//    }
//
//    public func addRequest{
//
//    }
//
//}

