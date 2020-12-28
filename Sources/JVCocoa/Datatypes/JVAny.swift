//
//  JVAny.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 17/10/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

protocol Unwrappable{
    var unwrapped:Any {get}
}

extension Optional:Unwrappable{
    
    public var unwrapped:Any {
        switch self {
        case .none: return self as Any         // If a nil was unwrapped it would crash!
        case .some(let value): return value
        }
    }
    
}

// Unwrap an optional that might be hidden inside an Any
func unwrapIfOptional<T>(any:T)->Any{
    
    if let optional = any as? Unwrappable{
        return optional.unwrapped
    }else{
        return any
    }

}

