//
//  OCCalculator.swift
//  OCCocoa
//
//  Created by Administrator on 13/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public let π = M_PI

/**
Singleton Calculator class
*/

public let calculator:Calculator =  Calculator.sharedInstance

public class Calculator: Singleton {
    
    /// Return a singleton class variable
    public class var sharedInstance: Calculator {
        
        // Compensate for the lack of static/class constants
        // (there are only static/class computed variables)
        // by nesting them in a struct first
        struct ClassConstants {
            static let sharedInstance = Calculator()
        }
        return ClassConstants.sharedInstance
        
    }
    
    public func radiansToDegrees(radians: Double) -> Double{
        return radians/(2.0 * π)*360.0;
    }
    
    public func degreesToRadians(degrees: Double) -> Double{
        return degrees/360.0*(2.0 * π);
    }
    
}

