//
//  WPPayTypeSelectController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPBankCardModel.h"

@interface WPPayTypeSelectController : WPBaseViewController

/**
 *  交易金额
 */
@property (nonatomic, assign) float amount;

/**
 *  是否支持余额支付
 */
@property (nonatomic, assign) BOOL isBalance;

/**
 *  微信/支付宝/QQ钱包/余额
 */
@property (nonatomic, copy) void(^userPayTypeBlock)(NSInteger payTypeRow);

/**
 *  银行卡
 */
@property (nonatomic, copy) void(^userCardBlock)(WPBankCardModel *model);

@end


