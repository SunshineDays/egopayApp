//
//  WPPayTypeController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPBankCardModel.h"

@interface WPPayTypeController : WPBaseViewController


/**
 *  交易金额
 */
@property (nonatomic, assign) float amount;


/**
 *  是否支持余额支付
 */
@property (nonatomic, assign) BOOL isUseMoney;

/**
 *  微信/支付宝/余额
 */
@property (nonatomic, copy) void(^userPayTypeBlock)(NSString *payType);

/**
 *  银行卡
 */
@property (nonatomic, copy) void(^userCardBlock)(WPBankCardModel *model);

/**
 *  添加银行卡
 */
@property (nonatomic, copy) void(^userAddCardBlock)();


@end
