//
//  OCCollapsibleSplitView.h
//  OCCocoa
//
//  Created by Jan Verrept on 27/05/12.
//  Copyright (c) 2012 OneClick BVBA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCView.h"

@interface OCCollapsibleSplitView : NSSplitView
@property (copy, nonatomic) NSArray *collapsibleSubViews;
@property (assign) float autoCollapseSize;

@property (copy) NSMutableArray *subviewSizes;

// Helper methods for the OCCollapsibleSplitView-delegate
//-(BOOL)canCollapse:(NSView *)aView; // To be called in "canCollapseSubview"
//-(NSArray *)minimumMarginsForSubViewAt:(NSInteger)anIndex; // To be called in both "constrain coördinate"-methods

@end
