//
//  WPTransferAccountsController.m
//  WinShoppingMall
//  转账
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPTransferAccountsController.h"

#import "Header.h"
#import "WPPayTypeController.h"
#import "WPAddCardController.h"
#import "WPPayPopupController.h"
#import "WPSuccessOrfailedController.h"
#import "WPGatheringCodeController.h"
#import "WPUserEnrollController.h"

@interface WPTransferAccountsController ()<UIPopoverPresentationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *moneyCell;

@property (nonatomic, strong) WPRowTableViewCell *wayCell;

@property (nonatomic, strong) WPRowTableViewCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;


// 支付方式
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *cardId;

@end

@implementation WPTransferAccountsController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"转账";
    self.cardId = @"";
    
    [self phoneCell];
    [self moneyCell];
    [self wayCell];
    [self cvvCell];
    [self confirmButton];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCardSuccess:) name:WPNotificationAddCardSuccess object:nil];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - Init

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"手机号码" placeholder:@"请输入对方的手机号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"金        额" placeholder:@"请输入转账金额" rectMake:rect];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}

- (WPRowTableViewCell *)wayCell
{
    if (!_wayCell) {
        _wayCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame), kScreenWidth, WPRowHeight);
        [_wayCell tableViewCellTitle:@"支付方式" buttonTitle:@"请选择支付方式" rectMake:rect];
        [_wayCell.button addTarget:self action:@selector(wayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _wayCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_wayCell];
    }
    return _wayCell;
}

- (WPRowTableViewCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.wayCell.frame), kScreenWidth, WPRowHeight);
        [_cvvCell tableViewCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.hidden = YES;
        [self.view addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 10, kScreenWidth - 2 * WPLeftMargin , WPButtonHeight)];
        [_confirmButton setTitle:@"确认转账" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"转账金额:%@元", self.moneyCell.textField.text];
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

- (void)wayButtonAction:(UIButton *)button
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.isUseMoney = YES;
    vc.amount = [self.moneyCell.textField.text floatValue];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    //微信/支付宝/余额支付
    vc.userPayTypeBlock = ^(NSString *payType) {
        [weakSelf registInformationTitle:payType cvvHidden:YES];
        if ([payType isEqualToString:@"微信支付"]) {
            weakSelf.payType = @"2";
        }
        else if ([payType isEqualToString:@"支付宝支付"]) {
            weakSelf.payType = @"3";
        }
        else if ([payType isEqualToString:@"QQ钱包支付"]) {
            weakSelf.payType = @"6";
        }
        //  余额支付
        else {
            weakSelf.payType = @"4";
        }
    };
    //银行卡支付
    vc.userCardBlock = ^(WPBankCardModel *model) {
        NSString *cardNumber = [WPPublicTool base64DecodeString:model.cardNumber];
        cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
        [weakSelf registInformationTitle:[NSString stringWithFormat:@"%@(尾号%@)",model.bankName, cardNumber] cvvHidden:[[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES];

        weakSelf.payType = @"1";
        weakSelf.cardId = [NSString stringWithFormat:@"%ld", (long)model.id];
    };
    //添加银行卡
//    vc.userAddCardBlock = ^{
//        //  判断是否通过实名认证
//        if ([[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
//            //  有密码
//            if ([[WPUserInfor sharedWPUserInfor].payPasswordType isEqualToString:@"YES"]) {
//                WPAddCardController *vc = [[WPAddCardController alloc] init];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//                [WPUserInfor sharedWPUserInfor].popType = @"3";
//            }
//            //  没有密码
//            else {
//                WPPasswordController *vc = [[WPPasswordController alloc] init];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }
//        }
//        else {
//            [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
//        }
//    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)confirmButtonAction:(UIButton *)button
{
    
    if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if ([self.moneyCell.textField.text floatValue] == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入转账金额"];
    }
    else if ([self.wayCell.button.titleLabel.text isEqualToString:@"请选择支付方式"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else{
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"4"]) {
            if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"3"]) {
                [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
                    [self pushTransferAccountsDataWithPassword:touchIDSuccess];
                    
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

//- (void)addCardSuccess:(NSNotification *)notification {
//    NSString *cardNumber = [WPPublicTool base64DecodeString:notification.userInfo[@"cardNumber"]];
//    cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
//    [self.wayCell.button setTitle:[NSString stringWithFormat:@"%@(尾号%@)", notification.userInfo[@"bankName"], cardNumber] forState:UIControlStateNormal];
//    [self judgeCardType:notification.userInfo[@"cardType"]];
//    self.payType = @"1";
//    self.cardId = notification.userInfo[@"cardId"];
//}


#pragma mark - Methods

- (void)registInformationTitle:(NSString *)title cvvHidden:(BOOL)cvvHidden
{
    [self.wayCell.button setTitle:title forState:UIControlStateNormal];
    [self.wayCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cvvCell.hidden = cvvHidden;
}

#pragma mark - Data

- (void)pushTransferAccountsDataWithPassword:(NSString *)passwordString
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"transferAmount" : self.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" : self.cardId,
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPTransferAccountsURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];

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
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
