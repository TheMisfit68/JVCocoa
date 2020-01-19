//
//  JVTypeCasting.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 17/10/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

// Unwrap an optional that might be stored inside an Any (without the ablility to downcast)
func unwrap<T>(any: T) -> Any
{
    let mirror = Mirror(reflecting: any)
    guard mirror.displayStyle == .optional, let first = mirror.children.first else {
        return any
    }
    return first.value
}
