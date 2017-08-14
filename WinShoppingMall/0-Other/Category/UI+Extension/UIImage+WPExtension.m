//
//  UIImage+WPExtension.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "UIImage+WPExtension.h"

@implementation UIImage (WPExtension)

/**
 *  颜色转图片
 */
+ (UIImage *)imageToColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  把image裁剪成圆形图片
 */
- (UIImage *)imageToCircleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据图片名字转换成圆形图片
 */
+ (UIImage *)imageToCircleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] imageToCircleImage];
}

/**
 *  根据传过来的数字大小, 绘制不同程度的圆角矩形
 */
- (UIImage *)imageToCornerImage:(CGFloat)radius
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0, 或者大于宽/高中较小值的一半.
    if (radius < 0) radius = 0;
    else if (radius > MIN(w, h)) radius = MIN(w, h) / 2.0;
    // 绘制
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  裁剪图片
 */
+ (UIImage *)imageToScaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(image.size.width * 0.5, image.size.height * 0.5);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


@end
