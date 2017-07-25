//
//  WPHomePageView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPHomePageView.h"

@interface WPHomePageView () <SDCycleScrollViewDelegate>

@end

@implementation WPHomePageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creditButton];
        [self initButtonClassView];
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2)];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@""];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.delegate = self;
        
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (UIView *)classView
{
    if (!_classView) {
        _classView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), kScreenWidth, 180)];
        _classView.userInteractionEnabled = YES;
        [self addSubview:_classView];
    }
    return _classView;
}

- (void)initButtonClassView
{
    NSArray *array = @[@"充值", @"提现", @"账单", @"扫码", @"商家", @"收款", @"转账", @"推荐"];
    NSArray *imageArray = @[ @"icon_chongzhi_content_n", @"icon_tixian_content_n", @"icon_zhangdan_content_n", @"icon_saoma_content_n", @"icon_shangjiai_content_n", @"icon_shoukuan_content_n", @"icon_zhuanzhangi_content_n", @"icon_tuijian_content_n"];
    CGFloat width = (kScreenWidth - 2 * WPLeftMargin) / 4;
    for (NSInteger i = 0; i < array.count; i++)
    {
        WPHomePageClassButton *button = [WPHomePageClassButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WPLeftMargin + width * (i % 4), 0 + 90 * (i / 4), width, 90);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        button.tag = i;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [self.classView addSubview:button];
    }
}

- (WPHomePageCreditButton *)creditButton
{
    if (!_creditButton) {
        _creditButton = [WPHomePageCreditButton buttonWithType:UIButtonTypeCustom];
        [_creditButton setFrame:CGRectMake(0, CGRectGetMaxY(self.classView.frame) + 20, kScreenWidth, 80)];
        [_creditButton setBackgroundColor:[UIColor themeColor]];
        [_creditButton setTitle:@"Credit Card Payment\n\n国际信用卡" forState:UIControlStateNormal];
        _creditButton.titleLabel.numberOfLines = 0;
        _creditButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _creditButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_creditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_creditButton setImage:[UIImage imageNamed:@"icon_visajcb_content_n"] forState:UIControlStateNormal];
        
        [self addSubview:_creditButton];
    }
    return _creditButton;
}


@end
