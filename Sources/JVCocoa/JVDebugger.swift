//
//  JVDebugger.swift
//  JVCocoa
//
//  Created by Jan Verrept on 3/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Cocoa

/**
 Singleton Debugger class
 */


public class JVDebugger: Singleton {
    
    /*
     A dictionary containing all environmental variables that where set in your building scheme
     */
    static let environmentalVars = ProcessInfo.processInfo.environment
    
    public enum JVDebugLevels: String{
        case Error = "❌"
        case Warning = "⚠️"
        case Succes = "✅"
        case Info = "ℹ️"
        case Message = "💬"
        case Event = "✴️"
        case None = ""
    }
    
    public static let shared:JVDebugger = JVDebugger()
    
    //TODO: Replace the first macro with the second one whenever it is possible to replace the empty string
    //with a default argument of self, a.k.a. the caller-side-object that you want to log
    
    public func logThisMethod<T:Any>(
        
        type:T ,
        _ debugLevel:JVDebugLevels = .None,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line){
        
        #if DEBUG
            
            // Clear any unresolved expressions from the variables received from the callers side
            let functionString:String
            if function.containsSubstring("expr") || function == ""{
                functionString = ""
            }else{
                functionString = ".\(function) "
            }
            
            let fileString:String
            if file.containsSubstring("expr") || file == ""{
                fileString = " "
            }else{
                fileString = "\(file) "
            }
            
            print(debugLevel.rawValue, "\(functionString)(\(fileString)line \(line) :")
            print(type)
            
        #endif
        
    }
    
    public func logThisMethod<T:AnyObject>(
        
        object:T,
        _ debugLevel:JVDebugLevels = .None,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line){
        
        
        #if DEBUG
            
            let classOfObject = className(object: object)
            
            var  viewIdentifierString = ""
            if let view = object as? JVView{
                let  viewIdentifier = view.identifier?.rawValue ?? ""
                if viewIdentifier != ""{
                    viewIdentifierString = "-\(viewIdentifier)"
                }
            }
            
            // Clear any unresolved expressions from the variables received from the callers side
            let functionString:String
            if function.containsSubstring("expr") || function == ""{
                functionString = ""
            }else{
                functionString = ".\(function) "
            }
            
            let fileString:String
            if file.containsSubstring("expr") || file == ""{
                fileString = " "
            }else{
                fileString = "\(file) "
            }
            
            print(debugLevel.rawValue, "\(classOfObject)\(viewIdentifierString)\(functionString)(\(fileString)line \(line) :")
            print(String(describing:object))
            
        #endif
        
    }
    
    public func log(
        debugLevel:JVDebugLevels = .None,
        _ items:Any...
        ){
        
        #if DEBUG
            print(debugLevel.rawValue, terminator:" ")
            print(items, separator:", ")
        #endif
    }
    
    public func drawSeperatorInConsole(){
        #if DEBUG
            print("＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿")
        #endif
    }
    
}
