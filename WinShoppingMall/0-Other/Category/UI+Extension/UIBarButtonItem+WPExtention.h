//
//  UIBarButtonItem+ WPExtention.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPBarButton.h"


@interface UIBarButtonItem (WPExtention)

+ (instancetype)WP_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage;

+ (instancetype)WP_itemWithTarget:(id)target action:(SEL)action color:(UIColor *)color highColor:(UIColor *)highColor title:(NSString *)title;

+ (instancetype)WP_itemWithType:(WPBarButtonType)barButtonType target:(id)target action:(SEL)action imge:(UIImage *)image highImage:(UIImage *)highImage textColor:(UIColor *)textColor highColor:(UIColor *)highColor title:(NSString *)title;

@end
