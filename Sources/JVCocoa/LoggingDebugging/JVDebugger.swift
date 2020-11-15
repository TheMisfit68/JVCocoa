//
//  Debugger.swift
//  JVCocoa
//
//  Created by Jan Verrept on 3/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Cocoa
import os.log

/**
 Singleton Debugger class
 */
@available(OSX 10.16, *)
public class Debugger: Singleton {
    
    public static let shared:Debugger = Debugger()
    
    // Apples Logger is available as of OS 11 (Big Sur) as a Struct
    // so it can't be subclassed only extended or embbeded as in this case
    var logger:Logger! = nil
    
    /*
     Some variables for convinience:
     The main applications name and
     a dictionary containing all environmental variables that where optionally set in your building scheme
     */
    private static var AppIdentifier = Bundle.main.bundleIdentifier!
    private static let EnvironmentalVars = ProcessInfo.processInfo.environment
    
    public enum DebugLevel{
        
        case Critical
        case Warning
        case Message
        case Event
        case Succes
        case Test
        
        case Native(logType:OSLogType)
        
    }
    
    
    // TODO: Replace the first macro with the second one whenever it is possible to replace the empty string
    // with a default argument of self, a.k.a. the caller-side-object that you want to log
    
    public func logThisMethod<T:Any>(
        
        type:T,
        _ debugLevel:DebugLevel = .Native(logType: OSLogType.default),
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
        
        
        log(debugLevel: .Native(logType: OSLogType.debug) , "\(functionString)(\(fileString)line \(line) :")
        log(debugLevel: .Native(logType: OSLogType.debug), type)
        
        #endif
        
    }
    
    public func logThisMethod<T:AnyObject>(
        
        object:T,
        _ debugLevel:DebugLevel = .Native(logType: OSLogType.default),
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line){
        
        
        #if DEBUG
        
        let classOfObject = className(of: object)
        
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
        
        
        log(debugLevel: .Native(logType: OSLogType.debug) , "\(classOfObject)\(functionString)(\(fileString)line \(line) :")
        log(debugLevel: .Native(logType: OSLogType.debug), object)
        
        #endif
        
    }
    
    public func log(debugLevel:DebugLevel = .Native(logType: OSLogType.default), _ items:Any..., seperator:String = " "){
        
        var icon:String = ""
        var message = items.map{String(describing:$0)}.joined(separator: seperator)
        
        switch debugLevel {
        case .Critical:
            icon = "🔥"
            logger.debug("\(icon) \(message)")
        case .Warning:
            icon = "⚠️"
            logger.debug("\(icon) \(message)")
        case .Message:
            icon = "💬"
            logger.debug("\(icon) \(message)")
        case .Event:
            icon = "✴️"
            logger.debug("\(icon) \(message)")
        case .Succes:
            icon = "✅"
            logger.debug("\(icon) \(message)")
        case .Test:
            icon = "🧪"
            logger.debug("\(icon) \(message)")
            
        case .Native(let logType):
            
            icon = logType.Icon
            logger = Logger(subsystem: Debugger.AppIdentifier, category: "JVLogger")
            
            switch logType {
            case .fault:
                logger.fault("\(icon) \(message)")
            case .error:
                logger.error("\(icon) \(message)")
            case .info:
                logger.info("\(icon) \(message)")
            case .debug:
                logger.debug("\(icon) \(message)")
            default:
                logger.log("\(icon) \(message)")
            }
        }
        
    }
    
    public func drawSeperatorInXcodeConsole(){
        
        #if DEBUG
        print("＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿")
        #endif
        
    }
    
}
