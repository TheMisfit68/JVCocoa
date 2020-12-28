//
//  JVColor.swift
//  
//
//  Created by Jan Verrept on 26/07/2020.
//




@available(OSX 10.15, *)
public extension Color {
    
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
}


import SwiftUI
#if os(OSX)
import Cocoa
public  typealias PlatFormColor = NSColor
#else
import UIKit
public  typealias PlatFormColor = UIColor
#endif

extension PlatFormColor {
    
    func lighter(amount : CGFloat = 0.25) -> PlatFormColor {
        return hueColorWithBrightnessAmount(amount: 1 + amount)
    }
    
    func darker(amount : CGFloat = 0.25) -> PlatFormColor {
        return hueColorWithBrightnessAmount(amount: 1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(amount: CGFloat) -> PlatFormColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        
        #if os(iOS)
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return PlatFormColor( hue: hue,
                                  saturation: saturation,
                                  brightness: brightness * amount,
                                  alpha: alpha )
        } else {
            return self
        }
        
        #else
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return PlatFormColor( hue: hue,
                              saturation: saturation,
                              brightness: brightness * amount,
                              alpha: alpha )
        
        #endif
        
    }
    
}


