//
//  WPSuccessOrfailedController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPSuccessOrfailedController : WPBaseViewController

/**
 *  nil:处理中 1:实时成功 2:支付失败
 */
@property (nonatomic, assign) NSInteger showType;



@end
