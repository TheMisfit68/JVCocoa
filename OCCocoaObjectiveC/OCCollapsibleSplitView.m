//
//  OCCollapsibleSplitView.m
//  OCCocoa
//
//  Created by Jan Verrept on 27/05/12.
//  Copyright (c) 2012 OneClick BVBA. All rights reserved.
//

#import "OCCollapsibleSplitView.h"

@implementation OCCollapsibleSplitView

//+ (BOOL)requiresConstraintBasedLayout{
//	return YES;
//}

- (id)initWithCoder:(NSCoder *) 
{
    self = [super initWithCoder:coder];
    if (self) {
        if ([self isVertical]){
            _autoCollapseSize = self.bounds.size.width/10;
		}else{
            _autoCollapseSize = self.bounds.size.height/10;
		}
    }
    return self;
}


-(void)setCollapsibleSubViews:(NSArray *)someSubviews{

    if (_collapsibleSubViews != someSubviews) // Default Copy accessor
    {
        _collapsibleSubViews = [someSubviews copy];
    }

    _subviewSizes = [[NSMutableArray alloc] initWithCapacity:[_collapsibleSubViews count]];
	for (OCView *collapsibleSubView in [self collapsibleSubViews]) {
		if([self isVertical]){
            [_subviewSizes addObject:@((float)collapsibleSubView.bounds.size.width)];
		}else{
            [_subviewSizes addObject:@((float)collapsibleSubView.bounds.size.height)];
		}
    }
}



#pragma mark -
#pragma mark resize events

-(void)mouseDown:(NSEvent *)theEvent{
    
    [super mouseDown:theEvent];


	NSLog(@"%lu", (unsigned long)[theEvent type]);

    switch ([theEvent type]) {
        case  NSLeftMouseDown:{            
            [self rememberNewSizes];
			NSLog(@"mousedown");

            break;
        }
		case  NSLeftMouseDragged:{
			NSLog(@"dragged down");
			break;
		}
        default:
			NSLog(@"%lu", (unsigned long)[theEvent type]);
            break;
    }
    
}

-(void)mouseDragged:(NSEvent *)theEvent{
	NSLog(@"dragged");
	NSLog(@"%lu", (unsigned long)[theEvent type]);
}

- (void)mouseMoved:(NSEvent *)theEvent{
 	NSLog(@"moved");

}


- (void)rememberNewSizes{

    for (NSView *collapsibleSubView in [self collapsibleSubViews]) {
        if(![self isSubviewCollapsed:collapsibleSubView]){
			
            NSUInteger viewIndex = [[self collapsibleSubViews] indexOfObject:collapsibleSubView];
            if( [self isVertical] && ((collapsibleSubView.bounds.size.width) >= [self autoCollapseSize]) )
                (self.subviewSizes)[viewIndex] = @((float)collapsibleSubView.bounds.size.width);
            else if ( ![self isVertical] && ((collapsibleSubView.bounds.size.height) >= [self autoCollapseSize]) )
                (self.subviewSizes)[viewIndex] = @((float)collapsibleSubView.bounds.size.height);
        }
    }

}

-(void)restorePreviousSize:(NSView *)aView{
	
    if ([self isSubviewCollapsed:aView]){
        int viewIndex = [[self collapsibleSubViews] indexOfObject:aView];
        float storedSize = [[self subviewSizes][viewIndex] floatValue];
        float currentWidth = aView.bounds.size.width;
        float currentHeight = aView.bounds.size.height;

        if( [self isVertical]){
			NSSize newSize = NSMakeSize(MAX(MAX([self autoCollapseSize], currentWidth), storedSize), currentHeight);
			[self addConstraintsForWidth:newSize.width withPriority:1.0];
        }else{
			NSSize newSize = NSMakeSize(currentWidth, MAX(MAX([self autoCollapseSize], currentHeight), storedSize));
			[self addConstraintsForHeight:newSize.height withPriority:1.0];

        }
    }

}

@end
