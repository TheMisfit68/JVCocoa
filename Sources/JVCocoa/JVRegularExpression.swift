//
//  JVRegularExpression.swift
//  JVCocoa
//
//  Created by Administrator on 8/10/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

extension NSRegularExpression{
    
    enum JVRegexTypes: Int{
        case emailAddress
        case url
        case tag
    }
    
    //MARK: - Factory methods/convenience inits
    
    convenience init?(pattern: String){
        try? self.init(pattern: pattern, options: [NSRegularExpression.Options.caseInsensitive])
    }
    
    convenience init?(type: JVRegexTypes, patternVariables:[String: String]){
        
        var  patternToUse:String = ""
        
        switch type{
        case .emailAddress:
            patternToUse = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
        case .url:
            patternToUse = "\\bhttps?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"
        case .tag:
            if let tagName = patternVariables["tagName"]{
                patternToUse = "<\(tagName)[^>]*>(.*?)</\(tagName)>"
            }
        }
        
        self.init(pattern: patternToUse)
        
    }
    
    
    //MARK: - Matching
    
    public func matchedByString(stringToCheck: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        return numberOfMatches(in: stringToCheck, options: options, range: NSMakeRange(0, stringToCheck.count)) > 0
    }
    
}

//MARK: - Extra's

protocol RegularExpressionMatchable {
    func matchesExpression(pattern: String, options: NSRegularExpression.Options) -> Bool
}

extension String:RegularExpressionMatchable {
    
    public func matchesExpression(pattern: String, options:NSRegularExpression.Options = [.caseInsensitive]) -> Bool {
        if let regex = try? NSRegularExpression(pattern: pattern, options: options){
            return regex.numberOfMatches(in: self, range: NSMakeRange(0, self.count)) > 0
        }
        return false
    }
    
}

infix operator =~ : ComparisonPrecedence
func =~<T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
    return left.matchesExpression(pattern: right, options:[.caseInsensitive])
}

public extension String{
    
    /**
     Returns a two-dimensional  array of regexMatches
     each entry consists of the match (at index 0) followed by any captured groups/subexpressions
     
     - version: 1.0
     
     - Parameter withRegex : a RegEx pattern
          
     - Returns: [[String]]
     
     */
    
    func matchesAndGroups(withRegex pattern: String) -> [[String]] {
        var results:[[String]] = []
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        } catch {
            return results
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        results = matches.map{match in
            
            var expressions:[String] = []
            let numberOfExpressions = match.numberOfRanges
            
            for i in 0...numberOfExpressions-1 {
                let expressionRange = match.range(at: i)
                let expression = (self as NSString).substring(with: expressionRange)
                expressions.append(expression)
            }
            return expressions
        }
        return results
    }
    
}
