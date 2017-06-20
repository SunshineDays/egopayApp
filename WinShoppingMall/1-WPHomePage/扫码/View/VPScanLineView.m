//
//  VPScanLineView.m
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import "VPScanLineView.h"

@implementation VPScanLineView

- (void)drawRect:(CGRect)rect {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    gradient.startPoint = CGPointMake(0.1, .5);
    gradient.endPoint = CGPointMake(0.9, 0.5);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:255 green:255 blue:255 alpha:0].CGColor,
                       (id)[UIColor colorWithRed:233 green:233 blue:233 alpha:.3].CGColor,
                       (id)[UIColor colorWithRed:240 green:240 blue:240 alpha:.5].CGColor,
                       (id)[UIColor colorWithRed:244 green:244 blue:244 alpha:.8].CGColor,
                       (id)[UIColor colorWithRed:240 green:240 blue:240 alpha:.5].CGColor,
                       (id)[UIColor colorWithRed:233 green:233 blue:233 alpha:.3].CGColor,
                       (id)[UIColor colorWithRed:255 green:255 blue:255 alpha:0].CGColor,
                       nil];
    [self.layer insertSublayer:gradient atIndex:0];
}


@end
