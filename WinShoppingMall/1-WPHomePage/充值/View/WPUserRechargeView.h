//
//  WPUserRechargeView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "WPCardTableViewCell.h"
#import "WPUserRateModel.h"

@interface WPUserRechargeView : UIView

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) UILabel *poundageLabel;

@property (nonatomic, strong) WPCardTableViewCell *moneyCell;

//@property (nonatomic, strong) WPCardTableViewCell *cvvCell;

@property (nonatomic, strong) WPCardTableViewCell *depositCardCell;

@property (nonatomic, strong) WPButton *confirmButton;

- (instancetype)initWithModel:(WPUserRateModel *)model;

@end
