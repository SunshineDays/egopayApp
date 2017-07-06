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


- (void)initWithTitle:(NSString *)title titleImage:(UIImage *)image model:(id)model isAgency:(BOOL)isAgency isUpgrade:(BOOL)isUpgrade;

@end
