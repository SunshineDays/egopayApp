//
//  WPPayTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPayPasswordController.h"

@interface WPPayTool : NSObject

/**
 * 输入支付密码弹窗
 */
+ (void)payWithViewTitle:(NSString *)title success:(void (^)(id success))success;


/**
 * Touch ID
 */
+ (void)payWithTouchIDsuccess:(void (^)(id success))touchIDSuccess failure:(void (^)(NSError *error))touchIDFailure;


/**
 * 无论是密码／指纹支付，都返回password
 */
+ (void)payWithTitle:(NSString *)title password:(void (^)(id password))password;


@end
