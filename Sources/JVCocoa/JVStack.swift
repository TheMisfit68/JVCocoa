//
//  JVStack.swift
//  JVCocoa
//
//  Created by Administrator on 8/09/14.
//  Copyright (c) 2014 OneClick BVBA. All rights reserved.
//


public struct JVStack<T> {
    var items = [T]()
	public mutating func push(item: T) {
		items.append(item)
	}
	public mutating func pop() -> T {
		return items.removeLast()
	}
    
}
