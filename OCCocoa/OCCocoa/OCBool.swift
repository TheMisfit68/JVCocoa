//
//  OCBool.swift
//  OCCocoa
//
//  Created by Administrator on 14/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public extension Bool {

	public mutating func toggle(enable:Bool = true){
		self = (self ^^ enable)
	}
	
}


// Logical XOR operator
infix operator ^^ { associativity left precedence 120 }

func ^^<T : BooleanType, U : BooleanType>(lhs: T, rhs: U) -> Bool {
    return lhs.boolValue != rhs.boolValue
}