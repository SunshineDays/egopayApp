//
//  WPTouchIDShowController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/18.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPTouchIDShowController : WPBaseViewController

//@property (nonatomic, assign) BOOL isPay;

@property (nonatomic, copy) void(^touchIDBlock)(NSString *touchID);

@property (nonatomic, copy) void(^inputPassword)(NSString *inputPassword);


@end
