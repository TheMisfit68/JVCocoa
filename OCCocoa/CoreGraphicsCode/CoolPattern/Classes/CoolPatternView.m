//
//  CoolPatternView.m
//  CoolPattern
//
//  Created by Ray Wenderlich on 10/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CoolPatternView.h"
static inline double radians (double degrees) { return degrees * M_PI/180; }

@implementation CoolPatternView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
} 

void MyDrawColoredPattern (void *info, CGContextRef context) {
    
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
       
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);

    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    // Alternative
    //CGContextFillEllipseInRect(context, CGRectMake(-1, -1, 8, 8));

    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    // Alternative
    //CGContextFillEllipseInRect(context, CGRectMake(12, 12, 8, 8));
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, rect);

    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };

    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);

    CGPatternRef pattern = CGPatternCreate(NULL,
                                           CGRectMake(0, 0, 24, 24),
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = end - start;
    totalDrawTime += diff;
    NSLog(@"Total draw time: %f", totalDrawTime);
    
}

- (void)drawRect2:(CGRect)rect {
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    float patternX = 24.0;
    float patternY = 24.0;
    int repeatX = ceil(rect.size.width / patternX);
    int repeatY = ceil(rect.size.height / patternY);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, rect);
    
    for(int i = 0; i < repeatX; ++i) {
        
        for(int j = 0; j < repeatY; ++j) {
            
            float originX = rect.origin.x + (i * patternX);
            float originY = rect.origin.y + (j * patternY);
            
            CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
            CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
            
            CGContextSetFillColorWithColor(context, dotColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
            
            CGContextAddArc(context, originX + 3, originY + 3, 4, 0, radians(360), 0);
            CGContextFillPath(context);
            
            CGContextAddArc(context, originX + 16, originY + 16, 4, 0, radians(360), 0);
            CGContextFillPath(context);           
            
        }
        
    }
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = end - start;
    totalDrawTime += diff;
    NSLog(@"Total draw time: %f", totalDrawTime);
    
    
}

- (void)drawRect3:(CGRect)rect {
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    UIImage * background = [UIImage imageNamed:@"background.png"];
    [background drawInRect:self.bounds];
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = end - start;
    totalDrawTime += diff;
    NSLog(@"Total draw time: %f", totalDrawTime);
    
}

- (void)drawRect4:(CGRect)rect {
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    CGColorRef color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundSmall.png"]].CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = end - start;
    totalDrawTime += diff;
    NSLog(@"Total draw time: %f", totalDrawTime);
}


@end
