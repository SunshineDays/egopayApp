//
//  WPSubAccountChangePasswordController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountChangePasswordController.h"
#import "Header.h"

@interface WPSubAccountChangePasswordController ()

@property (nonatomic, strong) WPCustomRowCell *passwordCell;

@property (nonatomic, strong) WPCustomRowCell *passwordConfirmCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPSubAccountChangePasswordController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"重置密码";
    [self confirmButton];
}

#pragma mark - Init

- (WPCustomRowCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_passwordCell rowCellTitle:@"密码" placeholder:@"请输入密码" rectMake:rect];
        _passwordCell.textField.secureTextEntry = YES;
        [_passwordCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordCell];
    }
    return _passwordCell;
}

- (WPCustomRowCell *)passwordConfirmCell
{
    if (!_passwordConfirmCell) {
        _passwordConfirmCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.passwordCell.frame), kScreenWidth, WPRowHeight);
        [_passwordConfirmCell rowCellTitle:@"确认密码" placeholder:@"请确认密码" rectMake:rect];
        _passwordConfirmCell.textField.secureTextEntry = YES;
        [_passwordConfirmCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordConfirmCell];
    }
    return _passwordConfirmCell;
}

-(WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordConfirmCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.passwordCell.textField.text.length >= 6 && self.passwordConfirmCell.textField.text.length >= 6) ? YES : NO];
}

- (void)confirmButtonAction
{
    if (self.passwordCell.textField.text.length < 6)
    {
        [WPProgressHUD showInfoWithStatus:@"密码不能少于六位"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text])
    {
        [WPProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
    }
    else
    {
        [self postChangePasswordData];
    }
}

#pragma mark - Data

- (void)postChangePasswordData
{
    NSDictionary *parameters = @{
                                 @"clerkId" : self.clerkID,
                                 @"password" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPSubAccountChangePasswordURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [WPProgressHUD showSuccessWithStatus:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
