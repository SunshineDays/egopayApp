//
//  UIBarButtonItem+ WPExtention.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "UIBarButtonItem+WPExtention.h"

@implementation UIBarButtonItem (WPExtention)


+ (instancetype)WP_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage
{
    WPBarButton *button = [WPBarButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage ? highImage :image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)WP_itemWithTarget:(id)target action:(SEL)action color:(UIColor *)color highColor:(UIColor *)highColor title:(NSString *)title
{
    WPBarButton *button = [WPBarButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color ? highColor : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highColor ? highColor : [UIColor blackColor] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)WP_itemWithType:(WPBarButtonType)barButtonType target:(id)target action:(SEL)action imge:(UIImage *)image highImage:(UIImage *)highImage textColor:(UIColor *)textColor highColor:(UIColor *)highColor title:(NSString *)title
{
    WPBarButton *button = [WPBarButton buttonWithType:UIButtonTypeCustom];
    
    button.barButtonType = barButtonType;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor ? textColor : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highColor ? highColor : [UIColor blackColor] forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage ? highImage : image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[self alloc] initWithCustomView:button];
    
}



@end
