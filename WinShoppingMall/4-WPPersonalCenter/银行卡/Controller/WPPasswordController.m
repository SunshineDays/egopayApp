//
//  WPPasswordController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPasswordController.h"
#import "Header.h"


@interface WPPasswordController ()

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *verificationCodeCell;

@property (nonatomic, strong) UIButton *verificationCodeButton;

@property (nonatomic, strong) WPRowTableViewCell *passwordCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordConfirmCell;

@property (nonatomic, strong) WPButton *confirmButton;

//  动态设置高度
@property (nonatomic, assign) float passwordHeight;

//当前秒数
@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WPPasswordController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationItem.title.length == 0) {
        self.navigationItem.title = @"忘记密码";
    }
    self.currentTime = getVerificationCodeTime;
    if (self.isFirstPassword) {
        self.passwordHeight = WPNavigationHeight + 10;
    }
    else {
        self.passwordHeight = WPNavigationHeight + 10 + WPRowHeight * 2;
        [self phoneCell];
        [self verificationCodeCell];
        [self verificationCodeButton];
    }
    [self passwordCell];
    [self passwordConfirmCell];
    [self confirmButton];
}

#pragma mark - Init

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        NSString *placeholder = [WPUserInfor sharedWPUserInfor].clientId.length == 0 ? @"请输入手机号码" : [WPUserInfor sharedWPUserInfor].userPhone;
        [_phoneCell tableViewCellTitle:@"手机号码" placeholder:placeholder rectMake:rect];
        _phoneCell.textField.enabled = [WPUserInfor sharedWPUserInfor].clientId.length == 0 ? YES : NO;
        _phoneCell.hidden = self.isFirstPassword ? YES : NO;
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)verificationCodeCell
{
    if (!_verificationCodeCell) {
        _verificationCodeCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth - WPLeftMargin - 70, WPRowHeight);
        [_verificationCodeCell tableViewCellTitle:@"验证码" placeholder:@"请输入手机验证码" rectMake:rect];
        _verificationCodeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _verificationCodeCell.hidden = self.isFirstPassword ? YES : NO;
        [self.view addSubview:_verificationCodeCell];
    }
    return _verificationCodeCell;
}

- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton)
    {
        _verificationCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70 - WPLeftMargin, CGRectGetMinY(self.verificationCodeCell.frame), 70, WPRowHeight)];
        [_verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_verificationCodeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [_verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_verificationCodeButton];
    }
    return _verificationCodeButton;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, self.passwordHeight, kScreenWidth, WPRowHeight);
        [_passwordCell tableViewCellTitle:@"密        码" placeholder:[self.passwordType isEqualToString:@"1"] ? @"请输入不少于六位数的密码" : @"请输入六位纯数字密码" rectMake:rect];
        _passwordCell.textField.keyboardType = [self.passwordType isEqualToString:@"1"] ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
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
        [_passwordConfirmCell tableViewCellTitle:@"确认密码" placeholder:@"请再次确认密码" rectMake:rect];
        _passwordConfirmCell.textField.keyboardType = [self.passwordType isEqualToString:@"1"] ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        _passwordConfirmCell.textField.secureTextEntry = YES;
        [self.view addSubview:_passwordConfirmCell];
    }
    return _passwordConfirmCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordConfirmCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin , WPButtonHeight)];
        [_confirmButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


#pragma mark - Action

- (void)timerClick
{
    if (self.currentTime == 0) {
        [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.currentTime = getVerificationCodeTime;
    }
    else {
        self.currentTime--;
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",self.currentTime] forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = NO;
    }
}

- (void)verificationCodeButtonClick:(UIButton *)sender
{
    if (![WPRegex validateMobile:self.phoneCell.textField.text] && [WPUserInfor sharedWPUserInfor].clientId.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else {
        [self getVerificationCodeData];
    }
}

- (void)confirmButtonAction:(UIButton *)button {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (![WPRegex validateMobile:self.phoneCell.textField.text] && [WPUserInfor sharedWPUserInfor].clientId.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if (self.verificationCodeCell.textField.text.length != 6 && !self.isFirstPassword) {
        [WPProgressHUD showInfoWithStatus:@"您输入的验证码错误"];
    }
    else if ((self.passwordCell.textField.text.length < 6 || self.passwordConfirmCell.textField.text.length < 6) && [self.passwordType isEqualToString:@"1"]) {
        [WPProgressHUD showInfoWithStatus:@"登录密码不能少于六位"];
    }
    else if ((self.passwordCell.textField.text.length != 6 || self.passwordConfirmCell.textField.text.length != 6) && ![self.passwordType isEqualToString:@"1"]) {
        [WPProgressHUD showInfoWithStatus:@"支付密码应该为六位数数字密码"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
    }
    else{
        self.isFirstPassword ? [self pushPayPasswordData] : [self pushPayOrPasswordData];
    }
}

#pragma mark - Data

- (void)getVerificationCodeData {
    
    NSDictionary *parameters = @{
                                 @"phone" : [WPUserInfor sharedWPUserInfor].clientId.length > 0 ? self.phoneCell.textField.placeholder : self.phoneCell.textField.text,
                                 @"verType" : @"2"
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPGetMessageURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [weakSelf timer];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
            weakSelf.currentTime = 0;
            [weakSelf timerClick];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//  修改密码
- (void)pushPayOrPasswordData
{
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"phone" : [WPUserInfor sharedWPUserInfor].clientId.length == 0 ? self.phoneCell.textField.text : self.phoneCell.textField.placeholder,
                                 @"passType" : self.passwordType,
                                 @"ver" : self.verificationCodeCell.textField.text,
                                 @"newPassword" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPChangePasswordURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:[NSString stringWithFormat:[self.passwordType isEqualToString:@"1"] ? @"修改登陆密码成功" : @"修改支付密码成功"]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([weakSelf.passwordType isEqualToString:@"2"]) {
                [WPKeyChainTool keyChainSave:weakSelf.passwordCell.textField.text forKey:kUserPayPassword];
            }
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}

//  设置支付密码
- (void)pushPayPasswordData {
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"payPassword" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPSetPayPasswordURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            [WPUserInfor sharedWPUserInfor].payPasswordType = @"1";
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            [WPProgressHUD showSuccessWithStatus:@"支付密码设置成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
