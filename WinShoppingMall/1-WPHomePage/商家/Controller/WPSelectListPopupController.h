//
//  WPSelectListPopupController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPMerchantCityListModel.h"


@interface WPSelectListPopupController : WPBaseViewController

@property (nonatomic, copy) void(^selectCategoryBlock)(WPMerchantCityListModel *model);

@property (nonatomic, copy) void(^selecteNameBlock)(NSString *nameStr);

/**
 *  1:城市 2:类别 3:银行
 */
@property (nonatomic, assign) int type;


@end
