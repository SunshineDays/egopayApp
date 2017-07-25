//
//  WPUserInforView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPUserInforButton : UIButton

@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) UILabel *vipLabel;


- (void)userInforWithName:(NSString *)name vip:(NSString *)vip rate:(NSString *)rate arrowHidden:(BOOL)arrowHidden;

@end
