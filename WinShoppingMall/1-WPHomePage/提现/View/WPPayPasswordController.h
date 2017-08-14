//
//  WPPayPasswordController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPPayPasswordController : WPBaseViewController

/**
 *  类型
 */
@property (nonatomic, copy) NSString *titleString;

/**
 *  返回支付密码
 */
@property (nonatomic, copy) void(^payPasswordBlock)(NSString *payPassword);

/**
 *  忘记支付密码
 */
@property (nonatomic, copy) void(^forgetPasswordBlock)();

@end
