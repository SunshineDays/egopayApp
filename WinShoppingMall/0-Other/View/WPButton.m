//
//  WPButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/7.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPButton.h"
#import "WPAppConst.h"
#import "UIColor+WPColor.h"

@implementation WPButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor buttonBackgroundDefaultColor];
        [self setTitleColor:[UIColor buttonTitleDefaultColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        self.layer.borderColor = [UIColor lineColor].CGColor;
        self.layer.borderWidth = WPLineHeight;
        self.layer.cornerRadius = WPCornerRadius;
        self.userInteractionEnabled = NO;
    }
    return self;
}



@end
