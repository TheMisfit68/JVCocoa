//
//  JVWindow.swift
//  JVCocoa
//
//  Created by Administrator on 9/10/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

// MARK: Cross platform typing
#if os(OSX)
    import Cocoa
    public typealias JVWindow = NSWindow
#elseif os(iOS)
    import UIKit
    public typealias JVWindow = UIWindow
#endif

public extension JVWindow{

	public var isFullScreen: Bool{
		return (styleMask.contains(JVWindow.StyleMask.fullScreen))
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
