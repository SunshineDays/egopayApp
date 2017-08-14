//
//  WPUserInforController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPUserInforModel.h"

@interface WPUserInforsController : WPBaseViewController

@property (nonatomic, strong) WPUserInforModel *model;

@property (nonatomic, copy) void(^avaterBlock)(UIImage *avaterImage);

@end
