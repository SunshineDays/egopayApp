//
//  WPWithdrawController.m
//  WinShoppingMall
//  提现
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPWithdrawController.h"
 #import "WPSuccessOrfailedController.h"
#import "Header.h"
#import "WPBankCardController.h"
#import "WPPayPopupController.h"
#import "WPBankCardModel.h"
#import "WPEditUserInfoModel.h"

@interface WPWithdrawController ()<UIPopoverPresentationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountMoneyLabel;

@property (nonatomic, strong) WPRowTableViewCell *moneyCell;

@property (nonatomic, strong) WPRowTableViewCell *wayCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, strong) NSArray *cardArray;

@property (nonatomic, strong) NSMutableArray *dotArray;

@property (nonatomic, strong) WPBankCardModel *model;

@property (nonatomic, strong) WPEditUserInfoModel *userInfoModel;

@end

@implementation WPWithdrawController

#pragma mark - LIfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"提现";
    [self getUserInforData];
}


#pragma mark - Init

- (void)createAccountMoneyView
{
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPNavigationHeight + 20, 100, WPRowHeight)];
    moneyLabel.text = @"账户余额（元）";
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:moneyLabel];
    
    self.accountMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(moneyLabel.frame), kScreenWidth - 2 * WPLeftMargin, 80)];
    self.accountMoneyLabel.text = [NSString stringWithFormat:@"%.2f", self.userInfoModel.avl_balance];
    self.accountMoneyLabel.textColor = [UIColor blackColor];
    self.accountMoneyLabel.font = [UIFont systemFontOfSize:30 weight:20];
    self.accountMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.accountMoneyLabel];
}

- (WPRowTableViewCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.accountMoneyLabel.frame) + 10, kScreenWidth, WPRowHeight);
        [_moneyCell tableViewCellTitle:@"提现金额" placeholder:[NSString stringWithFormat:@"最多可提现%@元",self.accountMoneyLabel.text] rectMake:rect];
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
        [_wayCell tableViewCellTitle:@"提现方式" buttonTitle:@"请选择提现方式" rectMake:rect];
        [_wayCell.button addTarget:self action:@selector(selectCardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _wayCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_wayCell];
    }
    return _wayCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.wayCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认提现" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"提现金额:%@元", self.moneyCell.textField.text];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        
        [weakSelf pushWithdrawDataWithPassword:payPassword];
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

- (void)selectCardButtonClick:(UIButton *)button
{
    WPBankCardController *vc = [[WPBankCardController alloc] init];
    vc.showCardType = @"3";
    __weakSelf
    vc.cardInfoBlock = ^(WPBankCardModel *model) {
        
        NSString *cardNumber = [WPPublicTool base64DecodeString:model.cardNumber];
        cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
        self.model = model;
        [weakSelf.wayCell.button setTitle:[NSString stringWithFormat:@"%@(尾号%@)",self.model.bankName, cardNumber] forState:UIControlStateNormal];
        [weakSelf.wayCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmButtonClick
{
    
    if ([self.moneyCell.textField.text floatValue] == 0 || self.moneyCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入提现金额"];
    }
    else if ([self.moneyCell.textField.text floatValue] > [self.accountMoneyLabel.text floatValue]) {
        [WPProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"您最多可提现金额为%@元", self.accountMoneyLabel.text]];
    }
    else if ([self.wayCell.button.titleLabel.text isEqualToString:@"请选择提现方式"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择提现方式"];
    }
    else {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"3"]) {
            __weakSelf
            [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
                [weakSelf pushWithdrawDataWithPassword:touchIDSuccess];
                
            } failure:^(NSError *error) {
                [weakSelf initPayPopupView];
            }];
        }
        else {
            [self initPayPopupView];
        }
    }
}


#pragma mark - Data

- (void)getUserInforData
{
    
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.userInfoModel = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            [weakSelf createAccountMoneyView];
            [weakSelf wayCell];
            [weakSelf moneyCell];
            [weakSelf confirmButton];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushWithdrawDataWithPassword:(NSString *)passwordString
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    NSDictionary *parameters = @{
                                 @"withdrawAmount" : self.moneyCell.textField.text,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", self.model.id],
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPWithdrawURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"提现结果";
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
