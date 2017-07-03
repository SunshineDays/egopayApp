//
//  UIImage+WPExtension.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WPExtension)

/**
 *  颜色转图片
 */
+ (UIImage *)imageToColor:(UIColor *)color;

/**
 *  把image裁剪成圆形图片
 */
- (UIImage *)imageToCircleImage;

/**
 *  根据图片名字转换成圆形图片
 */
+ (UIImage *)imageToCircleImageNamed:(NSString *)name;

/**
 *  根据传过来的数字大小, 绘制不同程度的圆角矩形
 */
- (UIImage *)imageToCornerImage:(CGFloat)radius;

/**
 *  裁剪图片
 */
+ (UIImage *)imageToScaleImage:(UIImage *)image;

@end
