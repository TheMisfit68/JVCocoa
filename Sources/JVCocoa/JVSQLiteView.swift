//
//  JVSQLiteView.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 9/12/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import GRDB

class JVSQLiteView: JVSQLiteSource<Any>{
    
    let dataBase:DataBase
    let name:String
    
    init(name:String, in dataBase:DataBase){
        self.dataBase = dataBase
        self.name = name
    }
    
    var sourceName: String{
        return name
    }
    
    internal func select(sqlString:String)->[Row]?{
        return nil
    }
}
