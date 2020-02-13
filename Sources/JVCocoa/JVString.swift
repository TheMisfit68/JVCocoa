//
//  JVSTRING.swift
//  JVCocoa
//
//  Created by Administrator on 6/09/14.
//  Copyright (c) 2014 OneClick BVBA. All rights reserved.
//

import Foundation

public extension String {
    
    func indexForChar(offsetFromZero:Int)->String.Index{
        return index(startIndex, offsetBy:offsetFromZero)
    }
    
    var firstIndex:String.Index{
        return startIndex
    }
    
    var lastIndex:String.Index{
        
        if !isEmpty{
            return index(before:endIndex)
        }
        return startIndex
        
    }
    
    // Subscript that works with a range of Ints instead of a range of Indeces
    // String subscripts are zero-based
    subscript (range:Range<Int>)->String {
        get
        {
            if !isEmpty{
                let minIndex:String.Index
                if (range.lowerBound >= 0){
                    minIndex = indexForChar(offsetFromZero:range.lowerBound)
                }else{
                    minIndex = firstIndex
                }
                
                let maxIndex:String.Index
                if (range.upperBound >= 0) && (range.upperBound >= range.lowerBound) && (range.upperBound < count){
                    maxIndex = indexForChar(offsetFromZero:range.upperBound)
                }else{
                    maxIndex = lastIndex
                }
                
                return String(self[minIndex...maxIndex]) // Return a String from the found Substring
            }else{
                return ""
            }
        }
    }
    
    func leftString(numberOfchars: Int)->String{
        return String(prefix(numberOfchars)) // Return a String from the found Substring
    }
    
    func rightString(numberOfchars: Int)->String{
        return String(suffix(numberOfchars)) // Return a String from the found Substring
    }
    
    func containsSubstring(_ subString: String)->Bool{
        // Compare case insensitive by making the String and Substring lowercase
        return lowercased().range(of:subString.lowercased()) != nil
    }
    
    func replace(matchPattern:String, replacementPattern:String, useRegex:Bool = false)->String{
        
        let searchOptions:String.CompareOptions = !useRegex ? [.caseInsensitive] :[.caseInsensitive, .regularExpression]

           return replacingOccurrences(of: matchPattern,
                                       with: replacementPattern,
                                       options: searchOptions)
    }
    
    func quote()->String{
      return "\"\(self)\""
    }
    
    func singleQuote()->String{
        return "'\(self)'"
    }
    
    func unquote()->String{
        return replace(matchPattern: "^\"(.*)\"$", replacementPattern: "$1", useRegex: true)
    }
    
}
