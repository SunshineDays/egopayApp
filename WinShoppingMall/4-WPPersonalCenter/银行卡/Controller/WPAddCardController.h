//
// WPAddCardController.h
// WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPAddCardController :WPBaseViewController

/**
 *  是否需要返回传值
 */
//@property (nonatomic, assign) BOOL isNeedCallBack;

//@property (nonatomic, strong) void(^userAddCardSuccessBlock)(NSDictionary *addCardSuccess);


/**
 *  选择银行卡类型
 *  1:信用卡 2:储蓄卡
 */
@property (nonatomic, copy) NSString *cardType;


@end
