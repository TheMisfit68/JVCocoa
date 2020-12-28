//
//  JVIntrospection.swift
//  JVCocoa
//
//  Created by Jan Verrept on 15/11/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

/* Type introspection is seldom used in Swift because of the ability to use
generics together with function overloading !!!
Instead of using introspection within a function just use several generic functions one for each type you want to implement */

public func typeName<T:Any>(of typeToDescribe:T) -> String{
    
    let typeInfo = Mirror(reflecting: typeToDescribe)
    let typeName = typeInfo.subjectType

    return  String(describing: type(of: typeName)).replacingOccurrences(of: ".Type", with: "")
}

// Alias of the function above
public func className<T:AnyObject>(of objectToDescribe:T) -> String{
    return  typeName(of: objectToDescribe)
}

public func propertyInfo<T:Any>(of typeToDescribe:T) -> Mirror.Children{
    let typeInfo = Mirror(reflecting: typeToDescribe)
    return typeInfo.children
}
