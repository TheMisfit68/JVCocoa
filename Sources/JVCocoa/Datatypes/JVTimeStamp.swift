//
//  JVTimeStamp.swift
//  
//
//  Created by Jan Verrept on 31/01/2021.
//

import Foundation

public typealias TimeStamp = TimeInterval

public extension TimeInterval {
	
	static var CurrentTimeStamp:TimeStamp {
		let now = Date()
		return (now.timeIntervalSince1970 * 1000.0)
	}

}
