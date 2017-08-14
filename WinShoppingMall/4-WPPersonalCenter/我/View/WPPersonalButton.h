//
//  WPPersonalButton.h.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPersonalButton : UIButton

@property (nonatomic, strong) UIImageView *avaterImageView;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *vipLabel;


- (instancetype)initWithFrame:(CGRect)frame avaterUrl:(NSString *)url phone:(NSString *)phone vip:(NSString *)vip;

@end
