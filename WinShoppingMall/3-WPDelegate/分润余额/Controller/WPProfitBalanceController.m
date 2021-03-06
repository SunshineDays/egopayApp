//
//  WPProfitBalanceController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProfitBalanceController.h"
#import "Header.h"
#import "WPUserEnrollController.h"
#import "WPSuccessOrfailedController.h"

@interface WPProfitBalanceController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) WPCustomRowCell *moneyCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPProfitBalanceController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"分润余额";
    
    [self titleLabel];
    [self moneyLabel];
    [self moneyCell];
    [self confirmButton];
}

#pragma mark - Init
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _titleLabel.text = @"分润余额(元)";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth - 2 * WPLeftMargin, 80)];
        _moneyLabel.text = self.moneyString;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:30 weight:20];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (WPCustomRowCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyLabel.frame) + 10, kScreenWidth, WPRowHeight);
        [_moneyCell rowCellTitle:@"转出金额" placeholder:[NSString stringWithFormat:@"最多可提取%@元", self.moneyString] rectMake:rect];
        _moneyCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyCell.textField.delegate = self;
        [_moneyCell.textField becomeFirstResponder];
        [_moneyCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}


- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.moneyCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"转出到账户余额" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(withDrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    if ([self.moneyCell.textField.text floatValue] > [self.moneyString floatValue])
    {
        self.moneyCell.textField.text = self.moneyString;
    }
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:[self.moneyCell.textField.text floatValue] > 0 ? YES : NO];
}

- (void)withDrawButtonClick:(UIButton *)button
{
    if ([self.moneyString floatValue] < [self.moneyCell.textField.text floatValue])
    {
        [WPProgressHUD showInfoWithStatus:@"转出金额不能大于分润余额"];
    }
    else if ([self.moneyCell.textField.text floatValue] == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入转出金额"];
    }
    else
    {
        __weakSelf
        [WPPayTool payWithTitle:[NSString stringWithFormat:@"提现金额:%@元", self.moneyCell.textField.text] password:^(id password) {
            [weakSelf pushWithdrawDataWithPassword:password];
        }];
    }
}

#pragma mark - Data

- (void)pushWithdrawDataWithPassword:(NSString *)passwordString
{
    NSDictionary *parameters = @{
                                 @"withdrawAmount" : self.moneyCell.textField.text,
                                 @"payPassword" : [WPPublicTool base64EncodeString:passwordString]
                                 };
    
    __weakSelf
    [WPHelpTool postWithURL:WPProfitWithdrawURL parameters:parameters success:^(id success)
    {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
            vc.navigationItem.title = @"提现结果";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
