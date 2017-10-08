//
//  JVGeometry.swift
//  JVCocoa
//
//  Created by Jan Verrept on 21/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public extension NSRect{
    
    public var area: Double {
        return Double(size.width * size.height)
    }
    
    public var center: NSPoint {
        get {
            return NSPoint(x:self.midX,y:self.midY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    
    public mutating func expandBy(dX: Float, dY: Float){
        origin.x-=CGFloat(dX)
        origin.y-=CGFloat(dY)
        size.width+=2.0*CGFloat(dX)
        size.height+=2.0*CGFloat(dY);
    }
    
}
