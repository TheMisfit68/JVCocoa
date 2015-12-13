//
//  OCView.swift
//  OCCocoa
//
//  Created by Administrator on 26/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Cocoa

/**
Defines a cross-platform type of View
for both NSView and UIView
*/

#if os(OSX)
    public typealias OCView = NSView
    #elseif os(iOS)
    public typealias OCView = UIView
#endif

public enum viewOrientation{
    case horizontal, vertical
}

//MARK: - AutoLayoutView Protocol
public protocol AutoLayoutView{
    
    static func requiresConstraintBasedLayout()->Bool
    var orientation:viewOrientation?{get set}
    
}

/**
*  This is an extension for existing views
*  so they can deal with Auto Layout
*/

//MARK: - NSVIEW/UIView+OCAutoLayoutView extension

extension OCView:AutoLayoutView{
    
    
    public var orientation:viewOrientation?{
        get{
            return propertyWithName("orientation") as! viewOrientation?
        }
        set{
            setPropertyWithName("orientation", to:newValue)
        }
    }
    
    //MARK: - Views relationships introspection
    
    public var isContainerView:Bool{
        
        return (self is NSScrollView) ||
            (self is NSClipView) ||
            (self is NSSplitView)
        
    }
    
    public var superviews:[OCView]{
        
        var array:[OCView] = []
        var currentSuperView = superview
        
        while (currentSuperView != nil){
            array.append(currentSuperView!)
            currentSuperView = currentSuperView!.superview
        }
        
        return array;
    }
    
    
    public func nearestCommonAncestorWithView(secondView: OCView? = nil) -> OCView?{
        
        var commonAncestor: OCView?
        
        if ( (secondView == nil) || (secondView === self) ){
            commonAncestor = self
        }else if secondView!.isDescendantOf(self){
            commonAncestor = self
        }else if self.isDescendantOf(secondView!){
            commonAncestor = secondView
        }else{
            
            // Search for indirect common ancestor
            for superView in superviews{
                if secondView!.superviews.contains(superView){
                    commonAncestor = superView
                }
                else{
                    // No common ancestor
                    debugger.println("Error: \(self) has no common ancestor with \(secondView)", color: NSColor.redColor())
                }
            }
            
        }
        
        return commonAncestor
    }
    
    //MARK: - Reading and writing unary sizing constraints trough floats
    
    public var maxWidthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.LessThanOrEqual}
        return filteredConstraints
    }
    
    public var widthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.Equal}
        return filteredConstraints
    }
    
    public var minWidthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.GreaterThanOrEqual}
        return filteredConstraints
    }
    
    public var maxHeightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.LessThanOrEqual}
        return filteredConstraints
    }
    
    public var heightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.Equal}
        return filteredConstraints
    }
    
    public var minHeightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutAttribute.Width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutRelation.GreaterThanOrEqual}
        return filteredConstraints
    }
    
    
    //MARK: Unary sizing constraints
    
    public func addConstraints(minSize minSize:NSSize, maxSize:NSSize, priority:NSLayoutPriority = 1.0){
        addConstraints(minWidth:Float(minSize.width), maxWidth:Float(maxSize.width), priority:priority)
        addConstraints(minHeight:Float(minSize.height), maxHeight:Float(maxSize.height), priority:priority)
    }
    
    public func addConstraints(minWidth minWidth:Float, maxWidth:Float, priority:NSLayoutPriority = 1.0){
        
        var newConstraint:NSLayoutConstraint
        
        newConstraint = NSLayoutConstraint(item:self,
            attribute:.Width,
            relatedBy:.GreaterThanOrEqual,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(minWidth)
        )
        newConstraint.installWithPriority(priority)
        
        newConstraint = NSLayoutConstraint(item:self,
            attribute:.Width,
            relatedBy:.LessThanOrEqual,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(maxWidth)
        )
        newConstraint.installWithPriority(priority)
        
    }
    
    public func addConstraints(width width:Float, priority:NSLayoutPriority = 1.0){
        
        let newConstraint = NSLayoutConstraint(item:self,
            attribute:.Width,
            relatedBy:.Equal,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(width)
        )
        newConstraint.installWithPriority(priority)
    }
    
    public func addConstraints(minHeight minHeight:Float, maxHeight:Float, priority:NSLayoutPriority = 1.0){
        
        var newConstraint:NSLayoutConstraint
        
        newConstraint = NSLayoutConstraint(item:self,
            attribute:.Height,
            relatedBy:.GreaterThanOrEqual,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(minHeight)
        )
        newConstraint.installWithPriority(priority)
        
        newConstraint = NSLayoutConstraint(item:self,
            attribute:.Height,
            relatedBy:.LessThanOrEqual,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(maxHeight)
        )
        newConstraint.installWithPriority(priority)
    }
    
    public func addConstraints(height height:Float, priority:NSLayoutPriority = 1.0){
        
        let newConstraint = NSLayoutConstraint(item:self,
            attribute:.Height,
            relatedBy:.Equal,
            toItem:nil,
            attribute:.NotAnAttribute,
            multiplier:1.0,
            constant:CGFloat(height)
        )
        newConstraint.installWithPriority(priority)
        
    }
    
    //MARK: Simple view vs superview constraints
    
    
    public func fitVerticalInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            let views = ["thisView": self]
            let metrics = ["margin":NSNumber(float: margin)]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat("V:|-margin-[thisView]-margin-|", options:[] ,metrics:metrics, views:views)
        }
        
    }
    
    public func fitHorizontalInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            let views = ["thisView": self]
            let metrics = ["margin":NSNumber(float: margin)]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat("H:|-margin-[thisView]-margin-|", options:[], metrics:metrics, views:views)
        }
        
    }
    
    public func fitInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            fitVerticalInSuperview(margin)
            fitHorizontalInSuperview(margin)
        }
        
    }
    
    
    /**
    Prevent underconstraint layouts by installing fallback constraints with very low priority
    */
    public func constrainToSuperview(){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            
            let views = ["thisView": self]
            let metrics = [:]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat("H:|-0@1-[thisView]-0@1-|", options:[], metrics:metrics, views:views)
            NSLayoutConstraint.installConstraintsWithVisualFormat("V:|-0@1-[thisView]-0@1-|", options:[], metrics:metrics, views:views)
        }
        
        
    }
    
    
}


/**
*  This is an abstract class (intended to be subclassed)
*  It handles most of the implementation for a custom view that uses Auto Layout
*/

//MARK: - OCCustomView Subclass

public class customView:OCView{
    
    override public func drawRect(dirtyRect:NSRect){
        
        super.drawRect(dirtyRect)
        
        #if DEBUG
            if let viewToDebug = environmentalVars["DEBUG_VIEW"] as String?{
                
                let defaultColor = NSColor.grayColor()
                let debugColor = NSColor.orangeColor()
                
                if viewToDebug == self.identifier{
                    debugColor.setStroke()
                    var innerFrame = NSRect(aRect:frame)
                    innerFrame.insetInPlace(dx: 2.0, dy: 2.0)
                    let coloredEdge = NSBezierPath(rect:innerFrame)
                    coloredEdge.stroke()
                }
                
                debugger.println("Frame: \(frame)", color:defaultColor)
                debugger.println(self, color:debugColor)
                
            }
        #endif
    }
    
    
    //MARK: - Constraint handling
    //MARK: Class methods
    
    final override public class func requiresConstraintBasedLayout()->Bool{
        return true
    }
    
    //MARK: Instance methods
    
    override public var intrinsicContentSize:NSSize{
        return NSMakeSize(NSViewNoInstrinsicMetric, NSViewNoInstrinsicMetric)
    }
    
    override public func viewDidMoveToSuperview(){
        // Fit OCAutoLayoutViews in their superviews when necessary
        let viewIsOnlyViewInsuperView = superview?.subviews.count == 1
        if viewIsOnlyViewInsuperView{
            fitInSuperview()
            needsLayout = true
        }
    }
    
    
    override public func updateConstraints(){
        
        #if DEBUG
            if let debugConstraints = environmentalVars["DEBUG_CONSTRAINTS"]?.boolValue(){
                if debugConstraints == true{
                    
                    Swift.print(self)
                    debugger.println("Constraints before:", color:NSColor.grayColor())
                    debugger.println(constraints, color:NSColor.grayColor())
                    Swift.print("")
                    
                }
            }
        #endif
        
        constrainToSuperview()
        super.updateConstraints()
        
        #if DEBUG
            if let debugConstraints = environmentalVars["DEBUG_CONSTRAINTS"]?.boolValue(){
                if debugConstraints ==  true{
                    
                    Swift.print("")
                    Swift.print("")
                    debugger.println("Constraints after:", color:NSColor.grayColor())
                    debugger.println(constraints, color:NSColor.grayColor())
                    debugger.drawSeperatorInConsole()
                    Swift.print("")
                    
                }
            }
        #endif
    }
    
    
    
}

