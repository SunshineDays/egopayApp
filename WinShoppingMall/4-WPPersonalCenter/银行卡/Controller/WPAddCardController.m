//
// WPAddCardController.m
// WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAddCardController.h"
#import "WPSelectButton.h"
#import "Header.h"
#import "WPConfirmVerificationController.h"
#import "WPSelectListController.h"
#import "WPMoreBankController.h"
#import "WPDatePickerView.h"


@interface WPAddCardController () <UIPopoverPresentationControllerDelegate, UITextFieldDelegate, WPDatePickerViewDelegate>

@property (nonatomic, strong) WPRowTableViewCell *bankCell;

@property (nonatomic, strong) WPRowTableViewCell *branchCell;

@property (nonatomic, strong) WPRowTableViewCell *numberCell;

@property (nonatomic, strong) WPRowTableViewCell *dateCell;

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dateCell];
    [self confirmButton];
    
}

#pragma mark - Init

- (WPRowTableViewCell *)bankCell
{
    if (!_bankCell) {
        _bankCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_bankCell tableViewCellTitle:@"开户银行" buttonTitle:@"请选择开户银行" rectMake:rect];
        [_bankCell.button addTarget:self action:@selector(bankCellClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bankCell];
    }
    return _bankCell;
}

- (WPRowTableViewCell *)branchCell
{
    if (!_branchCell) {
        _branchCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.bankCell.frame), kScreenWidth, WPRowHeight);
        [_branchCell tableViewCellTitle:@"支行名称" placeholder:@"请输入支行名称" rectMake:rect];
        _branchCell.textField.delegate = self;
        [_branchCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_branchCell];
    }
    return _branchCell;
}

- (WPRowTableViewCell *)numberCell
{
    if (!_numberCell) {
        _numberCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.branchCell.frame), kScreenWidth, WPRowHeight);
        [_numberCell tableViewCellTitle:@"银行卡号" placeholder:@"请输入银行卡号" rectMake:rect];
        _numberCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _numberCell.textField.delegate = self;
        [_numberCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_numberCell];
    }
    return _numberCell;
}

- (WPRowTableViewCell *)dateCell
{
    if (!_dateCell) {
        _dateCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.numberCell.frame), kScreenWidth, WPRowHeight);
        [_dateCell tableViewCellTitle:@"有效期" buttonTitle:@"请选择有效期限" rectMake:rect];
        [_dateCell.button addTarget:self action:@selector(dateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _dateCell.hidden = [self.cardType isEqualToString:@"1"] ? NO : YES;
        [self.view addSubview:_dateCell];
    }
    return _dateCell;
}

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        float height = [self.cardType isEqualToString:@"1"] ? WPTopMargin + WPRowHeight * 4 : WPTopMargin + WPRowHeight * 3;
        CGRect rect = CGRectMake(0, height, kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"手机号码" placeholder:@"请输入银行预留手机号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneCell.textField.delegate = self;
        [_phoneCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.phoneCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(saveButttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - WPPickerViewDelegate

- (void)wp_selectedResultWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    [self.dateCell.button setTitle:[NSString stringWithFormat:@"%@ - %@", year, month] forState:UIControlStateNormal];
    [self.dateCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.branchCell.textField.text.length > 2 && self.numberCell.textField.text.length > 10 && self.phoneCell.textField.text.length == 11) ? YES : NO];
}

- (void)bankCellClick:(UIButton *)button
{
    WPSelectListController *vc = [[WPSelectListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.type = 3;
    __weakSelf
    vc.selecteNameBlock = ^(NSString *nameStr) {
        if ([nameStr isEqualToString:@"其他银行"]) {
            WPMoreBankController *vc = [[WPMoreBankController alloc] init];
            vc.navigationItem.title = @"开户银行";
            vc.inforBlock = ^(NSString *inforBlock) {
                if (inforBlock.length > 0) {
                    [weakSelf.bankCell.button setTitle:inforBlock forState:UIControlStateNormal];
                    [weakSelf.bankCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [weakSelf.bankCell.button setTitle:nameStr forState:UIControlStateNormal];
            [weakSelf.bankCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


- (void)dateButtonClick:(UIButton *)button
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    WPDatePickerView *pickerView = [[WPDatePickerView alloc] initPickerView];
    pickerView.pickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)saveButttonClick
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if ([self.bankCell.button.titleLabel.text isEqualToString:@"请选择开户银行"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择开户银行"];
    }
    else if (self.branchCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入支行名称"];
    }
    else if (self.numberCell.textField.text.length < 10 || self.numberCell.textField.text.length > 20) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的银行卡号"];
    }
    else if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
    }
    else if ([self.cardType isEqualToString:@"1"] && [self.dateCell.button.titleLabel.text isEqualToString:@"请选择有效期限"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择有效期限"];
    }
    else {
        [self getVerificationData];
    }
}

#pragma mark - Data

- (void)getVerificationData
{
    
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"verType" : @"3"
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPGetMessageURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [weakSelf tradsmitData];
        }
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma 传递到下个界面的字典
- (void)tradsmitData
{
    // 2:储蓄卡,1:信用卡
    NSDictionary *parameters = @{
                                 @"cardNumber" : [WPPublicTool base64EncodeString:self.numberCell.textField.text],
                                 @"cardType" : self.cardType,
                                 @"expDate" : [self.cardType isEqualToString:@"1"] ? [WPPublicTool base64EncodeString:self.dateCell.button.titleLabel.text] : @"",
                                 @"bankZone" : self.branchCell.textField.text,
                                 @"bankName" : self.bankCell.button.titleLabel.text,
                                 @"phone" : self.phoneCell.textField.text
                                 };
    WPConfirmVerificationController *vc = [[WPConfirmVerificationController alloc] init];
    [vc.cardInfoDict addEntriesFromDictionary:parameters];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
