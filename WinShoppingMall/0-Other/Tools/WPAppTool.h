//
//  WPAppTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAppTool : NSObject

/**
 *  是否通过实名认证
 */
+ (BOOL)isPassIDCardApprove;

/**
 *  是否通过商家认证
 */
+ (BOOL)isPassShopApprove;

/**
 *  是否有支付密码
 */
+ (BOOL)isHavePayPassword;

/**
 *  是否是子账户
 */
+ (BOOL)isSubAccount;

/**
 *  支付需要Touch ID
 */
+ (BOOL)isPayTouchID;

/**
 *  登录需要Touch ID
 */
+ (BOOL)isRegisterTouchID;


@end
