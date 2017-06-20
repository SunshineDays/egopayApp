//
//  WPPasswordController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPPasswordController : WPBaseViewController

/**
 *  第一次设置支付密码 YES NO
 */
@property (nonatomic, assign) BOOL isFirstPassword;

/**
 *  修改密码类型 1:密码 2:支付密码
 */
@property (nonatomic, copy) NSString *passwordType;

@end
