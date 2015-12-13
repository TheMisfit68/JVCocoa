//
//  OCSTRING.swift
//  OCCocoa
//
//  Created by Administrator on 6/09/14.
//  Copyright (c) 2014 OneClick BVBA. All rights reserved.
//

import Foundation

public extension String {

	public subscript (range:Range<Int>)->String {
		get
		{
			let minIndex = max(0, range.startIndex);
			let maxIndex = min(range.endIndex, self.characters.count);
            
            ///FIXME: Changed advance to advancedBy needs to be retested
			let start = startIndex.advancedBy(minIndex)
			let end = startIndex.advancedBy(maxIndex)

			return substringWithRange(Range(start: start, end: end))

		}
	}


	public func leftString(characters: Int)->String{
		return self[0..<characters]
	}

	public func rightString(characters:Int)->String{
		return self[self.characters.count-characters..<self.characters.count]
	}

	public func containsSubstring(subString: String)->Bool{
		return (rangeOfString(subString, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil)
	}
    
    public func boolValue()->Bool{
        let testValue:NSString = self as NSString
        return testValue.boolValue
    }

	
	
}