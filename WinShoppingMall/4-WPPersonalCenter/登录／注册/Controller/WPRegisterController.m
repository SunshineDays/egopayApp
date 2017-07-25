//
//  WPRegisterController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRegisterController.h"
 
#import "WPPublicWebViewController.h"
#import "WPUserEnrollController.h"
#import "Header.h"
#import "WPTabBarController.h"
#import <JPush/JPUSHService.h>
#import "WPAPPInfo.h"

@interface WPRegisterController ()<UITextFieldDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) WPRowTableViewCell *accountCell;

@property (nonatomic, strong) WPRowTableViewCell *passwordCell;

@property (nonatomic, strong) WPButton *registerButton;

@property (nonatomic, strong) UIButton *forgetPasswordButton;

@end

@implementation WPRegisterController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemButtonClick)];

    [self forgetPasswordButton];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}

#pragma mark - Init

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, WPNavigationHeight + 30, 80, 80)];
        _imageView.image = [UIImage imageNamed:@"share_wintopay"];
        _imageView.layer.borderColor = [UIColor lineColor].CGColor;
        _imageView.layer.borderWidth = WPLineHeight;
        _imageView.layer.cornerRadius = 40;
        _imageView.layer.masksToBounds = YES;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (WPRowTableViewCell *)accountCell
{
    if (!_accountCell) {
        _accountCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth, 60);
        [_accountCell tableViewCellTitle:nil placeholder:@"请输入手机号／子账户ID" rectMake:rect];
        _accountCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_accountCell.lineView setFrame:CGRectMake(WPLeftMargin, WPRowHeight - WPLineHeight, kScreenWidth - WPLeftMargin, WPLineHeight)];
        if ([WPUserInfor sharedWPUserInfor].userPhone.length > 0) {
            self.accountCell.textField.text = [WPUserInfor sharedWPUserInfor].userPhone;
        }
        else {
            [self.accountCell.textField becomeFirstResponder];
        }
        [_accountCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_accountCell];
    }
    return _accountCell;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.accountCell.frame), kScreenWidth, 60);
        [_passwordCell tableViewCellTitle:nil placeholder:@"请输入密码" rectMake:rect];
        [_passwordCell.lineView setFrame:CGRectMake(WPLeftMargin, WPRowHeight - WPLineHeight, kScreenWidth - WPLeftMargin, WPLineHeight)];
        _passwordCell.textField.secureTextEntry = YES;
        _passwordCell.textField.delegate = self;
        [_passwordCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        if ([WPUserInfor sharedWPUserInfor].userPhone > 0) {
            [_passwordCell.textField becomeFirstResponder];
        }
        _passwordCell.textField.delegate = self;
        [self.view addSubview:_passwordCell];
    }
    return _passwordCell;
}

- (WPButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_registerButton setTitle:@"登录" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerButton];
    }
    return _registerButton;
}

- (UIButton *)forgetPasswordButton
{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 120, CGRectGetMaxY(self.registerButton.frame) + 20, 100, 20)];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetPasswordButton];
    }
    return _forgetPasswordButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validateSpace:string];
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.registerButton userInteractionEnabled:(self.accountCell.textField.text.length > 6 && self.passwordCell.textField.text.length >= 6) ? YES : NO];
}

- (void)rightItemButtonClick
{
    WPUserEnrollController *vc = [[WPUserEnrollController alloc] init];
    
    __weakSelf
    vc.userEnrollSuccessBlock = ^(NSDictionary *userEnrollDict)
    {
        weakSelf.accountCell.textField.text = userEnrollDict[@"phone"];
        weakSelf.passwordCell.textField.text = userEnrollDict[@"password"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userProtocolButtonClick
{
    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)registerButtonClick
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if ((![WPJudgeTool validateMobile:self.accountCell.textField.text] && self.accountCell.textField.text.length == 11) || (self.accountCell.textField.text.length != 11 && self.accountCell.textField.text.length != 9))
    {
        [WPProgressHUD showInfoWithStatus:@"账号格式错误"];
    }
    else if (self.passwordCell.textField.text.length < 6)
    {
        [WPProgressHUD showInfoWithStatus:@"密码不能少于六位"];
    }
    else
    {
        [self getData];
    }
}

- (void)forgetPasswordButtonClick
{
    WPPasswordController *vc = [[WPPasswordController alloc] init];
    vc.passwordType = @"1";
    vc.isShowState = YES;
    vc.navigationItem.title = @"忘记密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)start
{
    [WPHelpTool rootViewController:[[WPTabBarController alloc] init]];
}

#pragma mark - Data

- (void)getData
{
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"mobildID" : [WPAPPInfo deviceId],
                                 @"deviceOem" : @"iPhone",
                                 @"deviceOS" : [NSString stringWithFormat:@"%f", [WPAPPInfo iOSVersion]],
                                 @"appVersion" : [WPAPPInfo APPVersion],
                                 @"phone" : self.accountCell.textField.text,
                                 @"password" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text],
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPRegisterURL parameters:parameters success:^(id success)
    {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [WPUserInfor sharedWPUserInfor].clientId = [NSString stringWithFormat:@"%@", result[@"clientId"]];
            //  如果不是当前账户，还原初始设置
            if (![[WPUserInfor sharedWPUserInfor].userPhone isEqualToString:weakSelf.accountCell.textField.text])
            {
                [WPUserInfor sharedWPUserInfor].userPhone = weakSelf.accountCell.textField.text;
                [WPUserInfor sharedWPUserInfor].approvePassType = nil;
                [WPUserInfor sharedWPUserInfor].payPasswordType = nil;
                [WPUserInfor sharedWPUserInfor].shopPassType = nil;
                [WPUserInfor sharedWPUserInfor].isSubAccount = nil;
                [WPUserInfor sharedWPUserInfor].payTouchID = nil;
                [WPUserInfor sharedWPUserInfor].registerTouchID = nil;
                [WPUserInfor sharedWPUserInfor].isRemindTouchID = nil;
                
                [WPKeyChainTool keyChainDelete];
            }
            if ([result[@"isClerk"] isEqualToString:@"yes"]) //子账户
            {
                [WPUserInfor sharedWPUserInfor].isSubAccount = @"YES";
            }
            else
            {
                [WPUserInfor sharedWPUserInfor].isSubAccount = nil;
            }
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            
            // 注册激光推送别名
            NSString *userId = [NSString stringWithFormat:@"%@", result[@"mer_id"]];

            [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq)
            {
                if (iResCode == 0)//对应的状态码返回为0，代表成功
                {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
                }
                
            } seq:1];
            
            [weakSelf start];
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
