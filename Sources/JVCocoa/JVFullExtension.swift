//
//  JVFullExtension.swift
//  JVCocoa
//
//  Created by Administrator on 14/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

// Associated properties so that extensions can use extra properties
// however since conforming types must be hasshable (and therefore equatable)
// use them sparingly if don't want to implment a whole slew of methods
// subclasses or classes that use another type are often te better choise

public protocol FullyExtendable: Hashable{
    func property(name propertyName:String) -> Any?
    func setProperty(name propertyName:String,  to objectOrValue: Any)
}

// Create a global dictionary that remains private to this file
// Make it a nested dictionary:
// For each object to extend (based on its unique memoryaddress)
// store a dictionary of propertynames with its values

fileprivate typealias hashKey = Int
fileprivate typealias propertyName = String
fileprivate var extensionProperties:[hashKey: [propertyName: Any]] = [hashKey: [propertyName: Any]]()

public extension FullyExtendable{

	/**
	Gets an associated object or value

	- parameter aName: The name of the property that was stored
     
	- returns: The object that was previously stored
	*/
    func property(name propertyName: String) -> Any?{
        let myProperties = extensionProperties[self.hashValue]
		return myProperties?[propertyName]
	}

	/**
	Sets an associated object or value

	- parameter aName: The name of the property you would like to store
	- parameter anObject: The object to store
	*/
    func setProperty(name propertyName: String, to objectOrValue: Any){

		if var myProperties = extensionProperties[self.hashValue]{
			myProperties[propertyName] = objectOrValue
            extensionProperties[self.hashValue] = myProperties
		}else{
			extensionProperties[self.hashValue] = [propertyName: objectOrValue]
		}
		
	}
	
}


