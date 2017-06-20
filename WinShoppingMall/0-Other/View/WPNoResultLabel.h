//
//  WPNoResultLabel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPNoResultLabel : UILabel

- (void)showOnSuperView:(UIView *)view;

- (void)showOnSuperView:(UIView *)view title:(NSString *)title;

- (void)showWithTitle:(NSString *)title;

- (void)show;

- (void)hidden;


@end
