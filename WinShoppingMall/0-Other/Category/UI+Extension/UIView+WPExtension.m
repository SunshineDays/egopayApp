//
//  UIView+WPExtension.m
// WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "UIView+WPExtension.h"

@implementation UIView (WPExtension)

+ (instancetype)xc_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (BOOL)xc_intersectsWithView:(UIView *)view
{
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (CGSize)xc_size
{
    return self.frame.size;
}

- (void)setXc_size:(CGSize)xc_size
{
    CGRect frame = self.frame;
    frame.size = xc_size;
    self.frame = frame;
}

- (CGFloat)xc_width
{
    return self.frame.size.width;
}

- (void)setXc_width:(CGFloat)xc_width
{
    CGRect frame = self.frame;
    frame.size.width = xc_width;
    self.frame = frame;
}

- (CGFloat)xc_height
{
    return self.frame.size.height;
}

- (void)setXc_height:(CGFloat)xc_height
{
    CGRect frame = self.frame;
    frame.size.height = xc_height;
    self.frame = frame;
}

- (CGFloat)xc_x
{
    return self.frame.origin.x;
}

- (void)setXc_x:(CGFloat)xc_x
{
    CGRect frame = self.frame;
    frame.origin.x = xc_x;
    self.frame = frame;
}

- (CGFloat)xc_y
{
    return self.frame.origin.y;
}

- (void)setXc_y:(CGFloat)xc_y
{
    CGRect frame = self.frame;
    frame.origin.y = xc_y;
    self.frame = frame;
}

- (CGFloat)xc_centerX
{
    return self.center.x;
}

- (void)setXc_centerX:(CGFloat)xc_centerX
{
    CGPoint center = self.center;
    center.x = xc_centerX;
    self.center = center;
}

- (CGFloat)xc_centerY
{
    return self.center.y;
}

- (void)setXc_centerY:(CGFloat)xc_centerY
{
    CGPoint center = self.center;
    center.y = xc_centerY;
    self.center = center;
}

- (void)callToNum:(NSString *)numString
{
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",numString];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNumber]]];
    [self addSubview:callWebView];}

@end
