//
//  WPProductSubmitController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProductSubmitController.h"

#import "Header.h"

#import "WPPayTypeController.h"
#import "WPAddCardController.h"
#import "WPPayPopupController.h"
#import "WPSuccessOrfailedController.h"
#import "WPGatheringCodeController.h"
#import "WPUserEnrollController.h"

@interface WPProductSubmitController ()<UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) WPRowTableViewCell *moneyCell;

@property (nonatomic, strong) WPRowTableViewCell *wayCell;

@property (nonatomic, strong) WPRowTableViewCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *cardId;

@end

@implementation WPProductSubmitController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardId = @"";
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

- (WPRowTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"升级金额" contentTitle:self.gradeMoney rectMake:rect];
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
        [_wayCell.button addTarget:self action:@selector(wayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 10, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"支付金额:%@元", self.gradeMoney];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        [weakSelf pushMerchantGradeDataWithPayPassword:payPassword];
    };
    vc.forgetPasswordBlock = ^{
        WPPasswordController *vc = [[WPPasswordController alloc] init];
        vc.passwordType = @"2";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Action

- (void)wayButtonClick:(UIButton *)button
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.isUseMoney = YES;
    vc.amount = [self.gradeMoney floatValue];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    //支付宝／微信支付
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
//                [WPUserInfor sharedWPUserInfor].popType = @"4";
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.wayCell.button.titleLabel.text isEqualToString:@"请选择支付方式"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else if (self.cvvCell.hidden == NO && self.cvvCell.textField.text.length != 3) {
        [WPProgressHUD showInfoWithStatus:@"请输入CVV码"];
    }
    else {
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"4"]) {
            if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"3"]) {
                [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
                    [self pushMerchantGradeDataWithPayPassword:touchIDSuccess];
                    
                } failure:^(NSError *error) {
                    [self initPayPopupView];
                }];
            }
            else {
                [self initPayPopupView];
            }
        }
        else {
            [self pushMerchantGradeDataWithPayPassword:@""];
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

- (void)pushMerchantGradeDataWithPayPassword:(NSString *)payPassword
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];

    NSDictionary *parameters = @{
                                 @"uplvId" :  self.userLv,
                                 @"payMethod" : self.payType,
                                 @"cnv" : self.cvvCell.textField.text.length == 0 ? @"" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"cardId" : self.cardId,
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:self.isDelegate ? WPDelegateGradeURL : WPMerchantGradeURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = self.isDelegate ? @"代理升级结果" : @"商户升级结果";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
