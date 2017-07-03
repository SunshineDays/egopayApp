//
//  WPRegex.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPRegex : NSObject

/**
 *  电话号码
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  身份证号码
 */
+ (BOOL)validateIDCard:(NSString *)idCard;

/**
 *  用户名
 */
+ (BOOL)validateUserName:(NSString *)name;

/**
 *  昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  密码
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 *  价钱数字格式
 */
+ (BOOL)validateMoneyNumber:(NSString *)textField range:(NSRange)range replacementString:(NSString *)string;


@end
