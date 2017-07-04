//
//  WPUserRechargeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserRechargeController.h"
#import "WPCardTableViewCell.h"
#import "Header.h"
#import "WPPayTypeController.h"
#import "WPPayPopupController.h"
#import "WPSuccessOrfailedController.h"
#import "WPGatheringCodeController.h"
#import "WPRechargeStateController.h"

@interface WPUserRechargeController () <UITextFieldDelegate>

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) UILabel *poundageLabel;

@property (nonatomic, strong) WPCardTableViewCell *moneyCell;

@property (nonatomic, strong) WPCardTableViewCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;

//  手续费率
@property (nonatomic, assign) float rate;

//  支付方式
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) WPBankCardModel *model;

@end

@implementation WPUserRechargeController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"充值";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"限额说明" style:UIBarButtonItemStylePlain target:self action:@selector(rechargeStateAction)];
    
    [self getPoundageData];
}

#pragma mark - Init

- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPNavigationHeight + 20, kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择充值方式" rectMake:rect];
        [_cardCell.backgroundButton addTarget:self action:@selector(selectWayAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cardCell];
    }
    return _cardCell;
}

- (UILabel *)poundageLabel
{
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cardCell.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _poundageLabel.text = [NSString stringWithFormat:@"当前手续费率：%.2f%@", self.rate * 100, @"%"];
        _poundageLabel.textColor = [UIColor darkGrayColor];
        _poundageLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_poundageLabel];
    }
    return _poundageLabel;
}

- (WPCardTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.poundageLabel.frame), kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"金额" placeholder:@"请输入充值金额" rectMake:rect];
        [_moneyCell.textField addTarget:self action:@selector(moneyCellTextField) forControlEvents:UIControlEventEditingChanged];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [_moneyCell.textField becomeFirstResponder];
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}


- (WPCardTableViewCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame) + 20, kScreenWidth, WPRowHeight);
        [_cvvCell tableViewCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.hidden = YES;
        _cvvCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_cvvCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认充值" forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor buttonBackgroundDefaultColor]];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"充值金额:%@元", self.moneyCell.textField.text];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        [weakSelf pushWithChargeDataWithPassword:payPassword];
    };
    vc.forgetPasswordBlock = ^{
        WPPasswordController *vc = [[WPPasswordController alloc] init];
        vc.passwordType = @"2";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPRegex validateMoneyNumber:textField.text range:range replacementString:string];
}


#pragma mark - Action

- (void)rechargeStateAction
{
    WPRechargeStateController *vc = [[WPRechargeStateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moneyCellTextField
{
    self.poundageLabel.text = [NSString stringWithFormat:@"手续费：%@", [WPPublicTool stringWithRateMoney:self.moneyCell.textField.text rate:self.rate]];
    [self changeButtonSurface];
}

- (void)changeButtonSurface
{
    if (self.cvvCell.hidden) {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:[self.moneyCell.textField.text floatValue] > 0 ? YES : NO];
    }
    else {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:([self.moneyCell.textField.text floatValue] > 0 && self.cvvCell.textField.text.length == 3) ? YES : NO];
    }
}

- (void)selectWayAction
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    vc.userPayTypeBlock = ^(NSInteger payTypeRow) {
        weakSelf.cvvCell.hidden = YES;
        weakSelf.cardCell.contentLabel.text = [WPPublicTool payTypeTitleWith:payTypeRow];
        weakSelf.cardCell.cardImageView.image = [WPPublicTool payTypeImageWith:payTypeRow];
        weakSelf.payType = [WPPublicTool payTypeNumberWith:payTypeRow];
    };
    //银行卡支付
    vc.userCardBlock = ^(WPBankCardModel *model) {
        weakSelf.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        [weakSelf.cardCell.contentLabel setAttributedText:[WPPublicTool stringColorWithString:[WPPublicTool stringWithCardName:model.bankName cardNumber:model.cardNumber] index:model.bankName.length]];
        weakSelf.cardCell.cardImageView.image = [WPPublicTool imageWithImageCode:model.bankCode];

        weakSelf.payType = @"1";
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)confirmButtonAction
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.moneyCell.textField.text floatValue] == 0 || self.moneyCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入充值金额"];
    }
    else if ([self.cardCell.contentLabel.text isEqualToString:@"请选择充值方式"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else if (self.cvvCell.hidden == NO && self.cvvCell.textField.text.length != 3) {
        [WPProgressHUD showInfoWithStatus:@"请输入CVV码"];
    }
    else if ([self.moneyCell.textField.text floatValue] > 500 && [self.payType isEqualToString:@"2"] && ![[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
        [WPProgressHUD showInfoWithStatus:@"微信每次最多充值500元"];
    }
    else if ([self.moneyCell.textField.text floatValue] > 1000 && [self.payType isEqualToString:@"3"] && ![[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
        [WPProgressHUD showInfoWithStatus:@"支付宝每次最多充值1000元"];
    }
    else {
        if ([self.payType isEqualToString:@"1"]) {
            if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"3"]) {
                [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
                    [self pushWithChargeDataWithPassword:touchIDSuccess];
                } failure:^(NSError *error) {
                    [self initPayPopupView];
                }];
            }
            else {
                [self initPayPopupView];
            }
        }
        else {
            [self pushWithChargeDataWithPassword:@""];
        }
    }
}

#pragma mark - Data

- (void)getPoundageData
{
    NSDictionary *parameter = @{
                                @"rateType" : @"1"
                                };
    __weakSelf
    [WPHelpTool getWithURL:WPPoundageURL parameters:parameter success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.rate = [result[@"rate"] floatValue];
            [weakSelf confirmButton];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushWithChargeDataWithPassword:(NSString *)payPassword
{
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.model.id] ? [NSString stringWithFormat:@"%ld", (long)self.model.id] : @"",
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPRechargeURL parameters:parameters success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"充值结果";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([type isEqualToString:@"3"]) {
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeType = 1;
            vc.codeString = result[@"CodeUrl"];
            if ([result[@"method"] isEqualToString:@"2"]) {
                vc.payType = 1;
            }
            else if ([result[@"method"] isEqualToString:@"3"]) {
                vc.payType = 2;
            }
            else if (([result[@"method"] isEqualToString:@"6"])) {
                vc.payType = 3;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
