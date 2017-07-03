//
//  WPBaseViewController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPNoResultLabel.h"

@interface WPBaseViewController : UIViewController

@property (nonatomic, strong) WPNoResultLabel *noResultLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property ( nonatomic, strong) UIAlertController *alertCtr;

@property (nonatomic, strong) UIAlertController *alertSheet;

@property (nonatomic, strong) UIAlertController *alertCameraSheet;

- (void)userRegisterAgain;

@end
