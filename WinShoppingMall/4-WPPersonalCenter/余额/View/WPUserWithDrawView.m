//
//  WPUserWithDrawView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserWithDrawView.h"
#import "WPAppConst.h"
#import "UIColor+WPColor.h"

@interface WPUserWithDrawView ()

@end

@implementation WPUserWithDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self initWithDrawView];
    }
    return self;
}

- (void)initWithDrawView
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, 150, 40)];
//    _titleLabel.text = @"提现金额";
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
    
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(_titleLabel.frame), 30, 80)];
    symbolLabel.text = @"￥";
    symbolLabel.textColor = [UIColor blackColor];
    symbolLabel.font = [UIFont systemFontOfSize:30];
    [self addSubview:symbolLabel];
    
    _moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(symbolLabel.frame), CGRectGetMaxY(_titleLabel.frame), self.frame.size.width / 2, 80)];
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTextField.font = [UIFont systemFontOfSize:30];
    [self addSubview:_moneyTextField];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(_moneyTextField.frame), self.frame.size.width - 2 * WPLeftMargin, WPLineHeight)];
    lineLabel.backgroundColor = [UIColor lineColor];
    [self addSubview:lineLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(lineLabel.frame), self.frame.size.width - 2 * WPLeftMargin - 100, 40)];
    _balanceLabel.text = @"123.11";
    _balanceLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_balanceLabel];
    
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - WPLeftMargin - 100, CGRectGetMaxY(lineLabel.frame), 100, 40)];
    [_allButton setTitle:@"全部提现" forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _allButton.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
    _allButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:_allButton];
}



@end
