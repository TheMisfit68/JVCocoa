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
	
	func getPreference<T>(forKey key: PreferenceKey) -> T?
	func getPreference<T>(forKeyPath keyPath: PreferenceKey...) -> T?
	func getPreference<T>(forKeyPath keyPath: [PreferenceKey]) -> T?
	
	func setPreference<T>(_ value: T, forKey key: PreferenceKey)
	func setPreference<T>(_ value: T, forKeyPath keyPath: PreferenceKey...)
	func setPreference<T>(_ value: T, forKeyPath keyPath: [PreferenceKey])
	
	func removePreference(forKey key: PreferenceKey)
	func removePreference(forKeyPath keyPath: PreferenceKey...)
	func removePreference(forKeyPath keyPath: [PreferenceKey])
	
}

public extension PreferenceBased {
	
	var userDefaults:UserDefaults{
		UserDefaults.standard // Can be overridden by the conforming class if needed
	}
	
	
	// MARK: - Gettign Prefs
	
	func getPreference<T>(forKey key: PreferenceKey) -> T?{
		return userDefaults.value(forKey: key.stringValue) as? T
	}
	
	func getPreference<T>(forKeyPath keyPath: PreferenceKey...) -> T?{
		return getPreference(forKeyPath: keyPath)
	}
	
	func getPreference<T>(forKeyPath keyPath: [PreferenceKey]) -> T?{
		
		let lastIndex = keyPath.count-1
		var currentDictionary:[String : Any]?
		
		for (keyNumber, key) in keyPath.enumerated(){
			
			if keyNumber == 0 {
				currentDictionary = userDefaults.dictionary(forKey: key.stringValue)
			}else if keyNumber < lastIndex{
				currentDictionary = currentDictionary?[key.stringValue] as? [String:Any]
			}
			
		}
		
		return currentDictionary?[keyPath.last?.stringValue ?? ""] as? T
	}
	
	// MARK: - Setting Prefs
	
	func setPreference<T>(_ value: T, forKey key: PreferenceKey){
		userDefaults.setValue(value, forKey: key.stringValue)
	}
	
	func setPreference<T>(_ value: T, forKeyPath keyPath: PreferenceKey...){
		setPreference(value, forKeyPath: keyPath)
	}
	
	func setPreference<T>(_ value: T, forKeyPath keyPath: [PreferenceKey]){
		
		let lastIndex = keyPath.count-1
		var currentDictionary:[String : Any] = [:]
		
		for  (keyNumber, key) in keyPath.enumerated().reversed(){
			
			if keyNumber == lastIndex {
				currentDictionary = [key.stringValue:value]
			}else if keyNumber > 0{
				currentDictionary = [key.stringValue : currentDictionary]
			}
			
		}
		
		userDefaults.setValue(currentDictionary, forKey: keyPath.first?.stringValue ?? "")
	}
	
	// MARK: - Removing Prefs
	
	func removePreference(forKey key: PreferenceKey){
		userDefaults.removeObject(forKey: key.stringValue)
	}
	
	func removePreference(forKeyPath keyPath: PreferenceKey...){
		 removePreference(forKeyPath: keyPath)
	}
	
	func removePreference(forKeyPath keyPath: [PreferenceKey]){
		
		var parentKey = keyPath
		parentKey.removeLast()
		
		var parentDirectory:[String : Any]? = getPreference(forKeyPath: parentKey)
		
		parentDirectory?.removeValue(forKey: keyPath.last?.stringValue ?? "")
		
		setPreference(parentDirectory, forKeyPath: 	parentKey)
	}
	
}
