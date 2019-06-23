

// Playground - noun: a place where people can play

import Cocoa

// NSArray+OCArray.h deleted,
// default implementation
[1,5,7,9,22].last!
[1,5,7,9,22].first!
let testForFirstItem = [1,5,7,9,22].contains(22)
let testForSecondItem = [1,5,7,9,22].contains(23)
let test = [1,2,3].contains(14)

// NSMutableArray+OCMutableArray.h deleted,
// default implementation
var firstInt = 3
var secondInt = 107
swap(&firstInt, &secondInt)
firstInt
secondInt

// Test OCString
let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let leftSubstring = alphabetString.leftString(2)
let rightSubstring = alphabetString.rightString(2)
let aanwezig = alphabetString.containsSubstring("ABC")
let length = alphabetString.characters.count
let substring4 = alphabetString[1...4]
let substring5 = alphabetString[0..<5]
let substring6 = alphabetString[0...5]


// Test OCImage
let originalImage = NSImage(named:"126-moon.png")!
let newSize = NSSize(width:190, height:220)
let scaledImage = originalImage.imageScaledToSize(newSize)
scaledImage



// Test JVBool
var myBool = false
myBool.toggle()
myBool.toggle(false)

// Test associative storage for extensions
//var firstObject = NSObject()
//var secondObject = NSView()
//firstObject.setPropertyWithName("extraString", to: "associatedString")
//secondObject.setPropertyWithName("extraInt", to: 123)
//
//firstObject.propertyWithName("extraString")!
//secondObject.propertyWithName("extraInt")!
//
//let secondType = type(of: secondObject).className()

