//
//  WPUserTransferController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/29.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserTransferController.h"
#import "Header.h"
#import "WPCardTableViewCell.h"
#import "WPUserWithDrawView.h"
#import "WPCardTableViewCell.h"
#import "WPPayTypeController.h"
#import "WPPayPopupController.h"
#import "WPSuccessOrfailedController.h"
#import "WPGatheringCodeController.h"
#import "WPBankCardModel.h"

@interface WPUserTransferController () <UITextFieldDelegate>

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) WPCardTableViewCell *phoneCell;

@property (nonatomic, strong) WPUserWithDrawView *transferView;

@property (nonatomic, strong) WPCardTableViewCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) WPBankCardModel *model;

@end

@implementation WPUserTransferController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"转账";
    [self confirmButton];
}

#pragma mark - Init

- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPNavigationHeight + 20, kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择银行卡" rectMake:rect];
        [_cardCell.backgroundButton addTarget:self action:@selector(wayButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cardCell];
    }
    return _cardCell;
}

- (WPCardTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.cardCell.frame) + 20, kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"账号" placeholder:@"请输入对方手机号码/账号" rectMake:rect];
        [_phoneCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneCell.textField becomeFirstResponder];
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPUserWithDrawView *)transferView
{
    if (!_transferView) {
        _transferView = [[WPUserWithDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame) + 20, kScreenWidth, 160.5)];
        _transferView.titleLabel.text = @"转账金额";
        _transferView.balanceLabel.text = @"请仔细核对账号";
        _transferView.moneyTextField.delegate = self;
        _transferView.allButton.hidden = YES;
        [_transferView.moneyTextField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_transferView];
    }
    return _transferView;
}

- (WPCardTableViewCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.transferView.frame) + 20, kScreenWidth, WPRowHeight);
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
        [_confirmButton setTitle:@"确认转账" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"转账金额:%@元", self.transferView.moneyTextField.text];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        [weakSelf pushTransferAccountsDataWithPassword:payPassword];
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

- (void)changeButtonSurface
{
    if (self.cvvCell.hidden) {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.phoneCell.textField.text.length == 11 && [self.transferView.moneyTextField.text floatValue] > 0) ? YES : NO];
    }
    else {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.phoneCell.textField.text.length == 11 && [self.transferView.moneyTextField.text floatValue] > 0 && self.cvvCell.textField.text.length == 3) ? YES : NO];
    }
}

- (void)confirmButtonAction
{
    if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if ([self.transferView.moneyTextField.text floatValue] == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入转账金额"];
    }
    else if ([self.cardCell.backgroundButton.titleLabel.text isEqualToString:@"请选择支付方式"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else{
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"4"]) {
            if ([WPAppTool isPayTouchID]) {
                [WPHelpTool payWithTouchIDsuccess:^(id success) {
                    [self pushTransferAccountsDataWithPassword:success];
                    
                } failure:^(NSError *error) {
                    [self initPayPopupView];
                }];
            }
            else {
                [self initPayPopupView];
            }
        }
        else {
            [self pushTransferAccountsDataWithPassword:@""];
        }
    }
}

- (void)wayButtonAction
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.isBalance = YES;
    vc.amount = [self.transferView.moneyTextField.text floatValue];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    //微信/支付宝/余额支付
    vc.userPayTypeBlock = ^(NSInteger payTypeRow) {
        weakSelf.cardCell.contentLabel.text = [WPUserTool payTypeTitleWith:payTypeRow];
        weakSelf.cardCell.cardImageView.image = [WPUserTool payTypeImageWith:payTypeRow];
        weakSelf.payType = [WPUserTool payTypeNumberWith:payTypeRow];
        weakSelf.cvvCell.hidden = YES;
    };
    //银行卡支付
    vc.userCardBlock = ^(WPBankCardModel *model) {
        weakSelf.model = model;
        weakSelf.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        
        [weakSelf.cardCell.contentLabel setAttributedText:[WPPublicTool stringColorWithString:[WPPublicTool stringWithCardName:model.bankName cardNumber:model.cardNumber] replaceColor:[UIColor placeholderColor] index:model.bankName.length]];
        
        weakSelf.cardCell.cardImageView.image = [WPUserTool payBankImageCode:model.bankCode];
        weakSelf.payType = @"1";
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Data

- (void)pushTransferAccountsDataWithPassword:(NSString *)passwordString
{
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"transferAmount" : self.transferView.moneyTextField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.model.id] ? [NSString stringWithFormat:@"%ld", self.model.id] : @"",
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPTransferAccountsURL parameters:parameters success:^(id success) {
        
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"转账结果";
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
