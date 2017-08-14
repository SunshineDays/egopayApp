//
//  WPMerchantUploadView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantUploadView.h"

@interface WPMerchantUploadView () <UITextFieldDelegate>

@end

@implementation WPMerchantUploadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self nextButton];
    }
    return self;
}

-(UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopY, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = @"请填写您的真实信息";
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self addSubview:_stateLabel];
        
    }
    return _stateLabel;
}

- (WPCustomRowCell *)nameCell
{
    if (!_nameCell) {
        _nameCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame), kScreenWidth, WPRowHeight);
        [_nameCell rowCellTitle:@"联系人" placeholder:@"请输入您的姓名" rectMake:rect];
        _nameCell.textField.delegate = self;
        [_nameCell.textField becomeFirstResponder];
        [self addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPCustomRowCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_sexCell rowCellTitle:@"性别" buttonTitle:@"男" rectMake:rect];
        [self addSubview:_sexCell];
    }
    return _sexCell;
}

- (WPCustomRowCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.sexCell.frame), kScreenWidth, WPRowHeight);
        [_phoneCell rowCellTitle:@"联系电话" placeholder:@"请输入电话号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPCustomRowCell *)shopNameCell
{
    if (!_shopNameCell) {
        _shopNameCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_shopNameCell rowCellTitle:@"店铺名称" placeholder:@"请输入店铺名称" rectMake:rect];
        _shopNameCell.textField.delegate = self;
        [self addSubview:_shopNameCell];
    }
    return _shopNameCell;
}

- (WPCustomRowCell *)shopAddressCell
{
    if (!_shopAddressCell) {
        _shopAddressCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopNameCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressCell rowCellTitle:@"店铺地址" buttonTitle:@"请选择店铺地址" rectMake:rect];
        [self addSubview:_shopAddressCell];
    }
    return _shopAddressCell;
}

- (WPCustomRowCell *)shopAddressDetailCell
{
    if (!_shopAddressDetailCell) {
        _shopAddressDetailCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopAddressCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressDetailCell rowCellTitle:@"详细地址" placeholder:@"请输入店铺详细地址" rectMake:rect];
        [self addSubview:_shopAddressDetailCell];
    }
    return _shopAddressDetailCell;
}

- (WPButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.shopAddressDetailCell.frame) + 30, kScreenWidth - WPLeftMargin * 2, WPButtonHeight)];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self addSubview:_nextButton];
    }
    return _nextButton;
}


@end
