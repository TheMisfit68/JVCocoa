//
//  OCLayoutConstraint.swift
//  OCCocoa
//
//  Created by Administrator on 27/09/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

//MARK: - Equatable

public func == (lhs: NSLayoutConstraint, rhs: NSLayoutConstraint) -> Bool{
    	return (lhs.relation == rhs.relation) &&
    		(lhs.secondItem as! NSView == rhs.secondItem as! NSView) &&
    		(lhs.secondAttribute == rhs.secondAttribute) &&
    		(lhs.multiplier == rhs.multiplier) &&
    		(lhs.constant == rhs.constant) &&
    		(lhs.priority == rhs.priority)
}

extension NSLayoutConstraint {
    
    //MARK: Class functions
    
    internal class func installConstraintsWithVisualFormat(formatString: String,
        options:NSLayoutFormatOptions,
        metrics:NSDictionary,
        views:NSDictionary){
            //
            //            NSLayoutConstraint.installConstraints(
            //
            //                NSLayoutConstraint.constraintsWithVisualFormat(formatString,
            //                    options:options,
            //                    metrics:metrics as? [NSObject : AnyObject],
            //                    views:views as! [NSObject : AnyObject]) as! [NSLayoutConstraint]
            //            )
            //
    }
    
    internal class func installConstraints(multipleConstraints: [NSLayoutConstraint]){
        
        //        for constraint in multipleConstraints{
        //            constraint.installWithPriority(constraint.priority)
        //        }
        
    }
    
    
    
    internal class func removeConstraints(multipleConstraints: [NSLayoutConstraint]){
        
        //        for constraint in multipleConstraints{
        //            constraint.remove()
        //        }
        
    }
    
    //MARK: - Smart self-install/remove
    
    internal func installWithPriority(aPriority: NSLayoutPriority = 1.0){
        
        //        priority = aPriority
        //        let firstView:NSView = firstItem as! NSView
        //        let secondView:NSView = secondItem as! NSView
        //
        //        if let nearestCommonAncestor = firstView.nearestCommonAncestorWithView(secondView) {
        //
        //            firstView.translatesAutoresizingMaskIntoConstraints = firstView.isContainerView
        //            secondView.translatesAutoresizingMaskIntoConstraints = secondView.isContainerView
        //            nearestCommonAncestor.translatesAutoresizingMaskIntoConstraints = nearestCommonAncestor.isContainerView
        //
        //            let existingConstraints = nearestCommonAncestor.constraints as! [NSLayoutConstraint]
        //            let constraintComparison: constraintComparisonResult = .constraintComparisonResultDifferent
        //            var i:Int = 0
        //
        //
        //            while ( (constraintComparison == .constraintComparisonResultDifferent) && (i < existingConstraints.count) ){
        //
        //                let existingConstraint: NSLayoutConstraint = existingConstraints[i]
        //
        //
        //                let constraintComparison = compareWithConstraint(existingConstraint)
        //
        //
        //                switch (constraintComparison) {
        //                case .constraintComparisonResultChanged:
        //                    existingConstraint.constant = constant;
        //                    if((environmentalVars["DEBUG_CONSTRAINTS"] as! Bool) == true){
        //
        //                        debugger.println("Constraint changed on \(nearestCommonAncestor.className) '\(nearestCommonAncestor.identifier)':", color: NSColor.orangeColor())
        //                        debugger.println(existingConstraint, color: NSColor.orangeColor())
        //
        //                    }
        //                case .constraintComparisonResultConflicts:
        //                    existingConstraint.remove()
        //                default:()
        //
        //                }
        //
        //                ++i;
        //
        //            }
        //
        //            nearestCommonAncestor.addConstraint(self)
        //            if((environmentalVars["DEBUG_CONSTRAINTS"] as! Bool) == true){
        //
        //                debugger.println("Constraint added to \(nearestCommonAncestor.className) '\(nearestCommonAncestor.identifier)':", color: NSColor.redColor())
        //                debugger.println(self, color: NSColor.greenColor())
        //
        //            }
        //        }
    }
    
    internal func remove(){
        
        //        let firstView = firstItem as! NSView
        //        let secondView = secondItem as! NSView
        //
        //        if let nearestCommonAncestor = firstView.nearestCommonAncestorWithView(secondView) {
        //
        //            nearestCommonAncestor.removeConstraint(self)
        //
        //            if((environmentalVars["DEBUG_CONSTRAINTS"] as! Bool) == true){
        //
        //                debugger.println("Constraint removed from \(nearestCommonAncestor.className) '\(nearestCommonAncestor.identifier)':", color:NSColor.redColor())
        //                debugger.println(self, color: NSColor.redColor())
        //
        //            }
        //
        //        }
        
        
    }
    
    
    //MARK: - Comparable
    
    private enum constraintComparisonResult:Int{
        case constraintComparisonResultDifferent = -1,
        constraintComparisonResultEqual = 0,
        constraintComparisonResultChanged = 1,
        constraintComparisonResultConflicts = 2
    }
    
    private func compareWithConstraint(comparisonConstraint:NSLayoutConstraint) -> constraintComparisonResult{
        
        let result:constraintComparisonResult = .constraintComparisonResultDifferent
        
        //        if( (firstItem as! NSView == comparisonConstraint.firstItem as! NSView) && (firstAttribute == comparisonConstraint.firstAttribute) ){
        //
        //            let constraintIsEqual:Bool = (self == comparisonConstraint)
        //
        //            let constraintChanged:Bool =
        //            (relation == comparisonConstraint.relation) &&
        //                (secondItem as! NSView == comparisonConstraint.secondItem as! NSView) &&
        //                (secondAttribute == comparisonConstraint.secondAttribute) &&
        //                (multiplier == comparisonConstraint.multiplier) &&
        //                (constant != comparisonConstraint.constant) &&
        //                (priority == comparisonConstraint.priority)
        //
        //            let bothConstraintsRelateToSameSuperview:Bool =
        //            !constraintIsEqual &&
        //                !constraintChanged &&
        //                (firstItem as! NSView) == (secondItem as! NSView).superview &&
        //                (comparisonConstraint.firstItem as! NSView) == (comparisonConstraint.secondItem as! NSView).superview
        //
        //            if (!bothConstraintsRelateToSameSuperview){
        //
        //                var relationshipConflicts:Bool = false
        //                if comparisonConstraint.relation.rawValue > relation.rawValue { 	//  More towards minimal limit (i.e. NSLayoutRelationGreaterThanOrEqual)
        //                    relationshipConflicts =	(comparisonConstraint.constant > constant);
        //                }else if(comparisonConstraint.relation == relation){
        //                    relationshipConflicts = true; 		// Same limit always produces a conflict
        //                }else if(comparisonConstraint.relation.rawValue < relation.rawValue){ //  More towards maximal limit (i.e. NSLayoutRelationLessThanOrEqual)
        //                    relationshipConflicts = (comparisonConstraint.constant < constant);
        //                }
        //                
        //                let valuesConflict:Bool = (multiplier != comparisonConstraint.multiplier) || (constant != comparisonConstraint.constant)
        //                
        //                let constraintConflicts:Bool =
        //                !constraintIsEqual &&
        //                    !constraintChanged &&
        //                    (relationshipConflicts || valuesConflict ) &&
        //                    (priority == comparisonConstraint.priority)
        //                
        //                if (constraintIsEqual) {
        //                    result = .constraintComparisonResultEqual
        //                }else if(constraintChanged){
        //                    result = .constraintComparisonResultChanged
        //                }else if (constraintConflicts){
        //                    result = .constraintComparisonResultConflicts
        //                }
        //            }
        //        }
        
        return result
        
    }
    
    
}




