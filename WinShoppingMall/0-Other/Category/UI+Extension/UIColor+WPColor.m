//
//  UIColor+WPColor.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"

@implementation UIColor (WPColor)


+ (UIColor *)themeColor
{
    return [UIColor colorWithRGBString:@"25a2fc" alpha:1];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
}

+ (UIColor *)cellColor
{
    return [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
}

+ (UIColor *)placeholderColor
{
    return [UIColor grayColor];
}

+ (UIColor *)buttonTitleColor
{
    return [UIColor whiteColor];
}

@end
