//
//  OCRegularExpression.swift
//  OCCocoa
//
//  Created by Administrator on 8/10/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public class RegEx{

//MARK: - Initialization
    
    private let pattern: String
    private let options: NSRegularExpressionOptions
    private let expression: NSRegularExpression?
    
    public init?(pattern: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions.CaseInsensitive) {
        self.pattern = pattern
        self.options = options
        do{
             self.expression = try NSRegularExpression(pattern: self.pattern, options: self.options)
        }catch{
            self.expression = nil
            return nil
        }
    }
    
//MARK: Factory methods/convenience inits
    
    convenience init?(emailAddress:String){
        self.init(pattern: "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b")
    }
    
    convenience init?(URL:String){
        self.init(pattern: "\\bhttps?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?")
    }
    
    convenience init?(tagName:String){
        self.init(pattern: "<\(tagName)[^>]*>(.*?)</\(tagName)>")
    }
    
//MARK: - Matching
    
    public func matchedByString(stringToCheck: String, options: NSMatchingOptions = NSMatchingOptions(rawValue: 0)) -> Bool {
        return expression?.numberOfMatchesInString(stringToCheck, options: options, range: NSMakeRange(0, stringToCheck.characters.count)) != 0
    }
    
    public func firstMatchedString(stringToCheck: String, options: NSMatchingOptions = NSMatchingOptions(rawValue: 0)) -> String? {
        
        let rangeOfFirstMatch:NSRange = (expression?.rangeOfFirstMatchInString(stringToCheck, options:options, range: NSMakeRange(0, stringToCheck.characters.count)))!
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            return NSString(string:stringToCheck).substringWithRange(rangeOfFirstMatch)
        }else{
            return nil;
        }
        
    }
    
}

//MARK: - Extra's

protocol RegularExpressionMatchable {
	func matchesExpression(pattern: String, options: NSRegularExpressionOptions) -> Bool
}

extension String {
	func matchesExpression(pattern: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions(rawValue: 0)) -> Bool {
		let regex = RegEx(pattern: pattern, options: options)
		return regex!.matchedByString(self, options: NSMatchingOptions(rawValue: 0))
	}
}

infix operator =~ { associativity left precedence 130 }
func =~<T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
	return left.matchesExpression(right, options: NSRegularExpressionOptions(rawValue: 0))
}
