//
//  WPBankCardController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

#import "WPBankCardModel.h"

@interface WPBankCardController : WPBaseViewController

/**
 *  判断银行卡显示类型
 *  1:全部 2:国际信用卡(通过审核) 3:储蓄卡(通过审核) 4:全部(通过审核)
 */
@property (nonatomic, copy) NSString *showCardType;


@property (nonatomic, copy) void(^cardInfoBlock)(WPBankCardModel *model);


@end
