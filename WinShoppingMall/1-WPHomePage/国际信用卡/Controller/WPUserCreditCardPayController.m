//
//  WPUserCreditCardPayController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/29.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserCreditCardPayController.h"
#import "Header.h"
#import "WPCardTableViewCell.h"
#import "WPBankCardController.h"
#import "WPBankCardModel.h"
#import "WPSuccessOrfailedController.h"

@interface WPUserCreditCardPayController () <UITextFieldDelegate>

@property (nonatomic, strong) WPRowTableViewCell *typeCell;

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) UILabel *poundageLabel;

@property (nonatomic, strong) WPCardTableViewCell *moneyCell;

@property (nonatomic, strong) WPCardTableViewCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, strong) WPBankCardModel *model;

//  手续费率
@property (nonatomic, assign) float rate;

@end

@implementation WPUserCreditCardPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"国际信用卡充值";
    self.view.backgroundColor = [UIColor cellColor];
    
    [self getPoundageData];
}

- (WPRowTableViewCell *)typeCell {
    if (!_typeCell) {
        _typeCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPNavigationHeight, kScreenWidth, WPRowHeight);
        NSArray *imageArray = @[@"icon_jcb_content_n", @"icon_visa_content_n", @"icon_mc_content_n"];
        [_typeCell tableViewCellTitle:@"支持类型" imageArray:imageArray rectMake:rect];
        [self.view addSubview:_typeCell];
    }
    return _typeCell;
}

- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.typeCell.frame), kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择审核过的信用卡" rectMake:rect];
        [_cardCell.backgroundButton addTarget:self action:@selector(selectCardButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
        [_moneyCell tableViewCellTitle:@"金额" placeholder:@"请输入充值金额(元)" rectMake:rect];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPRegex validateMoneyNumber:textField.text range:range replacementString:string];
}

#pragma mark - Action

- (void)moneyCellTextField
{
    self.poundageLabel.text = [NSString stringWithFormat:@"手续费：%@", [WPPublicTool stringWithRateMoney:self.moneyCell.textField.text rate:self.rate]];
    [self changeButtonSurface];
}

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:([self.moneyCell.textField.text floatValue] > 0 && self.cvvCell.textField.text.length == 3) ? YES : NO];
}

- (void)selectCardButtonAction
{
    WPBankCardController *vc = [[WPBankCardController alloc] init];
    vc.showCardType = @"2";
    __weakSelf
    vc.cardInfoBlock = ^(WPBankCardModel *model) {
        weakSelf.model = model;
        [weakSelf.cardCell.contentLabel setAttributedText:[WPPublicTool stringColorWithString:[WPPublicTool stringWithCardName:model.bankName cardNumber:model.cardNumber] index:model.bankName.length]];
        weakSelf.cardCell.cardImageView.image = [WPUserTool payTypeImageCode:model.bankCode];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmButtonAction
{
    if ([self.moneyCell.textField.text floatValue] > 5000) {
        [WPProgressHUD showInfoWithStatus:@"充值金额最多为5000元"];
    }
    else if ([self.moneyCell.textField.text floatValue] == 0 || [self.moneyCell.textField.text isEqualToString:@""]) {
        [WPProgressHUD showInfoWithStatus:@"请输入充值金额"];
    }
    else if ([self.cardCell.contentLabel.text isEqualToString:@"请选择审核过的信用卡"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择审核过的信用卡"];
    }
    else if (self.cvvCell.textField.text.length != 3) {
        [WPProgressHUD showInfoWithStatus:@"请输入CVV码"];
    }
    else {
        [self pushChargeData];
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

- (void)pushChargeData
{
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.moneyCell.textField.text,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.model.id],
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPCreditChargeURL parameters:parameters success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"] || [type isEqualToString:@"3"] || [type isEqualToString:@"4"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"充值结果";
            if ([type isEqualToString:@"1"]) {
                vc.showType = 1;
            }
            else if ([type isEqualToString:@"4"]) {
                vc.showType = 2;
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
