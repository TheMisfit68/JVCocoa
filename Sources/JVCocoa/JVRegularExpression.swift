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

