//
//  WPHomeButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPHomeButton.h"

#import "UIView+WPExtension.h"

#import "Header.h"


@implementation WPHomeButton


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = (kScreenWidth - 2 * WPLeftMargin) / 4;
    self.imageView.xc_centerX = width / 2;
    self.titleLabel.xc_centerX = width / 2;
    self.imageView.xc_y = WPLeftMargin;
    self.titleLabel.xc_y = 75;
}

@end
