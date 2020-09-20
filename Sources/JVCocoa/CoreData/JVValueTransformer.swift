//
//  JVValueTransformer.swift
//  
//
//  Created by Jan Verrept on 26/07/2020.
//

import CoreData

public class EnumTransformer<Enumeration:RawRepresentable>:ValueTransformer where Enumeration.RawValue == Int{
    
    let enumerationTypeName:String
    var rawValueTypeName:String
    public var transformerName:NSValueTransformerName{
        NSValueTransformerName("\(enumerationTypeName)Transformer")
    }
    
    public init(_ enumeration:Enumeration.Type){
        enumerationTypeName = "\(type(of:enumeration))"
        rawValueTypeName = "\(type(of:enumeration.RawValue.self))"
        super.init()
        
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let enumerationValue = value as? Enumeration else {
            fatalError("Wrong enumeration type: value must be a \(enumerationTypeName); received \(type(of: value))")
        }
        return enumerationValue.rawValue
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let enumerationRawValue = value as? Enumeration.RawValue else {
            fatalError("Wrong rawvalue type: value must be a \(rawValueTypeName); received \(type(of: value))")
        }
        return Enumeration.init(rawValue: enumerationRawValue)
    }
    
}

