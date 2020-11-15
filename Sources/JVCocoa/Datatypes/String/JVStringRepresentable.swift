//
//  JVStringRepresentable.swift
//  
//
//  Created by Jan Verrept on 04/05/2020.
//

import Foundation

// For Any Stringrepresentable
public protocol StringRepresentable { var stringValue:String{get} }
// For Enums
public protocol StringRepresentableEnum: StringRepresentable & RawRepresentable & Hashable {}


// Implemenation for rawsrepresentable Strings
public extension StringRepresentable where Self:RawRepresentable, Self.RawValue == String{
     var stringValue:String{
        return self.rawValue as String
    }
}

// Implemenation for other type of Strings
public extension StringRepresentable where Self:StringProtocol {
     var stringValue:String{
        return String(describing: self)
    }
}

