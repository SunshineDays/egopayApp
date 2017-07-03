//
//  UIView+WPExtension.h
// WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WPExtension)

@property(nonatomic, assign) CGSize xc_size;
@property(nonatomic, assign) CGFloat xc_width;
@property(nonatomic, assign) CGFloat xc_height;
@property(nonatomic, assign) CGFloat xc_x;
@property(nonatomic, assign) CGFloat xc_y;
@property(nonatomic, assign) CGFloat xc_centerX;
@property(nonatomic, assign) CGFloat xc_centerY;

/**
 *  从xib加载View
 */
+ (instancetype)xc_viewFromXib;

/**
 *  判断self和view是否重叠
 */
- (BOOL)xc_intersectsWithView:(UIView *)view;

/**
 *  打电话
 */
- (void)callToNum:(NSString *)numString;



@end
