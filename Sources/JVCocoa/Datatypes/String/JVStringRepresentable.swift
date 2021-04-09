//
//  JVStringRepresentable.swift
//  
//
//  Created by Jan Verrept on 04/05/2020.
//

import Foundation

// For Any Stringrepresentable
public protocol StringRepresentable:Hashable {
	var stringValue:String{get}
}


// Make members of StringProtocol conform by default
extension String:StringRepresentable {
	public var stringValue:String{
		return self
	}
}


extension Substring:StringRepresentable {
	public var stringValue:String{
		return String(self)
	}
}


// For Enums with a rawvalue of type String
public protocol StringRepresentableEnum: StringRepresentable & RawRepresentable where Self.RawValue == String{}

public extension StringRepresentableEnum {
	var stringValue:String{
		return self.rawValue as String
	}
}


