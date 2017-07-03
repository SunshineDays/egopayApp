//
//  WPProductSubmitController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPProductSubmitController : WPBaseViewController


/**
 *  判断代理／商户升级
 *  YES:代理  NO:商户
 */
@property (nonatomic, assign) BOOL isDelegate;

@property (nonatomic, copy) NSString *userLv;

@property (nonatomic, copy) NSString *gradeMoney;

@end
