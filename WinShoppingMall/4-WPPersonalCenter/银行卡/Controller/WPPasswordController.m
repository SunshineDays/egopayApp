//
//  WPPasswordController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPasswordController.h"
#import "Header.h"
#import "WPUserInforsController.h"
#import "WPPersonalSettingController.h"

@interface WPPasswordController () <UITextFieldDelegate>

@property (nonatomic, strong) WPCustomRowCell *phoneCell;

@property (nonatomic, strong) WPCustomRowCell *verificationCodeCell;

@property (nonatomic, strong) UIButton *verificationCodeButton;

@property (nonatomic, strong) WPCustomRowCell *passwordCell;

@property (nonatomic, strong) WPCustomRowCell *passwordConfirmCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, strong) UILabel *stateLabel;

//  动态设置高度
@property (nonatomic, assign) float passwordHeight;

//当前秒数
@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WPPasswordController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationItem.title.length == 0)
    {
        self.navigationItem.title = @"忘记密码";
    }
    self.currentTime = getVerificationCodeTime;
    if (self.isFirstPassword)
    {
        self.passwordHeight = WPTopY + 10;
    }
    else
    {
        self.passwordHeight = WPTopY + 10 + WPRowHeight * 2;
        [self phoneCell];
        [self verificationCodeCell];
        [self verificationCodeButton];
    }
    [self passwordCell];
    [self passwordConfirmCell];
    [self confirmButton];
    if (self.isShowState)
    {
        [self stateLabel];
    }
}

#pragma mark - Init

- (WPCustomRowCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        NSString *placeholder = [WPUserInfor sharedWPUserInfor].clientId.length == 0 ? @"请输入手机号码" : [WPUserInfor sharedWPUserInfor].userPhone;
        [_phoneCell rowCellTitle:@"手机号码" placeholder:placeholder rectMake:rect];
        _phoneCell.textField.enabled = [WPUserInfor sharedWPUserInfor].clientId.length == 0 ? YES : NO;
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneCell.hidden = self.isFirstPassword ? YES : NO;
        if ([WPUserInfor sharedWPUserInfor].clientId.length == 0) {
            [_phoneCell.textField becomeFirstResponder];
        }
        
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPCustomRowCell *)verificationCodeCell
{
    if (!_verificationCodeCell) {
        _verificationCodeCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_verificationCodeCell rowCellTitle:@"验证码" placeholder:@"六位数字验证码" rectMake:rect];
        _verificationCodeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _verificationCodeCell.hidden = self.isFirstPassword ? YES : NO;
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
        [_verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.verificationCodeCell addSubview:_verificationCodeButton];
    }
    return _verificationCodeButton;
}

- (WPCustomRowCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, self.passwordHeight, kScreenWidth, WPRowHeight);
        [_passwordCell rowCellTitle:@"密码" placeholder:[self.passwordType isEqualToString:@"1"] ? @"请输入密码" : @"请输入六位纯数字密码" rectMake:rect];
        _passwordCell.textField.keyboardType = [self.passwordType isEqualToString:@"1"] ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        _passwordCell.textField.secureTextEntry = YES;
        [_passwordCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        _passwordCell.textField.delegate = self;
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
        _passwordConfirmCell.textField.keyboardType = [self.passwordType isEqualToString:@"1"] ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        _passwordConfirmCell.textField.secureTextEntry = YES;
        [_passwordConfirmCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        _passwordConfirmCell.textField.delegate = self;
        [self.view addSubview:_passwordConfirmCell];
    }
    return _passwordConfirmCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordConfirmCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin , WPButtonHeight)];
        [_confirmButton setTitle:self.isFirstPassword ? @"提交" : @"确认修改" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.confirmButton.frame) + 10, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = @"注：子账户密码只能在主账户上修改";
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validateSpace:string];
}


#pragma mark - Action

- (void)changeButtonSurface
{
    BOOL isEnabled = self.isFirstPassword ? (self.passwordCell.textField.text.length >= 6 && self.passwordConfirmCell.textField.text.length >= 6) : (self.verificationCodeCell.textField.text.length >= 6 && self.passwordCell.textField.text.length >= 6 && self.passwordConfirmCell.textField.text.length >= 6);
    
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:isEnabled];
}

- (void)timerClick
{
    if (self.currentTime == 0)
    {
        [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.currentTime = getVerificationCodeTime;
    }
    else
    {
        self.currentTime--;
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.currentTime] forState:UIControlStateNormal];
        self.verificationCodeButton.userInteractionEnabled = NO;
    }

}

- (void)verificationCodeButtonClick:(UIButton *)sender
{
    if (![WPJudgeTool validateMobile:self.phoneCell.textField.text] && [WPUserInfor sharedWPUserInfor].clientId.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else
    {
        [self getVerificationCodeData];
    }
}

- (void)confirmButtonAction:(UIButton *)button
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (![WPJudgeTool validateMobile:self.phoneCell.textField.text] && [WPUserInfor sharedWPUserInfor].clientId.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if (self.verificationCodeCell.textField.text.length != 6 && !self.isFirstPassword)
    {
        [WPProgressHUD showInfoWithStatus:@"验证码格式错误"];
    }
    else if ((self.passwordCell.textField.text.length < 6 || self.passwordConfirmCell.textField.text.length < 6) && [self.passwordType isEqualToString:@"1"])
    {
        [WPProgressHUD showInfoWithStatus:@"登录密码不能少于六位"];
    }
    else if ((self.passwordCell.textField.text.length != 6 || self.passwordConfirmCell.textField.text.length != 6) && ![self.passwordType isEqualToString:@"1"])
    {
        [WPProgressHUD showInfoWithStatus:@"支付密码为六位纯数数字密码"];
    }
    else if (![self.passwordCell.textField.text isEqualToString:self.passwordConfirmCell.textField.text])
    {
        [WPProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
    }
    else
    {
        self.isFirstPassword ? [self pushPayPasswordData] : [self pushPayOrPasswordData];
    }
}

#pragma mark - Data

- (void)getVerificationCodeData
{
    
    NSDictionary *parameters = @{
                                 @"phone" : [WPUserInfor sharedWPUserInfor].clientId.length > 0 ? self.phoneCell.textField.placeholder : self.phoneCell.textField.text,
                                 @"verType" : @"2"
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPGetMessageURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [WPProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [weakSelf timer];
        }
        else
        {
            weakSelf.currentTime = 0;
            [weakSelf timerClick];
        }
        
    } failure:^(NSError *error)
    {
        
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
    [WPHelpTool postWithURL:WPChangePasswordURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [WPProgressHUD showSuccessWithStatus:[NSString stringWithFormat:[self.passwordType isEqualToString:@"1"] ? @"修改登录密码成功" : @"修改支付密码成功"]];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            if ([weakSelf.passwordType isEqualToString:@"2"] && [WPJudgeTool isPayTouchID])
            {
                [WPKeyChainTool keyChainSave:weakSelf.passwordCell.textField.text forKey:kUserPayPassword];
            }
        }
    } failure:^(NSError *error)
    {
        
    }];
}

//  设置支付密码
- (void)pushPayPasswordData {
    
    NSDictionary *parameters = @{
                                 @"payPassword" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPSetPayPasswordURL parameters:parameters success:^(id success)
    {
        
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        
        if ([type isEqualToString:@"1"])
        {
            [WPUserInfor sharedWPUserInfor].payPasswordType = @"YES";
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            [WPProgressHUD showSuccessWithStatus:@"支付密码设置成功"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
