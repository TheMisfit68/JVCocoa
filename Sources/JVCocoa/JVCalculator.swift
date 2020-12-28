//
//  JVCalculator.swift
//  JVCocoa
//
//  Created by Administrator on 13/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation


/*
Singleton Calculator class
*/


public class JVCalculator: Singleton {
    
    public static let shared:JVCalculator =  JVCalculator()
    private init(){}

    public let π = Double.pi
    
    public func radiansToDegrees(radians: Double) -> Double{
        return radians/(2.0 * π)*360.0;
    }
    
    public func degreesToRadians(degrees: Double) -> Double{
        return degrees/360.0*(2.0 * π);
    }
    
}

