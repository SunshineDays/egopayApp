//
//  WPMerchantCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/26.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMerchantModel.h"

@interface WPMerchantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopDescpLabel;

@property (nonatomic, strong) WPMerchantModel *model;

@end
