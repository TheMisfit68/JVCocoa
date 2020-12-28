//
//  JVBool.swift
//  JVCocoa
//
//  Created by Administrator on 14/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

/**
 Swift Logical XOR operator (a.k.a. 'Bit controlled inverter')
 
 true  ^^ true   // false
 true  ^^ false  // true
 false ^^ true   // true
 false ^^ false  // false
 
 */

precedencegroup booleanOperatorPrecedence {
    associativity: left
}

infix operator ^^ : booleanOperatorPrecedence
public func ^^(left: Bool, right: Bool) -> Bool {
    return (left != right)
}


public extension String{
     var equalsTrue:Bool{
        return (
                lowercased() == "true" ||
                lowercased() == "yes" ||
                lowercased() == "on" ||
                lowercased() == "1"  )
    }
}

