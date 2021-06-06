//
//  JVPinger.swift
//  
//
//  Created by Jan Verrept on 04/06/2021.
//

import Foundation

public class Pinger{
		
	public init(){}
	
	public func ping(_ host:String, numberOfPings:Int =  1)->String{
		
		let pingCommand:TerminalCommand = TerminalCommand("ping  -c \(numberOfPings) \(host)")
		let pingResult:String = pingCommand.execute()
		return pingResult
		
	}
	
	public func ping(_ host:String, numberOfPings:Int = 1, maxResponsTime:TimeInterval = 5)->Bool{
		
		let pingresult = ping(host, numberOfPings: numberOfPings)
		
		let regexPattern = #"(\d\.\d{3})\/(?:\d\.\d{3}\/?)\sms$"#
		let maxResponsText = pingresult.matchesAndGroups(withRegex: regexPattern).first?[1]
		if let responsText = maxResponsText, let responseTime = TimeInterval(responsText){
			let responseTimeInms = responseTime/1000
			return responseTimeInms <= maxResponsTime
		}else{
			return false
		}
	}
	
	
}
