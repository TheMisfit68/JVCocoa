//
//  JVTypeCasting.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 17/10/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

protocol Unwrappable {
    var unwrapped:Any {get}
}
extension Optional : Unwrappable {
    
//    public var unwrapped:Any {
//        switch self {
//        // If a nil is unwrapped it will crash!
//        case .none: return self as Any
//        case .some(let value): return value
//        }
//    }
    
}

// Unwrap an optional that might be hidden inside an Any
//func unwrapIfOptional<T>(optional: Optional<T>) -> T
//{
//    return optional!
//}

func unwrapIfOptional<T>(_ possibleOptional:T) -> T{
    if possibleOptional is Unwrappable{
        return possibleOptional!
    }else{
        
    }
}

