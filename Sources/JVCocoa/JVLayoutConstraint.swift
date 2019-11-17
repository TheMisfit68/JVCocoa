//
//  NSLayoutConstraint.swift
//  JVCocoa
//
//  Created by Administrator on 27/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

// MARK: Cross platform typing
#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

/**
 *  This is a protocol(extension) that allows for
 *  constraints that can self-install/remove
 */

public protocol JVInstallableConstraint{
    
    static func installConstraintsWithVisualFormat(formatString: String,
                                                   options:NSLayoutConstraint.FormatOptions,
                                                   metrics:[String:NSNumber]?,
                                                   views:[String:Any])
    
    static func installConstraints(multipleConstraints: [NSLayoutConstraint])
    static func removeConstraints(multipleConstraints: [NSLayoutConstraint])
    
    func install(withPriority: NSLayoutConstraint.Priority )
    func remove()
}


extension NSLayoutConstraint:JVInstallableConstraint{
    
    //MARK: Class functions for installing
    
    public class func installConstraintsWithVisualFormat(formatString: String,
                                                         options:NSLayoutConstraint.FormatOptions,
                                                         metrics:[String:NSNumber]?,
                                                         views:[String:Any]){
        
        NSLayoutConstraint.installConstraints(multipleConstraints:
            NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                           options:options,
                                           metrics:metrics,
                                           views:views
            )
        )
        
    }
    
    public class func installConstraints(multipleConstraints: [NSLayoutConstraint]){
        
        for constraint in multipleConstraints{
            constraint.install(withPriority:constraint.priority)
        }
        
    }
    
    
    
    public class func removeConstraints(multipleConstraints: [NSLayoutConstraint]){
        
        for constraint in multipleConstraints{
            constraint.remove()
        }
        
    }
    
    //MARK: - Smart self-install/remove
    
    public func install(withPriority aPriority: NSLayoutConstraint.Priority = .required){
        
        priority = aPriority
        let firstView:NSView = firstItem as! JVView
        let secondView:NSView = secondItem as! JVView
        
        if let nearestCommonAncestor = firstView.nearestCommonAncestor(withView: secondView) {
            
            firstView.translatesAutoresizingMaskIntoConstraints = firstView.isContainerView
            secondView.translatesAutoresizingMaskIntoConstraints = secondView.isContainerView
            nearestCommonAncestor.translatesAutoresizingMaskIntoConstraints = nearestCommonAncestor.isContainerView
            
            let existingConstraints = nearestCommonAncestor.constraints
            let constraintComparison: JVConstraintComparisonResult = .different
            var i:Int = 0
            
            
            while ( (constraintComparison == .different) && (i < existingConstraints.count) ){
                
                let existingConstraint: NSLayoutConstraint = existingConstraints[i]
                let constraintComparison = compareWithConstraint(existingConstraint)
                
                
                switch (constraintComparison) {
                case .changed:
                    existingConstraint.constant = constant;
                    
                    #if DEBUG
                        
                        let debugConstraints = JVDebugger.environmentalVars["DEBUG_CONSTRAINTS"] ?? ""
                        if  debugConstraints.equalsTrue{
                            
                            var extraIdentifierString = ""
                            if let ancestorIdentifier = nearestCommonAncestor.identifier?.rawValue{
                                extraIdentifierString =  ", '\(ancestorIdentifier)'"
                            }
                            JVDebugger.shared.log("✏️ Constraint changed \(nearestCommonAncestor.className)\(extraIdentifierString):")
                            JVDebugger.shared.log(self)
                        }
                        
                    #endif
                    
                case .conflicts:
                    existingConstraint.remove()
                default:()
                    
                }
                
                i += 1;
                
            }
            
            if constraintComparison != .changed{
                nearestCommonAncestor.addConstraint(self)
                
                #if DEBUG
                    
                    let debugConstraints = JVDebugger.environmentalVars["DEBUG_CONSTRAINTS"] ?? ""
                    if  debugConstraints.equalsTrue{
                        
                        var extraIdentifierString = ""
                        if let ancestorIdentifier = nearestCommonAncestor.identifier?.rawValue{
                            extraIdentifierString =  ", '\(ancestorIdentifier)'"
                        }
                        JVDebugger.shared.log("✅ Constraint added to \(nearestCommonAncestor.className)\(extraIdentifierString):")
                        JVDebugger.shared.log(self)
                    }
                    
                #endif
            }
            
        }
    }
    
    public func remove(){
        
        let firstView = firstItem as! JVView
        let secondView = secondItem as! JVView
        
        if let nearestCommonAncestor = firstView.nearestCommonAncestor(withView: secondView) {
            
            nearestCommonAncestor.removeConstraint(self)
            
            #if DEBUG
                
                let debugConstraints = JVDebugger.environmentalVars["DEBUG_CONSTRAINTS"] ?? ""
                if  debugConstraints.equalsTrue{
                    
                    var extraIdentifierString = ""
                    if let ancestorIdentifier = nearestCommonAncestor.identifier?.rawValue{
                        extraIdentifierString =  ", '\(ancestorIdentifier)'"
                    }
                    JVDebugger.shared.log("❌ Constraint removed from \(nearestCommonAncestor.className)\(extraIdentifierString):")
                    JVDebugger.shared.log(self)
                }
                
            #endif
            
        }
        
        
    }
    
    
    
    //MARK: - Comparable
    
    private enum JVConstraintComparisonResult: Int{
        case different = -1
        case equal = 0
        case changed = 1
        case conflicts = 2
    }
    
    private func compareWithConstraint(_ comparisonConstraint:NSLayoutConstraint) -> JVConstraintComparisonResult{
        
        let firstView = self.firstItem as! JVView
        let secondView = self.secondItem as! JVView
        
        let firstComparedView = comparisonConstraint.firstItem as! JVView
        let secondComparedView = comparisonConstraint.secondItem as! JVView
        
        var result:JVConstraintComparisonResult = .different
        if (self == comparisonConstraint){
            
            result = .equal
            
        }else if (firstView == firstComparedView) &&
            (firstAttribute == comparisonConstraint.firstAttribute) &&
            (secondView == secondComparedView) &&
            (secondAttribute == comparisonConstraint.secondAttribute) &&
            (relation == comparisonConstraint.relation) &&
            (multiplier == comparisonConstraint.multiplier) &&
            (constant != comparisonConstraint.constant) &&
            (priority == comparisonConstraint.priority){
            
            result = . changed
            
        }else if( (firstAttribute == comparisonConstraint.firstAttribute) && (firstView == firstComparedView) ){
            
            let notSuperViewConstraints:Bool = !(
                    firstView == secondView.superview &&
                    firstComparedView == secondComparedView.superview)
            
            if (notSuperViewConstraints){
                
                var relationshipConflicts:Bool = false
                if comparisonConstraint.relation.rawValue > relation.rawValue {     //  More towards minimal limit (i.e. NSLayoutRelationGreaterThanOrEqual)
                    relationshipConflicts =    (comparisonConstraint.constant > constant);
                }else if(comparisonConstraint.relation == relation){
                    relationshipConflicts = true;         // Same limit always produces a conflict
                }else if(comparisonConstraint.relation.rawValue < relation.rawValue){ //  More towards maximal limit (i.e. NSLayoutRelationLessThanOrEqual)
                    relationshipConflicts = (comparisonConstraint.constant < constant);
                }
                
                let valuesConflict:Bool = (multiplier != comparisonConstraint.multiplier) || (constant != comparisonConstraint.constant)
                
                let constraintConflicts:Bool =
                    (relationshipConflicts || valuesConflict ) &&
                        (priority == comparisonConstraint.priority)
                
                if (constraintConflicts){
                    result = .conflicts
                }
            }
        }
        
        return result
    }
    
}






