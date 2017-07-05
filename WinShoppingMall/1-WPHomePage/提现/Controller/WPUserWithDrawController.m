//
//  WPUserWithDrawController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserWithDrawController.h"
#import "Header.h"
#import "WPCardTableViewCell.h"
#import "WPBankCardController.h"
#import "WPBankCardModel.h"
#import "WPUserWithDrawView.h"
#import "WPPayPopupController.h"
#import "WPSuccessOrfailedController.h"
#import "WPEditUserInfoModel.h"

@interface WPUserWithDrawController ()<UITextFieldDelegate>

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) WPUserWithDrawView *withDrawView;

@property (nonatomic, strong) WPButton *confirmButton;;

@property (nonatomic, strong) WPBankCardModel *model;

@property (nonatomic, strong) WPEditUserInfoModel *userInfoModel;

@end

@implementation WPUserWithDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = [UIColor cellColor];
    [self getUserInforData];
}

#pragma mark - Init

- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPNavigationHeight + 20, kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择银行卡" rectMake:rect];
        [_cardCell.backgroundButton addTarget:self action:@selector(selectCardAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cardCell];
    }
    return _cardCell;
}

- (WPUserWithDrawView *)withDrawView
{
    if (!_withDrawView) {
        _withDrawView = [[WPUserWithDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cardCell.frame) + 20, kScreenWidth, 160.5)];
        _withDrawView.titleLabel.text = @"提现金额";
        _withDrawView.balanceLabel.text = [NSString stringWithFormat:@"可用余额 %.2f元", self.userInfoModel.avl_balance];
        _withDrawView.moneyTextField.delegate = self;
        [_withDrawView.moneyTextField becomeFirstResponder];
        [_withDrawView.allButton addTarget:self action:@selector(allButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_withDrawView.moneyTextField addTarget:self action:@selector(moneyTextFieldAction) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_withDrawView];
    }
    return _withDrawView;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.withDrawView.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认提现" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = [NSString stringWithFormat:@"提现金额:%@元", self.withDrawView.moneyTextField.text];
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

- (void)selectCardAction
{
    WPBankCardController *vc = [[WPBankCardController alloc] init];
    vc.showCardType = @"3";
    __weakSelf
    vc.cardInfoBlock = ^(WPBankCardModel *model) {
        weakSelf.model = model;
        [weakSelf.cardCell.contentLabel setAttributedText:[WPPublicTool stringColorWithString:[WPPublicTool stringWithCardName:model.bankName cardNumber:model.cardNumber] index:model.bankName.length]];
        weakSelf.cardCell.cardImageView.image = [WPPublicTool imageWithImageCode:model.bankCode];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moneyTextFieldAction
{
    if ([self.withDrawView.moneyTextField.text floatValue] > self.userInfoModel.avl_balance) {
        self.withDrawView.moneyTextField.text = [NSString stringWithFormat:@"%.2f", self.userInfoModel.avl_balance];
    }
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:[self.withDrawView.moneyTextField.text floatValue] > 0 ? YES : NO];
}

- (void)allButtonAction
{
    self.withDrawView.moneyTextField.text = [NSString stringWithFormat:@"%.2f", self.userInfoModel.avl_balance];
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:[self.withDrawView.moneyTextField.text floatValue] > 0 ? YES : NO];
}

- (void)confirmButtonAction
{
    if ([self.cardCell.contentLabel.text isEqualToString:@"请选择银行卡"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择银行卡"];
    }
    else if ([self.withDrawView.moneyTextField.text floatValue] == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入金额"];
    }
    else {
        if ([WPAppTool isPayTouchID]) {
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
            [weakSelf confirmButton];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushWithdrawDataWithPassword:(NSString *)passwordString
{
    
    NSDictionary *parameters = @{
                                 @"withdrawAmount" : self.withDrawView.moneyTextField.text,
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.model.id],
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPWithdrawURL parameters:parameters success:^(id success) {
        
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"提现结果";
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
