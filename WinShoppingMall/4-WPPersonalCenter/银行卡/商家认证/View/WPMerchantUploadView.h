//
//  WPMerchantUploadView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface WPMerchantUploadView : UIView

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *sexCell;

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *shopNameCell;

@property (nonatomic, strong) WPRowTableViewCell *shopAddressCell;

@property (nonatomic, strong) WPRowTableViewCell *shopAddressDetailCell;

@property (nonatomic, strong) WPButton *nextButton;

@end
