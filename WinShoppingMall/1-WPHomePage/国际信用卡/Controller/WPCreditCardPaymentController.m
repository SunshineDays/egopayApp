//
//  WPCreditCardPaymentController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPCreditCardPaymentController.h"
 #import "UIView+WPExtension.h"
#import "WPSuccessOrfailedController.h"
#import "WPBankCardController.h"
#import "Header.h"

@interface WPCreditCardPaymentController () <UITextFieldDelegate>

@property (nonatomic, strong) WPRowTableViewCell *typeCell;

@property (nonatomic, strong) WPRowTableViewCell *moneyCell;

@property (nonatomic, strong) WPRowTableViewCell *cardCell;

@property (nonatomic, strong) WPRowTableViewCell *cvvCell;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) WPButton *confirmButton;

//  银行数组
@property (nonatomic, strong) NSArray *cardArray;

@property (nonatomic, strong) WPBankCardModel *model;

@end

@implementation WPCreditCardPaymentController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"国际信用卡充值";

    [self typeCell];
    [self moneyCell];
    [self cardCell];
    [self cvvCell];
    [self tipLabel];
    [self confirmButton];
}

#pragma mark - Init

- (WPRowTableViewCell *)moneyCell {
    if (!_moneyCell) {
        _moneyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"充值金额" placeholder:@"请输入充值金额(人民币)" rectMake:rect];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}

- (WPRowTableViewCell *)typeCell {
    if (!_typeCell) {
        _typeCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame), kScreenWidth, WPRowHeight);
        NSArray *imageArray = @[@"icon_jcb_content_n", @"icon_visa_content_n", @"icon_mc_content_n"];
        [_typeCell tableViewCellTitle:@"支持类型" imageArray:imageArray rectMake:rect];
        [self.view addSubview:_typeCell];
    }
    return _typeCell;
}

- (WPRowTableViewCell *)cardCell {
    if (!_cardCell) {
        _cardCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.typeCell.frame), kScreenWidth, WPRowHeight);
        [_cardCell tableViewCellTitle:@"信用卡" buttonTitle:@"请选择审核过的信用卡" rectMake:rect];
        [_cardCell.button addTarget:self action:@selector(selectCardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cardCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_cardCell];
    }
    return _cardCell;
}

- (WPRowTableViewCell *)cvvCell {
    if (!_cvvCell) {
        _cvvCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.cardCell.frame), kScreenWidth, WPRowHeight);
        [_cvvCell tableViewCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _tipLabel.text = @"注意：当前充值货币单位为人民币";
        _tipLabel.textColor = [UIColor themeColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (WPButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.tipLabel.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认充值" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)selectCardButtonClick:(UIButton *)button
{
    WPBankCardController *vc = [[WPBankCardController alloc] init];
    vc.showCardType = @"2";
    vc.cardInfoBlock = ^(WPBankCardModel *model) {
        self.model = model;
        
        NSString *cardNumber = [WPPublicTool base64DecodeString:model.cardNumber];
        cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
        [self.cardCell.button setTitle:[NSString stringWithFormat:@"%@(尾号%@)",model.bankName, cardNumber] forState:UIControlStateNormal];
        [self.cardCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmButtonClick:(UIButton *)button
{
    
    if ([self.moneyCell.textField.text floatValue] > 5000) {
        [WPProgressHUD showInfoWithStatus:@"充值金额最多为5000"];
    }
    else if ([self.moneyCell.textField.text floatValue] == 0 || [self.moneyCell.textField.text isEqualToString:@""]) {
        [WPProgressHUD showInfoWithStatus:@"请输入充值金额"];
    }
    else if ([self.cardCell.button.titleLabel.text isEqualToString:@"请选择审核过的信用卡"]) {
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

- (void)pushChargeData
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.moneyCell.textField.text,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", self.model.id],
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text]
                                 };
    
    __weakSelf
    [WPHelpTool postWithURL:WPCreditChargeURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
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
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
