//
//  CoolPatternAppDelegate.h
//  CoolPattern
//
//  Created by Ray Wenderlich on 10/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoolPatternViewController;

@interface CoolPatternAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CoolPatternViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CoolPatternViewController *viewController;

@end

