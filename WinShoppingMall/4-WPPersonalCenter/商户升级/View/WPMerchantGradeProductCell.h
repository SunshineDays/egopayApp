//
//  WPMerchantGradeProductCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/4.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMerchantGradeProuctModel.h"
#import "WPUpGradeProductModel.h"

@interface WPMerchantGradeProductCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *lvImageView;

@property (weak, nonatomic) IBOutlet UILabel *lvNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;

@property (nonatomic, strong) WPMerchantGradeProuctModel *merchantLvModel;

@property (nonatomic, strong) WPUpGradeProductModel *delegateLvModel;

@end
