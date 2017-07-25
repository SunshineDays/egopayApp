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

- (void)viewDidLoad
{
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
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择支付方式" rectMake:rect];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validatePrice:textField.text range:range replacementString:string];
}


#pragma mark - Action

- (void)changeButtonSurface
{
    if (self.cvvCell.hidden)
    {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.phoneCell.textField.text.length > 6 && [self.transferView.moneyTextField.text floatValue] > 0) ? YES : NO];
    }
    else
    {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.phoneCell.textField.text.length > 6 && [self.transferView.moneyTextField.text floatValue] > 0 && self.cvvCell.textField.text.length == 3) ? YES : NO];
    }
}

- (void)wayButtonAction
{
    __weakSelf
    [WPHelpTool showPayTypeWithAmount:self.transferView.moneyTextField.text navigationController:self.navigationController Card:^(WPBankCardModel *model)
    {
        weakSelf.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        weakSelf.payType = [WPPublicTool payCardWithView:weakSelf.cardCell model:model];
        
    } other:^(id rowType)
    {
        weakSelf.cvvCell.hidden = YES;
        weakSelf.payType = [WPPublicTool payThirdWithView:weakSelf.cardCell rowType:rowType];
    }];
}

- (void)confirmButtonAction
{
    if (![WPJudgeTool validateMobile:self.phoneCell.textField.text])
    {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if ([self.transferView.moneyTextField.text floatValue] == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入转账金额"];
    }
    else if ([self.cardCell.contentLabel.text isEqualToString:@"请选择支付方式"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else
    {
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"4"])
        {
            if ([WPJudgeTool isPayTouchID])
            {
                __weakSelf
                [WPHelpTool payWithTouchIDsuccess:^(id success)
                {
                    [weakSelf pushTransferAccountsDataWithPassword:success];
                    
                } failure:^(NSError *error)
                {
                    [weakSelf initPayPopupView];
                }];
            }
            else
            {
                [self initPayPopupView];
            }
        }
        else
        {
            [self pushTransferAccountsDataWithPassword:@""];
        }
    }
}

- (void)initPayPopupView
{
    __weakSelf
    [WPHelpTool showPayPasswordViewWithTitle:[NSString stringWithFormat:@"转账金额:%@元", self.transferView.moneyTextField.text] navigationController:self.navigationController success:^(id success)
    {
        [weakSelf pushTransferAccountsDataWithPassword:success];
    }];
}

#pragma mark - Data

- (void)pushTransferAccountsDataWithPassword:(NSString *)passwordString
{
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"transferAmount" : self.transferView.moneyTextField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" : self.model.id ? [NSString stringWithFormat:@"%ld", (long)self.model.id] : @"",
                                 @"cnv" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPTransferAccountsURL parameters:parameters success:^(id success)
    {
        
        [WPHelpTool payResultControllerWithTitle:@"转账结果" successResult:success navigationController:weakSelf.navigationController];

    } failure:^(NSError *error)
    {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
