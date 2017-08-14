//
//  WPMerchantDetailController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPMerchantDetailModel.h"

@interface WPMerchantDetailController : WPBaseViewController

/**
 *  商户ID
 */
@property (nonatomic, copy) NSString *merID;



@property (nonatomic, strong) WPMerchantDetailModel *model;

@end
