//
//  JVLogger.swift
//  
//
//  Created by Jan Verrept on 14/11/2020.
//

import Foundation
import os.log


extension OSLogType{
    
    public var Icon:String{
        
        switch self {
        case OSLogType.fault:
            return "🛑"
        case OSLogType.error:
            return "❌"
        case OSLogType.info:
            return "ℹ️"
        case OSLogType.debug:
            return "🐞"
        case OSLogType.default:
            return ""
        default:
            return ""
        }
        
    }
}
