//
//  WPTitleView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/26.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPTitleView.h"
#import "UIColor+WPColor.h"
#import "WPAppConst.h"

#define wp_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define wp_ScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation WPTitleView

- (instancetype)init
{
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, wp_ScreenWidth, 64)];
        self.backgroundColor = [UIColor themeColor];
        self.userInteractionEnabled = YES;
        [self titleLabel];
        [self cancelButton];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, wp_ScreenWidth, 44)];
        _titleLabel.font = [UIFont systemFontOfSize:19 weight:2];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(wp_ScreenWidth - 60 - 17.5, 20, 60, 44)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

@end
