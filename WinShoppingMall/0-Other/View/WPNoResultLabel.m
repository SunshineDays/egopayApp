//
//  WPNoResultLabel.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNoResultLabel.h"

@implementation WPNoResultLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:16];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

// 显示在特定的View上
- (void)showOnSuperView:(UIView *)view title:(NSString *)title
{
    [self showOnSuperView:view];
    self.text = title;
}

- (void)showOnSuperView:(UIView *)view
{
    if (![view.subviews containsObject:self])
    {
        [view addSubview:self];
        self.frame = CGRectMake((self.superview.frame.size.width - 200) / 2, self.superview.frame.size.height / 2, 200, 30);
    }
    self.hidden = NO;
}

- (void)hidden
{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)showWithTitle:(NSString *)title {
    [self show];
    self.text = title;
}

- (void)show
{
    [self showOnSuperView:[UIApplication sharedApplication].keyWindow];
}




@end
