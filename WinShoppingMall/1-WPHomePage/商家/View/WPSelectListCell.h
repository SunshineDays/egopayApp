//
//  WPMerchantCityListCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPMerchantCityListModel.h"

@interface WPSelectListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) WPMerchantCityListModel *model;

@end
