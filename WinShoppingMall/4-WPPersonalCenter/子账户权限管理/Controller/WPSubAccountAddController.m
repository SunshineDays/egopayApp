//
//  WPAddSubAccountController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountAddController.h"
#import "Header.h"
#import "WPSubAccountSettingController.h"

@interface WPSubAccountAddController ()

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordConfirmCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPSubAccountAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"创建子账户";
    [self confirmButton];
}

- (WPRowTableViewCell *)nameCell
{
    if (!_nameCell) {
        _nameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_nameCell tableViewCellTitle:@"账户名" placeholder:@"请输入账户名" rectMake:rect];
        [_nameCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_passwordCell tableViewCellTitle:@"密        码" placeholder:@"请输入密码" rectMake:rect];
        _passwordCell.textField.secureTextEntry = YES;
        [_passwordCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordCell];
    }
    return _passwordCell;
}

- (WPRowTableViewCell *)passwordConfirmCell
{
    if (!_passwordConfirmCell) {
        _passwordConfirmCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.passwordCell.frame), kScreenWidth, WPRowHeight);
        [_passwordConfirmCell tableViewCellTitle:@"确认密码" placeholder:@"请确认密码" rectMake:rect];
        _passwordConfirmCell.textField.secureTextEntry = YES;
        [_passwordConfirmCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordConfirmCell];
    }
    return _passwordConfirmCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordConfirmCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}


#pragma mark - Actin

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.nameCell.textField.text.length >= 1 && self.passwordCell.textField.text.length >= 6 && self.passwordConfirmCell.textField.text.length >= 6) ? YES : NO];
}

- (void)confirmButtonAction
{
    if (self.nameCell.textField.text.length < 2) {
        [WPProgressHUD showInfoWithStatus:@"子账户姓名格式错误"];
    }
    else if (self.passwordCell.textField.text.length < 6) {
        [WPProgressHUD showInfoWithStatus:@"密码不能少于六位"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
    }
    else {
        [self postSubAccountData];
    }
}

#pragma mark - Data
- (void)postSubAccountData
{
    NSDictionary *parameters = @{
                                 @"clerkName" : self.nameCell.textField.text,
                                 @"password" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPSubAccountAddURL parameters:parameters success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationSubAccountAddSuccess object:nil];
            WPSubAccountSettingController *vc = [[WPSubAccountSettingController alloc] init];
            vc.isFirst = YES;
            vc.clerkID = [NSString stringWithFormat:@"%@", result[@"clerkId"]];
            vc.clerkRegisterID = [NSString stringWithFormat:@"%@", result[@"clerkNo"]];
            
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
