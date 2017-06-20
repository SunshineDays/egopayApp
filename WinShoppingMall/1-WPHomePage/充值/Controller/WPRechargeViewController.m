//
//  WPRechargeViewController.m
//  WinShoppingMall
//  充值
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRechargeViewController.h"
#import "WPSuccessOrfailedController.h"
#import "Header.h"
#import "WPBankCardController.h"
#import "WPPayTypeController.h"
#import "WPAddCardController.h"
#import "WPConfirmVerificationController.h"
#import "WPGatheringCodeController.h"
#import "WPPayPopupController.h"

@interface WPRechargeViewController ()<UIPopoverPresentationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WPRowTableViewCell *moneyCell;

@property (nonatomic, strong) WPRowTableViewCell *wayCell;

@property (nonatomic, strong) WPRowTableViewCell *cvvCell;

@property (nonatomic, strong) WPRowTableViewCell *poundageCell;

@property (nonatomic, strong) UILabel *stateLable;

@property (nonatomic, strong) WPButton *confirmButton;

//  支付类型
@property (nonatomic, copy) NSString *payType;

//  CardId
@property (nonatomic, copy) NSString *cardId;

//  手续费率
@property (nonatomic, assign) float rate;

@end

@implementation WPRechargeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.cardId = @"";

    [self getPoundageData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCardSuccess:) name:WPNotificationAddCardSuccess object:nil];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - Init

- (WPRowTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"充值金额" placeholder:@"请输入您要充值的金额" rectMake:rect];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [_moneyCell.textField addTarget:self action:@selector(moneyCellTextField) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}

- (WPRowTableViewCell *)wayCell
{
    if (!_wayCell) {
        _wayCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame), kScreenWidth, WPRowHeight);
        [_wayCell tableViewCellTitle:@"充值方式" buttonTitle:@"请选择支付方式" rectMake:rect];
        [_wayCell.button addTarget:self action:@selector(wayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _wayCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_wayCell];
    }
    return _wayCell;
}

- (WPRowTableViewCell *)poundageCell
{
    if (!_poundageCell) {
        _poundageCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.wayCell.frame), kScreenWidth, WPRowHeight);
        NSString *title = [NSString stringWithFormat:@"当前手续费率：%.2f%@", self.rate * 100, @"%"];
        [_poundageCell tableViewCellTitle:@"手续费" contentTitle:title rectMake:rect];
        _poundageCell.contentLabel.textColor = [UIColor placeholderColor];
        [self.view addSubview:_poundageCell];
    }
    return _poundageCell;
}

- (WPRowTableViewCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.poundageCell.frame), kScreenWidth, WPRowHeight);
        [_cvvCell tableViewCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _cvvCell.hidden = YES;
        [self.view addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (UILabel *)stateLable
{
    if (!_stateLable) {
        NSString *rechargeStateStr = [NSString stringWithFormat:@"充值说明：\n1、微信支付：每次最多充值500元\n2、支付宝支付：每次最多充值1000元\n3、银行卡支付：需要先绑定用户的银行卡\n如果超过上述金额，需要上传身份证照片进行认证。"];
        
        _stateLable = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 10, kScreenWidth - 2 * WPLeftMargin, 120)];
        _stateLable.numberOfLines = 0;
        _stateLable.text = rechargeStateStr;
        _stateLable.textColor = [UIColor grayColor];
        _stateLable.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_stateLable];
    }
    return _stateLable;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.stateLable.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认充值" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmRechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)moneyCellTextField
{
    self.poundageCell.contentLabel.text = [WPPublicTool calculateMoney:self.moneyCell.textField.text rate:self.rate];
    self.poundageCell.contentLabel.font = [UIFont systemFontOfSize:13];
    self.poundageCell.contentLabel.textColor = [UIColor grayColor];
}

- (void)wayButtonClick:(UIButton *)button
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf

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
//                [WPUserInfor sharedWPUserInfor].popType = @"2";
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

- (void)confirmRechargeButtonClick
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.moneyCell.textField.text floatValue] == 0 || self.moneyCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入充值金额"];
    }
    else if ([self.wayCell.button.titleLabel.text isEqualToString:@"请选择支付方式"]) {
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

//- (void)addCardSuccess:(NSNotification *)notification {
//    NSString *cardNumber = [WPPublicTool base64DecodeString:notification.userInfo[@"cardNumber"]];
//    cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
//    [self.wayCell.button setTitle:[NSString stringWithFormat:@"%@(尾号%@)", notification.userInfo[@"bankName"], cardNumber] forState:UIControlStateNormal];
//    [self.wayCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
            [self moneyCell];
            [self wayCell];
            [self poundageCell];
            [self cvvCell];
            [self stateLable];
            [self confirmButton];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushWithChargeDataWithPassword:(NSString *)payPassword
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" :self.cardId,
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPRechargeURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"充值结果";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([type isEqualToString:@"2"]) {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
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
        else if ([type isEqualToString:@"3"]) {
            [WPProgressHUD showInfoWithStatus:result[@"msg"]];
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
