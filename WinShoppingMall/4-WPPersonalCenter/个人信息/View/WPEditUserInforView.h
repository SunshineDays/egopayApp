//
//  WPEditUserInforView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "WPEditUserInfoModel.h"

@interface WPEditUserInforView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) WPRowTableViewCell *shopNumberCell;

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *sexCell;

@property (nonatomic, strong) WPRowTableViewCell *addressCell;

@property (nonatomic, strong) WPRowTableViewCell *addressDetailCell;

@property (nonatomic, strong) WPRowTableViewCell *emailCell;

- (instancetype)initWithModel:(WPEditUserInfoModel *)model;

@end
