//
//  JVView.swift
//  JVCocoa
//
//  Created by Administrator on 26/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

// MARK: Cross platform typing
#if os(OSX)
    import Cocoa
    public typealias JVView = NSView
#elseif os(iOS)
    import UIKit
    public typealias JVView = UIView
#endif

public enum viewOrientation{
    case horizontal, vertical
}

//MARK: - JVConstrainableView Protocol

/**
 *  This is a protocol(extension) for existing views
 *  so they can deal with AutoLayout-constraints
 */

public protocol JVConstrainableView{
    
    func requiresConstraintBasedLayout()->Bool
    
    var orientation:viewOrientation?{get set}
    var isContainerView:Bool{get}
    var superviews:[JVView]{get}
    func nearestCommonAncestor(withView secondView: JVView?) -> JVView?
    
    //Reading and writing unary sizing constraints trough floats
    var maxWidthConstraints:[NSLayoutConstraint]{get}
    var widthConstraints:[NSLayoutConstraint]{get}
    var minWidthConstraints:[NSLayoutConstraint]{get}
    var maxHeightConstraints:[NSLayoutConstraint]{get}
    var heightConstraints:[NSLayoutConstraint]{get}
    var minHeightConstraints:[NSLayoutConstraint]{get}
    
    func addConstraints(minSize:NSSize, maxSize:NSSize, priority:NSLayoutConstraint.Priority)
    func addConstraints(minWidth:Float, maxWidth:Float, priority:NSLayoutConstraint.Priority)
    func addConstraints(width:Float, priority:NSLayoutConstraint.Priority)
    func addConstraints(minHeight:Float, maxHeight:Float, priority:NSLayoutConstraint.Priority)
    func addConstraints(height:Float, priority:NSLayoutConstraint.Priority)
    
    // Simple view vs superview constraints
    func fitVerticalInSuperview(margin:Float)
    func fitHorizontalInSuperview(margin:Float)
    func fitInSuperview(margin:Float)
}


extension JVView:JVConstrainableView, FullyExtendable{
    
    // Conform to AutoLayoutView Protocol
    public func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    public var orientation:viewOrientation?{
        get{
            return property(name: "orientation") as! viewOrientation?
        }
        set{
            setProperty(name: "orientation", to:newValue!)
        }
    }
    
    //MARK: - Views relationships introspection
    
    public var isContainerView:Bool{
        
        return (self is NSScrollView) ||
            (self is NSClipView) ||
            (self is NSSplitView)
        
    }
    
    public var superviews:[JVView]{
        
        var array:[JVView] = []
        var currentSuperView = superview
        
        while (currentSuperView != nil){
            array.append(currentSuperView!)
            currentSuperView = currentSuperView!.superview
        }
        
        return array;
    }
    
    
    public func nearestCommonAncestor(withView secondView: JVView? = nil) -> JVView?{
        
        var commonAncestor: JVView?
        
        if ( (secondView == nil) || (secondView === self) ){
            commonAncestor = self
        }else if secondView!.isDescendant(of: self){
            commonAncestor = self
        }else if self.isDescendant(of: secondView!){
            commonAncestor = secondView
        }else{
            
            // Search for indirect common ancestor
            for superView in superviews{
                if secondView!.superviews.contains(superView){
                    commonAncestor = superView
                }
                else{
                    // No common ancestor
                    debugger.log(debugLevel: .Error, "\(self) has no common ancestor with \(String(describing: secondView))")
                }
            }
            
        }
        
        return commonAncestor
    }
    
    //MARK: - Reading and writing unary sizing constraints trough floats
    
    public var maxWidthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.lessThanOrEqual}
        return filteredConstraints
    }
    
    public var widthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.equal}
        return filteredConstraints
    }
    
    public var minWidthConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.greaterThanOrEqual}
        return filteredConstraints
    }
    
    public var maxHeightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.lessThanOrEqual}
        return filteredConstraints
    }
    
    public var heightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.equal}
        return filteredConstraints
    }
    
    public var minHeightConstraints:[NSLayoutConstraint]{
        var filteredConstraints = (constraints as [NSLayoutConstraint]).filter{$0.firstAttribute == NSLayoutConstraint.Attribute.width}
        filteredConstraints = filteredConstraints.filter{$0.relation == NSLayoutConstraint.Relation.greaterThanOrEqual}
        return filteredConstraints
    }
    
    
    //MARK: Unary sizing constraints
    
    public func addConstraints(minSize:NSSize, maxSize:NSSize, priority:NSLayoutConstraint.Priority = .required){
        addConstraints(minWidth:Float(minSize.width), maxWidth:Float(maxSize.width), priority:priority)
        addConstraints(minHeight:Float(minSize.height), maxHeight:Float(maxSize.height), priority:priority)
    }
    
    public func addConstraints(minWidth:Float, maxWidth:Float, priority:NSLayoutConstraint.Priority = .required){
        
        var newConstraint:NSLayoutConstraint
        
        newConstraint = NSLayoutConstraint(item:self,
                                           attribute:.width,
                                           relatedBy:.greaterThanOrEqual,
                                           toItem:nil,
                                           attribute:.notAnAttribute,
                                           multiplier:1.0,
                                           constant:CGFloat(minWidth)
        )
        newConstraint.install(withPriority:priority)
        
        newConstraint = NSLayoutConstraint(item:self,
                                           attribute:.width,
                                           relatedBy:.lessThanOrEqual,
                                           toItem:nil,
                                           attribute:.notAnAttribute,
                                           multiplier:1.0,
                                           constant:CGFloat(maxWidth)
        )
        newConstraint.install(withPriority:priority)
        
    }
    
    public func addConstraints(width:Float, priority:NSLayoutConstraint.Priority = .required){
        
        let newConstraint = NSLayoutConstraint(item:self,
                                               attribute:.width,
                                               relatedBy:.equal,
                                               toItem:nil,
                                               attribute:.notAnAttribute,
                                               multiplier:1.0,
                                               constant:CGFloat(width)
        )
        newConstraint.install(withPriority:priority)
    }
    
    public func addConstraints(minHeight:Float, maxHeight:Float, priority:NSLayoutConstraint.Priority = .required){
        
        var newConstraint:NSLayoutConstraint
        
        newConstraint = NSLayoutConstraint(item:self,
                                           attribute:.height,
                                           relatedBy:.greaterThanOrEqual,
                                           toItem:nil,
                                           attribute:.notAnAttribute,
                                           multiplier:1.0,
                                           constant:CGFloat(minHeight)
        )
        newConstraint.install(withPriority:priority)
        
        newConstraint = NSLayoutConstraint(item:self,
                                           attribute:.height,
                                           relatedBy:.lessThanOrEqual,
                                           toItem:nil,
                                           attribute:.notAnAttribute,
                                           multiplier:1.0,
                                           constant:CGFloat(maxHeight)
        )
        newConstraint.install(withPriority:priority)
    }
    
    public func addConstraints(height:Float, priority:NSLayoutConstraint.Priority = .required){
        
        let newConstraint = NSLayoutConstraint(item:self,
                                               attribute:.height,
                                               relatedBy:.equal,
                                               toItem:nil,
                                               attribute:.notAnAttribute,
                                               multiplier:1.0,
                                               constant:CGFloat(height)
        )
        newConstraint.install(withPriority:priority)
        
    }
    
    //MARK: Simple view vs superview constraints
    
    
    public func fitVerticalInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            let views = ["thisView": self]
            let metrics = ["margin":NSNumber(value: margin)]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat(formatString: "V:|-margin-[thisView]-margin-|", options:[] ,metrics:metrics, views:views)
        }
        
    }
    
    public func fitHorizontalInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            let views = ["thisView": self]
            let metrics = ["margin":NSNumber(value: margin)]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat(formatString: "H:|-margin-[thisView]-margin-|", options:[], metrics:metrics, views:views)
        }
        
    }
    
    public func fitInSuperview(margin:Float = 0.0){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            fitVerticalInSuperview(margin: margin)
            fitHorizontalInSuperview(margin: margin)
        }
        
    }
    
    
    /**
     Prevent underconstraint layouts by installing fallback constraints with very low priority
     */
    public func constrainToSuperview(){
        
        if( (superview != nil) && (!superview!.isContainerView) ){
            
            let views = ["thisView": self]
            
            NSLayoutConstraint.installConstraintsWithVisualFormat(formatString: "H:|-0@1-[thisView]-0@1-|", options:[], metrics:[:], views:views)
            NSLayoutConstraint.installConstraintsWithVisualFormat(formatString: "V:|-0@1-[thisView]-0@1-|", options:[], metrics:[:], views:views)
        }
        
        
    }
    
    
}

//MARK: - JVBaseView Subclass

/**
 *  This is an abstract View-subclass
 *  that adds some base functionality
 */

public class JVBaseView:JVView{
    
    override public func draw(_ dirtyRect:NSRect){
        
        super.draw(dirtyRect)
        
        #if DEBUG
            
            if let thisViewIdentifier = self.identifier?.rawValue{
                
                let viewToDebug = JVDebugger.environmentalVars["DEBUG_VIEW"] ?? ""
                if  thisViewIdentifier == viewToDebug{
                    let debugColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    debugColor.setStroke()
                    let innerFrame = frame.insetBy(dx: 2.0, dy: 2.0)
                    let coloredEdge = NSBezierPath(rect:innerFrame)
                    coloredEdge.stroke()
                }
            }
            
            debugger.log(debugLevel: .Message, "Frame: \(frame)")
            debugger.log(self)
            
        #endif
    }
    
    override public var intrinsicContentSize:NSSize{
        return NSMakeSize(NSView.noIntrinsicMetric, NSView.noIntrinsicMetric)
    }
    
    override public func viewDidMoveToSuperview(){
        // Fit AutoLayoutViews in their superviews when necessary
        let viewIsOnlyViewInsuperView = superview?.subviews.count == 1
        if viewIsOnlyViewInsuperView{
            fitInSuperview()
            needsLayout = true
        }
    }
    override public func updateConstraints(){
        
        #if DEBUG
            let debugConstraints = JVDebugger.environmentalVars["DEBUG_CONSTRAINTS"] ?? ""
            if  debugConstraints.equalsTrue{
                
                print(self)
                debugger.log("Constraints before:")
                debugger.log(constraints)
                print()
                
            }
        #endif
        
        constrainToSuperview()
        super.updateConstraints()
        
        #if DEBUG
            if debugConstraints.equalsTrue{
                
                print()
                print()
                debugger.log("Constraints after:")
                debugger.log(constraints)
                debugger.drawSeperatorInConsole()
                print()
                
            }
        #endif
    }
    
    
}

