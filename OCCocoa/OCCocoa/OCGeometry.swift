//
//  OCGeometry.swift
//  OCCocoa
//
//  Created by Jan Verrept on 21/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public extension NSRect{
    
    init(aRect:NSRect){
        origin = aRect.origin
        size = aRect.size
    }
    
    public var area: Double {
        return Double(size.width * size.height)
    }
    
    public var center: NSPoint {
        get {
            return NSPoint(x:CGRectGetMidX(self),y:CGRectGetMidY(self))
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    
    public mutating func expand(dX: Float, dY: Float){
        origin.x-=CGFloat(dX)
        origin.y-=CGFloat(dY)
        size.width+=2.0*CGFloat(dX)
        size.height+=2.0*CGFloat(dY);
    }
    
}