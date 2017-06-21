//
//  WPRechargeCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPBankCardModel.h"
#import "WPInvitingPeopleModel.h"

@interface WPRechargeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (nonatomic, strong) WPBankCardModel *model;

@end
