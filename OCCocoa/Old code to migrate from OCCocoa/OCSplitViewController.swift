//
//  OCCollapsibleSplitview.swift
//  OCCocoa
//
//  Created by Jan Verrept on 28/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Cocoa

class OCSplitViewController:NSSplitViewController {
    
    //MARK: - Delegate helper methods
    
    //    -(NSArray *)minimumMarginsForSubViewAt:(NSInteger)anIndex{
    //    NSNumber *minMargin = @((anIndex == 0) * self.autoCollapseSize);
    //    NSNumber *maxMargin = @((anIndex = [[self subviews] count]-1) * self.autoCollapseSize);
    //    return @[minMargin,maxMargin];
    //    }
    
        
}

//@IBDesignable public class OCCollapsibleSplitview:NSSplitView, AutoLayoutView{
//
//    private let autoCollapseSize:Float
//    @IBInspectable var splitOrientation:viewOrientation = .horizontal
//
//    public required init?(coder: NSCoder) {
//        self.autoCollapseSize = Float(bounds.size.width)/10.0
//        super.init(coder: coder)
//    }
//
//
//     public required init(frame frameRect: NSRect) {
//        autoCollapseSize = Float(frameRect.size.width)/10.0
//        super.init(frame:frameRect)
//    }
//
//    override public class func requiresConstraintBasedLayout()->Bool{
//        return true
//    }
//
//
//}


public extension NSSplitViewItem{
    
    public func toggle(){
        animator().collapsed = !collapsed
    }
    
    public func collapse(){
        animator().collapsed = true
    }
    
    public func unCollapse(){
        animator().collapsed = false
    }
    
}

