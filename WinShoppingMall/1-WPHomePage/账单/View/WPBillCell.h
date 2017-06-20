//
//  WPBillCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPBillModel.h"

@interface WPBillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *wayImageView;

@property (weak, nonatomic) IBOutlet UILabel *wayLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *poundageLabel;

@property (nonatomic, strong) WPBillModel *model;


@end
