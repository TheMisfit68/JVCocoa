//
//  JVArray.swift
//  JVCocoa
//
//  Created by Jan Verrept on 26/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

extension Array {
    
    var firstIndex: Int? {
        return !self.isEmpty ?  0 :  nil
    }
    
    var lastIndex: Int? {
        return !self.isEmpty ? self.endIndex-1 : nil
    }
}

public func transpose<T>(input: [[T]]) -> [[T]] {
    if input.isEmpty { return [[T]]() }
    let count = input[0].count
    var out = [[T]](repeating: [T](), count: count)
    for outer in input {
        for (index, inner) in outer.enumerated() {
            out[index].append(inner)
        }
    }
    
    return out
}
