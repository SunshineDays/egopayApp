//
//  WPCustomButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/14.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPCustomButton.h"
#import "UIView+WPExtension.h"
#import "UIColor+WPColor.h"
#import "WPAppConst.h"

@implementation WPCustomButton

@end

#pragma mark - 确认按钮
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


#pragma mark - 选择图片按钮
@implementation WPSelectImageButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor cellColor];
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = WPLineHeight;
    self.layer.cornerRadius = WPCornerRadius;
    self.layer.masksToBounds = YES;
    
    self.imageView.xc_centerX = self.frame.size.width / 2;
    self.imageView.xc_centerY = self.frame.size.height / 2;
    
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.titleLabel.xc_x = 0;
    self.titleLabel.xc_y = self.frame.size.height - 15;
    self.titleLabel.xc_width = self.frame.size.width;
}

@end


#pragma mark - 选择按钮
@implementation WPSelectButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.imageView.xc_x = 7;
    self.imageView.xc_y = self.frame.size.height / 2 - 7;
    self.imageView.xc_width = 14;
    self.imageView.xc_height = 14;
    
    self.titleLabel.xc_x = 30;
    self.titleLabel.xc_width = 100;
}

@end


#pragma mark - 首页八个按钮
@implementation WPHomePageClassButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.xc_centerX = self.frame.size.width / 2;
    self.imageView.xc_y = 17.5;
    
    self.titleLabel.xc_x = 0;
    self.titleLabel.xc_y = self.frame.size.height - 15;
    self.titleLabel.xc_width = self.frame.size.width;
}

@end


#pragma mark - 首页国际信用卡按钮
@implementation WPHomePageCreditButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.xc_centerX = self.frame.size.width * 3 / 4;
    self.imageView.xc_centerY = self.frame.size.height / 2;
    
    self.titleLabel.xc_centerX = self.frame.size.width / 4;
    self.titleLabel.xc_centerY = self.frame.size.height / 2;
}

@end


#pragma mark - 分享app图标按钮
@implementation WPShareIconButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.xc_x = 0;
    self.imageView.xc_y = 0;
    self.imageView.xc_width = self.frame.size.width;
    self.imageView.xc_height = self.frame.size.height - 20;
    
    self.imageView.layer.borderColor = [UIColor lineColor].CGColor;
    self.imageView.layer.borderWidth = WPLineHeight;
    self.imageView.layer.cornerRadius = WPCornerRadius;
    
    self.titleLabel.xc_x = -20;
    self.titleLabel.xc_y = self.frame.size.height - 20;
    self.titleLabel.xc_width = self.frame.size.width + 40;
    self.titleLabel.xc_height = 20;
}

@end


