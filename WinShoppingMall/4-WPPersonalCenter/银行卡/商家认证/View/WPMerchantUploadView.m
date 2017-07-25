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
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPNavigationHeight, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = @"请填写您的真实信息";
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self addSubview:_stateLabel];
        
    }
    return _stateLabel;
}

- (WPRowTableViewCell *)nameCell
{
    if (!_nameCell) {
        _nameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame), kScreenWidth, WPRowHeight);
        [_nameCell tableViewCellTitle:@"联系人" placeholder:@"请输入您的姓名" rectMake:rect];
        _nameCell.textField.delegate = self;
        [self addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_sexCell tableViewCellTitle:@"性别" buttonTitle:@"男" rectMake:rect];
        [self addSubview:_sexCell];
    }
    return _sexCell;
}

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.sexCell.frame), kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"联系电话" placeholder:@"请输入电话号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)shopNameCell
{
    if (!_shopNameCell) {
        _shopNameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_shopNameCell tableViewCellTitle:@"店铺名称" placeholder:@"请输入店铺名称" rectMake:rect];
        _shopNameCell.textField.delegate = self;
        [self addSubview:_shopNameCell];
    }
    return _shopNameCell;
}

- (WPRowTableViewCell *)shopAddressCell
{
    if (!_shopAddressCell) {
        _shopAddressCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopNameCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressCell tableViewCellTitle:@"店铺地址" buttonTitle:@"请选择店铺地址" rectMake:rect];
        [self addSubview:_shopAddressCell];
    }
    return _shopAddressCell;
}

- (WPRowTableViewCell *)shopAddressDetailCell
{
    if (!_shopAddressDetailCell) {
        _shopAddressDetailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopAddressCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressDetailCell tableViewCellTitle:@"详细地址" placeholder:@"请输入店铺详细地址" rectMake:rect];
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
