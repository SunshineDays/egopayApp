//
//  WPUserEnrollController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserEnrollController.h"

#import "WPPublicWebViewController.h"
#import "Header.h"
#import "WPChoseAgreeView.h"

@interface WPUserEnrollController ()<UITextViewDelegate>

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *verificationCodeCell;

@property (nonatomic, strong) UIButton *verificationCodeButton;

@property (nonatomic, strong) WPRowTableViewCell *passwordCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordConfirmCell;

@property (nonatomic, strong) WPRowTableViewCell *referrerCell;

@property (nonatomic, strong) WPChoseAgreeView *agreeView;

@property (nonatomic, strong) WPButton *confirmButton;

//定时器
@property (nonatomic, strong) NSTimer *timer;
//当前秒数
@property (nonatomic, assign) NSInteger currentTime;

//  判断是否同意用户协议 YES：同意
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation WPUserEnrollController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    self.currentTime = getVerificationCodeTime;
    [self confirmButton];
    [self verificationCodeButton];
}

#pragma mark - Init

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"手机号码" placeholder:@"请输入手机号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)verificationCodeCell
{
    if (!_verificationCodeCell) {
        _verificationCodeCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_verificationCodeCell tableViewCellTitle:@"验证码" placeholder:@"六位数字验证码" rectMake:rect];
        _verificationCodeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_verificationCodeCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];

        [self.view addSubview:_verificationCodeCell];
    }
    return _verificationCodeCell;
}

- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton)
    {
        _verificationCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70 - WPLeftMargin, 0, 70, WPRowHeight)];
        [_verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_verificationCodeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [_verificationCodeButton addTarget:self action:@selector(getVerificationCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.verificationCodeCell addSubview:_verificationCodeButton];
    }
    return _verificationCodeButton;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.verificationCodeCell.frame), kScreenWidth, WPRowHeight);
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

- (WPRowTableViewCell *)referrerCell {
    if (!_referrerCell) {
        _referrerCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.passwordConfirmCell.frame), kScreenWidth, WPRowHeight);
        [_referrerCell tableViewCellTitle:@"推荐人" placeholder:@"推荐人手机号码（选填）" rectMake:rect];
        _referrerCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_referrerCell];
    }
    return _referrerCell;
}

- (WPChoseAgreeView *)agreeView
{
    if (!_agreeView) {
        _agreeView = [[WPChoseAgreeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.referrerCell.frame), kScreenWidth, WPRowHeight)];
        [_agreeView.protocolButton setTitle:@"《用户使用协议》" forState:UIControlStateNormal];
        [_agreeView.imageButton addTarget:self action:@selector(userProtocolClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeView.protocolButton addTarget:self action:@selector(userProtocolButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.isSelected = YES;
        [self.view addSubview:_agreeView];
    }
    return _agreeView;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.agreeView.frame) + 30, kScreenWidth - 2 * WPLeftMargin , WPButtonHeight)];
        [_confirmButton setTitle:@"注册" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmEnrollButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}


#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.phoneCell.textField.text.length == 11 && self.verificationCodeCell.textField.text.length == 6 && self.passwordCell.textField.text.length >= 6 && self.passwordConfirmCell.textField.text.length >= 6) ? YES : NO];
}

- (void)timerClick {
    self.currentTime--;
    if (self.currentTime == 0) {
        [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.currentTime = getVerificationCodeTime;
    }
    else {
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.currentTime] forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = NO;
    }
}

- (void)getVerificationCodeButtonClick {
    
    if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else {
        [self getMessageData];
    }
}


- (void)userProtocolClick:(UIButton *)button {
    NSArray *imageArray = @[@"icon_sel_content_s", @"icon_sel_content_n"];
    self.isSelected = !self.isSelected;
    int index = self.isSelected ? 0 : 1;
    [self.agreeView.imageButton setBackgroundImage:[UIImage imageNamed:imageArray[index]] forState:UIControlStateNormal];
}


- (void)userProtocolButtonClick {
    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
    vc.navigationItem.title = @"用户使用协议";
    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserProtocolWebURL];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)confirmEnrollButtonClick {
    if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
    }
    else if (!self.isSelected) {
        [WPProgressHUD showInfoWithStatus:@"请阅读并同意《用户使用协议》"];
    }
    else if (self.verificationCodeCell.textField.text.length != 6) {
        [WPProgressHUD showInfoWithStatus:@"验证码格式错误"];
    }
    else if (self.passwordCell.textField.text.length < 6) {
        [WPProgressHUD showInfoWithStatus:@"密码不能少于六位"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
    }
    else if (![WPRegex validateMobile:self.referrerCell.textField.text] && self.referrerCell.textField.text.length != 0) {
        [WPProgressHUD showInfoWithStatus:@"推荐人手机号码格式不正确"];
    }
    else {
        [self pushEnrollData];
    }
}

#pragma mark - Data

#pragma mark - 验证码
- (void)getMessageData {
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"verType" : @"1"
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPGetMessageURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [weakSelf timer];
        }
        else {
            weakSelf.currentTime = 0;
            [weakSelf timerClick];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushEnrollData {
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneCell.textField.text,
                                 @"ver" : self.verificationCodeCell.textField.text,
                                 @"password" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text],
                                 @"tphone" : self.referrerCell.textField.text.length == 0 ? @"" : self.referrerCell.textField.text,
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPConfirmEnrollURL parameters:parameters success:^(id success) {
        

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            if (self.userEnrollSuccessBlock) {
                self.userEnrollSuccessBlock(@{
                                              @"phone" : self.phoneCell.textField.text,
                                              @"password" : self.passwordCell.textField.text
                                              });
            }
            [WPProgressHUD showSuccessWithStatus:@"注册成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
