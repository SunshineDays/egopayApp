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

/**
 *  用户重新登录
 */
- (void)userRegisterAgain;

/**
 *  选择照片
 */
- (void)alertControllerWithPhoto:(BOOL)isPhoto;

@end
