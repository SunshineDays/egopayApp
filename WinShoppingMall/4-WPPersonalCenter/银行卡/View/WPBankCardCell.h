//
//  WPBankCardCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/18.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPBankCardModel.h"

@interface WPBankCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *extCardTypeLabel;

@property (nonatomic, strong) WPBankCardModel *model;

@end
