//
//  WPWithdrawController.h
//  WinShoppingMall
//  提现
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPWithdrawController : WPBaseViewController


@property (nonatomic, copy) void (^updataMoneyBlock)(NSString *moneyString);

@end

