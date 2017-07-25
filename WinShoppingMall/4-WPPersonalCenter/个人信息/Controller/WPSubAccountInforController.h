//
//  WPSubAccountInforController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPEditUserInfoModel.h"
#import "WPSubAccountPersonalModel.h"


@interface WPSubAccountInforController : WPBaseViewController

@property (nonatomic, strong) WPSubAccountPersonalModel *subAccountModel;

@property (nonatomic, strong) UIImage *avaterImage;

@property (nonatomic, copy) void(^avaterImageBlcok)(UIImage *avaterImage);

@end
