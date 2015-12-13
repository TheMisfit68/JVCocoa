//
//  OCDebugger.swift
//  OCCocoa
//
//  Created by Jan Verrept on 3/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation


/*
A dictionary containing all environmental variables that where set in your building scheme
*/
public let environmentalVars = NSProcessInfo.processInfo().environment

/**
Singleton Debugger class
*/

//TODO: Replace the first macro with the second one whenever it is possible to replace the empty string
//with a default argument of self, a.k.a. the caller-side-object that you want to log

public let debugger:Debugger =  Debugger.sharedInstance
//public let printThisMethod:() = Debugger.sharedInstance.printThisMethod("")

public class Debugger: Singleton {
    
    /// Return a singleton class variable
    public class var sharedInstance: Debugger {
        
        // Compensate for the lack of static/class constants
        // (there are only static/class computed variables)
        // by nesting them in a struct first
        struct ClassConstants {
            static let sharedInstance = Debugger()
        }
        return ClassConstants.sharedInstance
        
    }
    
    
    public func printThisMethod<T:Any>(
        
        statement:T ,
        _ color:NSColor? = nil ,
        var _ function: String = __FUNCTION__,
        var _ file: String = __FILE__,
        _ line: Int = __LINE__){
            
            #if DEBUG
                
                // Clear any unresolved expressions from the variables received from the callers side
                if function.containsSubstring("expr") || function == ""{
                    function = ""
                }else{
                    function = "."+function+" "
                }
                
                
                if file.containsSubstring("expr") || file == ""{
                    file = ""
                }else{
                    file += " "
                }
                
                self.println("*** \(function)(\(file)line \(line)) ***:", color:color)
                self.println(statement, color:color)
                
            #endif
            
    }
    
    
    //TODO: Provide the parameter 'object' with a default value of 'self' when it become possible in swift, so this function needs no arguments at all
    
    public func printThisMethod<T:AnyObject>(
        
        object:T,
        _ color:NSColor? = nil,
        var _ function: String = __FUNCTION__,
        var _ file: String = __FILE__,
        _ line: Int = __LINE__){
            
            
            #if DEBUG
                
                let classOfObject = className(object)
                
                var viewIdentifier = ""
                if let view = object as? NSView{
                        if (view.identifier != nil) && (view.identifier != ""){
                        viewIdentifier =  "-"+view.identifier!
                        }
                }
                // Clear any unresolved expressions from the variables received from the callers side
                if function.containsSubstring("expr") || function == ""{
                    function = ""
                }else{
                    function = "."+function
                }
                
                
                
                if file.containsSubstring("expr") || file == ""{
                    file = ""
                }else{
                    file += " "
                }
                
                self.println("*** \(classOfObject)\(viewIdentifier)\(function) (\(file)line \(line)) ***:", color:color)
                self.println(object, color:color)
                
            #endif
            
    }
    
    public func println<T:Any>(
        statement:T,
        color:NSColor? = nil){
            
            #if DEBUG
                
                var colorCode = NSColor.grayColor().consoleCode
                let resetCode = NSColor.defaultConsoleCode
                
                if  let consoleColor = color{
                    colorCode = consoleColor.consoleCode
                }
                
                print("\(colorCode)\(statement)\(resetCode)\n", terminator: "")
                
            #endif
    }
    
    public func drawSeperatorInConsole(){
        
        #if DEBUG
            
            println("______________________________________________________________________________")
            
        #endif
    }
    
}

