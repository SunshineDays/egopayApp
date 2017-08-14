//
//  WPUserRechargeView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserRechargeView.h"

@interface WPUserRechargeView () <UITextFieldDelegate>

@property (nonatomic, strong) WPUserRateModel *model;


@end

@implementation WPUserRechargeView


- (instancetype)initWithModel:(WPUserRateModel *)model
{
    if (self = [super init]) {
        [self setFrame:[UIScreen mainScreen].bounds];
        self.model = model;
        [self confirmButton];
    }
    return self;
}

- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopY + 20, kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择充值方式" rectMake:rect];
        [self addSubview:_cardCell];
    }
    return _cardCell;
}

- (UILabel *)poundageLabel
{
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cardCell.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _poundageLabel.text = [NSString stringWithFormat:@"当前手续费率：%.2f%@", self.model.rate * 100, @"%"];
        _poundageLabel.textColor = [UIColor darkGrayColor];
        _poundageLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_poundageLabel];
    }
    return _poundageLabel;
}

- (WPCardTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.poundageLabel.frame), kScreenWidth, WPRowHeight);
        [_moneyCell rowCellTitle:@"金额" placeholder:@"请输入充值金额" rectMake:rect];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [self addSubview:_moneyCell];
    }
    return _moneyCell;
}


- (WPCardTableViewCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame) + 20, kScreenWidth, WPRowHeight);
        [_cvvCell rowCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.hidden = YES;
        _cvvCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _cvvCell.textField.delegate = self;
        [self addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认充值" forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor buttonBackgroundDefaultColor]];
        [self addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validatePrice:textField.text range:range replacementString:string];
}



@end
