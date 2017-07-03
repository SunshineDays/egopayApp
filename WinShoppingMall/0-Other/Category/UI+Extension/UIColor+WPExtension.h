//
//  UIColor+WPExtension.h
// WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WPExtension)


/**
 *  随机颜色
 */
+ (UIColor *)randomColor;

/**
 *  不带有透明度的RGB颜色设置
 */
+ (UIColor *)colorWithRGBString:(NSString *)rgbString;

/**
 *  带有透明度的RGB颜色设置
 */
+ (UIColor *)colorWithRGBString:(NSString *)rgbString alpha:(float)opacity;



@end
