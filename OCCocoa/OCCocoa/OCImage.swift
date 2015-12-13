//
//  OCImage.swift
//  OCCocoa
//
//  Created by Administrator on 8/09/14.
//  Copyright (c) 2014 OneClick BVBA. All rights reserved.
//

// MARK: Cross platform typing
#if os(OSX)
	import Cocoa
	public typealias OCImage = NSImage

	#elseif os(iOS)
	import UIKit
	public typealias OCImage = UIImage

#endif



public extension OCImage {

	public func imageScaledToSize(size: NSSize)->OCImage{

		#if os(OSX)

			// Draw it into a new NSImage
			let scaledImage = NSImage(size: size)
			scaledImage.lockFocus()
			self.drawInRect(NSRect(origin: NSPoint(), size:size))
			scaledImage.unlockFocus()

			#elseif os(iOS)

			// Draw this image into a new ImageContext en retreive it
			UIGraphicsBeginImageContext(size)
			self.drawInRect(NSRect(origin: NSPoint(), size: size))
			let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

		#endif

		return scaledImage
	}
	
}









