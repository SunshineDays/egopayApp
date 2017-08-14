//
//  WPProfitDetailCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPProfitDetailModel.h"

@interface WPProfitDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *withdrawMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *profitMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *merchantNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *profitDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, strong) WPProfitDetailModel *profitModel;


@end
