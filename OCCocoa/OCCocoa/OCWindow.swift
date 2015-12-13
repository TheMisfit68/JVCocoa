//
//  OCWindow.swift
//  OCCocoa
//
//  Created by Administrator on 9/10/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

public extension NSWindow{

	public var isFullScreen: Bool{
		return ((styleMask & NSFullScreenWindowMask) == NSFullScreenWindowMask)
	}

	public func enterFullScreen(){
		if (!isFullScreen){
			toggleFullScreen(nil)
		}
	}

	public func exitFullScreen(){
		if (isFullScreen){
			toggleFullScreen(nil)
		}
	}

}