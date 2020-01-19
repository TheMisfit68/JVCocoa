//
//  JVXMLParser.swift
//  JVCocoa
//
//  Created by Jan Verrept on 23/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

//FIXME: - Uncomment and build


//import Foundation
//import Cocoa
//
///**
//*  This is an abstract class (intended to be subclassed)
//*  It handles the results provided by NSXMLParser (being an NSXMLParserDelegate)
//*  However you need to override parserDidEndDocument in your final subclass
//*/
//
//public class JVXMLParser:NSObject, XMLParserDelegate{
//
//    //MARK: - Initialization
//
//    public var elementNames:[String]?
//    public var parseResults: [String:[String]]?
//
//    private let usedParser:XMLParser
//    private var currentStringValue:String?
//
//    init(data:NSData){
//        self.usedParser = XMLParser(data: data)
//        super.init()
//        self.usedParser.delegate = self
//    }
//
//
//    //MARK: - The Main Function
//    public func parse(elementNamesToParse:[String]? = nil){
//        elementNames = elementNamesToParse
//        usedParser.parse()
//    }
//
//
//    //MARK: - NSXMLParserDelegate
//
//    public func parserDidStartDocument(_ parser: XMLParser){
//        //println("Parsing begun")
//    }
//
//    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
//
//        let returnThisValue:Bool = (elementNames == nil) ||
//            (elementNames!.isEmpty == true) ||
//            (elementNames!).contains(elementName)
//        if returnThisValue{
//            //println("Elementname: \(elementName)")
//            currentStringValue = ""
//        }
//
//    }
//
//
//
//    public func parser(_ parser: XMLParser,
//        foundCharacters string: String){
//
//            if (currentStringValue != nil){
//                let trimmedString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//                currentStringValue = currentStringValue! + trimmedString
//                //println("currentStringValue = \(string)")
//            }
//    }
//
//
//    public func parser(_ parser: XMLParser,
//        didEndElement elementName: String,
//        namespaceURI: String?,
//        qualifiedName qName: String?){
//
//            if (currentStringValue != nil){
//
//                if (parseResults?[elementName]?.count > 0){
//                    parseResults![elementName]!.append(currentStringValue!)
//                }else{
//                    parseResults![elementName] = [currentStringValue!]
//                }
//
//
//                currentStringValue = nil
//                //println("End element")
//            }
//
//    }
    
//
//    public func parser(parser: XMLParser,
//        foundAttributeDeclarationWithName attributeName: String,
//        forElement elementName: String,
//        type: String?,
//        defaultValue: String?){
//            //println("Found attribute: \(attributeName) (\(elementName)) [\(type)] {\(defaultValue)}")
//    }
//
//    public func parser(parser: XMLParser,
//        foundIgnorableWhitespace whitespaceString: String){
//            //println("Found ignorable whitespace: \(String)")
//    }
//
//    public func parser(_: XMLParser,
//        parseErrorOccurred parseError: NSError){
//            //println("Parsing error occurred: \(parseError.localizedDescription)")
//    }
//
//    public func parserDidEndDocument(_: XMLParser){
//
//        //println("Parsing ended")
//        assert(true, "You should override 'parserDidEndDocument' in your JVXMLParser-subclass")
//    }
//
//}
