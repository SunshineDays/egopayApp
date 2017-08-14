//
//  WPJudgeTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPJudgeTool : NSObject

/**
 *  判断是否通过实名认证
 */
+ (BOOL)isIDCardApprove;

/**
 *  判断是否通过商家认证
 */
+ (BOOL)isShopApprove;

/**
 *  判断是否有支付密码
 */
+ (BOOL)isPayPassword;

/**
 *  判断是否是子账户
 */
+ (BOOL)isSubAccount;

/**
 *  判断是否设置指纹支付
 */
+ (BOOL)isPayTouchID;

/**
 *  判断是否设置指纹登录
 */
+ (BOOL)isRegisterTouchID;


/**
 *  验证手机号码
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/** 
 *  验证固定电话
 */
+ (BOOL)validateTel:(NSString *)tel;

/**
 *  验证邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  验证身份证号码
 */
+ (BOOL)validateIDCard:(NSString *)idCard;

/**
 *  验证用户名
 */
+ (BOOL)validateUserName:(NSString *)name;

/**
 *  验证昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  验证密码
 */
+ (BOOL)validatePassword:(NSString *)passWord;


/**
 *  验证价格
 */
+ (BOOL)validatePrice:(NSString *)textField range:(NSRange)range replacementString:(NSString *)string;

/**
 *  验证是否是空格
 */
+ (BOOL)validateSpace:(NSString *)string;

@end
