//
//  WPEditInforController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPEditInforController : WPBaseViewController

@property (nonatomic, copy) void(^inforBlock)(NSString *inforBlock);

@end
