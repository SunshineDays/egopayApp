//
//  WPSubAccountSettingController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPSubAccountSettingController : WPBaseViewController

/**
 *  是否是第一次设置
 */
@property (nonatomic, assign) BOOL isFirst;

/**
 *  子账户ID
 */
@property (nonatomic, copy) NSString *clerkID;

@end
