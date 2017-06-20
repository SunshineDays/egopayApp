//
//  WPButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/7.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPButton.h"
#import "Header.h"

@implementation WPButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor themeColor];
        [self setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.layer.borderColor = [UIColor lineColor].CGColor;
        self.layer.borderWidth = WPLineHeight;
        self.layer.cornerRadius = WPCornerRadius;
        
    }
    return self;
}



@end
