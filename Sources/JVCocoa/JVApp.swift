//
//  AppNapController.swift
//  
//
//  Created by Jan Verrept on 27/12/2020.
//

import Foundation

public class AppNapController:Singleton{
    
    public static let shared:AppNapController = AppNapController()
    private init(){}
    
    var permanentActivity:NSObjectProtocol!
    
    public func keepAlive(){
        disable()
    }
    
    private func disable(){
        
        permanentActivity = ProcessInfo.processInfo.beginActivity(
            options: ProcessInfo.ActivityOptions.userInitiated,
            reason: "Keeping this App alive")
        
    }
    
    public func enable(){
        ProcessInfo.processInfo.endActivity(permanentActivity)
    }
    
}
