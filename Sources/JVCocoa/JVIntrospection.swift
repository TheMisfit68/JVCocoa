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


public func className<T:AnyObject>(object:T) -> String{
    
    return    NSStringFromClass(type(of: object))

}
