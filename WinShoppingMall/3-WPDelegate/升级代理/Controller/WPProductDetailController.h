//
//  WPProductDetailController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

#import "WPUpGradeProductModel.h"
#import "WPMerchantGradeProuctModel.h"

@interface WPProductDetailController : WPBaseViewController

@property (nonatomic, strong) WPUpGradeProductModel *delegateModel;

@property (nonatomic, strong) WPMerchantGradeProuctModel *merModel;

@property (nonatomic, strong) UIImage *titleImage;


/**
 *  YES：代理升级 NO：商户升级
 */
@property (nonatomic, assign) BOOL isDelegate;


@end
