//
//  WPUserEnrollController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPUserEnrollController : WPBaseViewController

/**
 *  返回电话号码和密码
 */
@property (nonatomic, strong) void(^userEnrollSuccessBlock)(NSDictionary *userEnrollDict);


@end
