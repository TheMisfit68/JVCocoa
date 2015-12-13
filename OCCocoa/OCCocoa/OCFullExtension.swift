//
//  OCFullExtension.swift
//  OCCocoa
//
//  Created by Administrator on 14/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import ObjectiveC

public protocol fullyExtendable: Hashable{
	func propertyWithName(name: String) -> Any?
	func setPropertyWithName(aName: String,  to objectOrValue: Any)
}

// Create a global dictionary that remains private to this file
// Make it a nested dictionary:
// For each object to extend (based on its unique memoryaddress)
// store a dictionary of propertynames with its values

private typealias objectKey = Int
private typealias propertyName = String
private var extensionProperties = [objectKey: [propertyName: Any]]()

extension NSObject: fullyExtendable{

	/// A key unique for an object
	private var objectKey: Int{
		return ObjectIdentifier(self).hashValue
	}

	/**
	Gets an associated object or value

	- parameter aName: The name of the property that was stored

	- returns: The object that was previously stored
	*/
	public func propertyWithName(aName: String) -> Any?{
		return extensionProperties[objectKey]?[aName]
	}

	/**
	Sets an associated object or value

	- parameter aName: The name of the property you would like to store
	- parameter anObject: The object to store
	*/
	public func setPropertyWithName(aName: String, to objectOrValue: Any){

		if var myProperties = extensionProperties[objectKey]{
			myProperties[aName] = objectOrValue
		}else{
			extensionProperties[objectKey] = [aName: objectOrValue]
		}
		
	}
	
}

