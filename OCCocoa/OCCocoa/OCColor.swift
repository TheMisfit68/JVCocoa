//
//  OCColor.swift
//  OCCocoa
//
//  Created by Jan Verrept on 3/01/15.
//  Copyright (c) 2015 OneClick. All rights reserved.
//

import Cocoa


public extension NSColor{
    
    
    /// Computed property used by XCodeColors
    public var consoleCode:NSString{
        
        let rgbRep = self.colorUsingColorSpace(NSColorSpace.genericRGBColorSpace())!
        let redValue = Int(rgbRep.redComponent*255)
        let blueValue = Int(rgbRep.blueComponent*255)
        let greenValue = Int(rgbRep.greenComponent*255)

        
        // Colorcodes defined by XCodeColors-plugin
        let ESCAPE = "\u{001b}["
        let SET_FG = "\(ESCAPE)fg"
        let consoleCode =  "\(SET_FG)" + "\(redValue),\(greenValue),\(blueValue)" + ";"
        return consoleCode

    }
    
    /// Computed Class property used by XCodeColors
    public class var defaultConsoleCode:NSString{
        
        // Colorcodes defined by XCodeColors-plugin

                let ESCAPE = "\u{001b}["
//                let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
//                let RESET_BG = ESCAPE + "bg;" // Clear any background color
                let defaultConsoleCode = ESCAPE + ";" // Clear any foreground or background color
                return defaultConsoleCode
    }
    
}
