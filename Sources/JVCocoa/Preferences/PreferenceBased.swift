//
//  PreferenceBased.swift
//  
//
//  Created by Jan Verrept on 15/03/2021.
//

import Foundation

public protocol PreferenceBased{
	
	associatedtype ApplicationKey:StringRepresentable
	associatedtype PreferenceKey:StringRepresentableEnum
	associatedtype PreferenceValue:Any

	
	var userDefaults:UserDefaults {get}
	
	var preferences:[ApplicationKey:PreferenceValue]{get}

	func getPreference<T>(forKey key: PreferenceKey, secondaryKey: PreferenceKey?) -> T?

	func setPreference<T>(_ value: T, forKey key: PreferenceKey, secondaryKey: PreferenceKey?)

	func removePreference(forKey key: PreferenceKey, secondaryKey: PreferenceKey?)
	
	
}

public extension PreferenceBased {
	
	var userDefaults:UserDefaults{
		UserDefaults.standard // Can be overridden by the conforming class if needed
	}
	
	func getPreference<T>(forKey key: PreferenceKey, secondaryKey: PreferenceKey? = nil) -> T?{
		
		if let dictionaryKey = secondaryKey?.stringValue{
			let dictionary = userDefaults.value(forKey: key.stringValue) as? [String:Any]
			return dictionary?[dictionaryKey] as? T
		}else{
			return userDefaults.value(forKey: key.stringValue) as? T
		}
		
	}

	func setPreference<T>(_ value: T, forKey key: PreferenceKey, secondaryKey: PreferenceKey? = nil){
		
		if let dictionaryKey = secondaryKey?.stringValue{
			var dictionary = userDefaults.value(forKey: key.stringValue) as? [String:Any]
			dictionary?[dictionaryKey] = value
			userDefaults.setValue(dictionary, forKey: key.stringValue)
		}else{
			userDefaults.setValue(value, forKey: key.stringValue)
		}
		
	}
		
	func removePreference(forKey key: PreferenceKey, secondaryKey: PreferenceKey? = nil){
		
		if let dictionaryKey = secondaryKey?.stringValue{
			var dictionary = userDefaults.value(forKey: key.stringValue) as? [String:Any]
			dictionary?.removeValue(forKey: dictionaryKey)
			userDefaults.setValue(dictionary, forKey: key.stringValue)
		}else{
			userDefaults.removeObject(forKey: key.stringValue)
		}
	}
	
}
