//
//  WPSelectCardButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSelectButton.h"
#import "UIView+WPExtension.h"

#import "Header.h"

@implementation WPSelectButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    float height = 40;
    self.imageView.xc_x = 7;
    self.imageView.xc_y = height / 2 - 7;
    self.imageView.xc_width = 14;
    self.imageView.xc_height = 14;
//    self.titleLabel.xc_centerX = 60;
    self.titleLabel.xc_x = 30;
    self.titleLabel.xc_width = 100;
}

@end
