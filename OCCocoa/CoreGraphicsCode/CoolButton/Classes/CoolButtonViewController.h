//
//  CoolButtonViewController.h
//  CoolButton
//
//  Created by Ray Wenderlich on 9/30/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoolButton;

@interface CoolButtonViewController : UIViewController {
    CoolButton *_button;
}

@property (retain) IBOutlet CoolButton *button;

- (IBAction)hueValueChanged:(id)sender;
- (IBAction)saturationValueChanged:(id)sender;
- (IBAction)brightnessValueChanged:(id)sender;

@end

