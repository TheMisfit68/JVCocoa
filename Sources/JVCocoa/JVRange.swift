//
//  JVRange.swift
//  
//
//  Created by Jan Verrept on 21/02/2021.
//

import Foundation

public extension Comparable{
	
	func copyLimitedBetween(_ range: ClosedRange<Self>)->Self{
		var copiedValue:Self = self
		copiedValue.limitBetween(range)
		return copiedValue
	}

	mutating func limitBetween(_ range: ClosedRange<Self>){
		self = min(max(self, range.lowerBound), range.upperBound)
	}
	
}
