//
//  WPProgressHUD.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
#import "Header.h"
//#import <UIView+Toast.h>


@interface WPProgressHUD : NSObject

/**
 *  网络正在请求
 */
+ (void)showProgressIsLoading;

/**
 *  网络正在请求的信息
 */
+ (void)showProgressWithStatus:(NSString *)status;

/**
 *  提示信息
 */
+ (void)showInfoWithStatus:(NSString *)status;

/**
 *  成功提示信息
 */
+ (void)showSuccessWithStatus:(NSString *)status;

/**
 *  失败提示信息
 */
+ (void)showErrorWithStatus:(NSString *)status;

/**
 *  让进度条消失
 */
+ (void)dismiss;

//+ (void)showToast:(UIView *)view status:(NSString *)status;




@end
