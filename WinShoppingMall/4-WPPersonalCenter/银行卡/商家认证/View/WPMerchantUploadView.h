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

@property (nonatomic, strong) WPCustomRowCell *nameCell;

@property (nonatomic, strong) WPCustomRowCell *sexCell;

@property (nonatomic, strong) WPCustomRowCell *phoneCell;

@property (nonatomic, strong) WPCustomRowCell *shopNameCell;

@property (nonatomic, strong) WPCustomRowCell *shopAddressCell;

@property (nonatomic, strong) WPCustomRowCell *shopAddressDetailCell;

@property (nonatomic, strong) WPButton *nextButton;

@end
