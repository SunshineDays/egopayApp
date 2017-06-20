//
//  WPAddSubAccountController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAddSubAccountController.h"
#import "Header.h"
#import "WPSubAccountSettingController.h"

@interface WPAddSubAccountController ()

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordConfirmCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPAddSubAccountController

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
        [_nameCell tableViewCellTitle:@"姓        名" placeholder:@"请输入子账户的姓名" rectMake:rect];
        [self.view addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"手机号码" placeholder:@"请输入子账户的手机号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_passwordCell tableViewCellTitle:@"密        码" placeholder:@"请输入密码(不少于六位)" rectMake:rect];
        _passwordCell.textField.secureTextEntry = YES;
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

- (void)confirmButtonAction
{
    if (self.nameCell.textField.text.length < 2) {
        [WPProgressHUD showInfoWithStatus:@"子账户姓名格式错误"];
    }
    else if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"手机号码格式错误"];
    }
    else if (self.passwordCell.textField.text.length < 6) {
        [WPProgressHUD showInfoWithStatus:@"密码不能少于6位"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"两次密码输入不一致"];
    }
    else {
        [self postSubAccountData];
    }
}

#pragma mark - Data
- (void)postSubAccountData
{
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"clerkName" : self.nameCell.textField.text,
                                 @"password" : self.passwordCell.textField.text
                                 };
    [WPHelpTool postWithURL:WPSubAccountAddURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"reuslt"];
        if ([type isEqualToString:@"1"]) {
            WPSubAccountSettingController *vc = [[WPSubAccountSettingController alloc] init];
            vc.isFirst = YES;
            vc.clerkID = [NSString stringWithFormat:@"%@", result[@"clerkId"]];
            [self.navigationController pushViewController:vc animated:YES];
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
