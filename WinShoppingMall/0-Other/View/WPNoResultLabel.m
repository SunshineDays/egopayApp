//
//  WPNoResultLabel.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNoResultLabel.h"
#import "UIView+WPExtension.h"

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

- (void)showOnSuperView:(UIView *)view
{
    if (![view.subviews containsObject:self])
    {
        [view addSubview:self];
        self.frame = CGRectMake((self.superview.xc_width - 200)/2, self.superview.xc_height/2, 200, 30);
    }
    self.hidden = NO;
}

- (void)showOnSuperView:(UIView *)view title:(NSString *)title {
    [self showOnSuperView:view];
    self.text = title;
}

- (void)showWithTitle:(NSString *)title {
    [self show];
    self.text = title;
}


- (void)show
{
    [self showOnSuperView:[UIApplication sharedApplication].keyWindow];
}

- (void)hidden
{
    self.hidden = YES;
    [self removeFromSuperview];
}

@end
