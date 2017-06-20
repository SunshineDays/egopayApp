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
#import "JPUSHService.h"

@interface WPRegisterController ()<UITextViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:nil color:nil highColor:nil title:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:@selector(rightItemButtonClick) color:nil highColor:nil title:@"注册"];

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

- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"商户号登录", @"子账户登录"]];
        _segmentControl.frame = CGRectMake(WPLeftMargin, CGRectGetMaxY(self.imageView.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight);
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.tintColor = [UIColor themeColor];
        _segmentControl.clipsToBounds = YES;
        _segmentControl.layer.borderWidth = 1;
        _segmentControl.layer.borderColor = [UIColor lineColor].CGColor;
        _segmentControl.layer.cornerRadius = WPCornerRadius;
        _segmentControl.selectedSegmentIndex = 0;
        
        NSDictionary *selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor blackColor]};
        [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];

        NSDictionary *unselectedtextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor grayColor]};
        [self.segmentControl setTitleTextAttributes:unselectedtextAttributes forState:UIControlStateNormal];
        [self.view addSubview:self.segmentControl];
    }
    return _segmentControl;
}

- (WPRowTableViewCell *)accountCell
{
    if (!_accountCell) {
        _accountCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame) + 20, kScreenWidth, 60);
        [_accountCell tableViewCellTitle:nil placeholder:@"请输入手机号／账号" rectMake:rect];
        _accountCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_accountCell.lineView setFrame:CGRectMake(WPLeftMargin, WPRowHeight - WPLineHeight, kScreenWidth - WPLeftMargin, WPLineHeight)];
        if ([WPUserInfor sharedWPUserInfor].userPhone.length == 11) {
            self.accountCell.textField.text = [WPUserInfor sharedWPUserInfor].userPhone;
        }
        [self.view addSubview:_accountCell];
    }
    return _accountCell;
}

- (WPRowTableViewCell *)passwordCell
{
    if (!_passwordCell) {
        _passwordCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.accountCell.frame), kScreenWidth, 60);
        [_passwordCell tableViewCellTitle:nil placeholder:@"请输入登录密码" rectMake:rect];
        [_passwordCell.lineView setFrame:CGRectMake(WPLeftMargin, WPRowHeight - WPLineHeight, kScreenWidth - WPLeftMargin, WPLineHeight)];
        _passwordCell.textField.secureTextEntry = YES;
        [self.view addSubview:_passwordCell];
    }
    return _passwordCell;
}

- (WPButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.passwordCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_registerButton setTitle:@"登录" forState:UIControlStateNormal];
        _registerButton.backgroundColor = [UIColor themeColor];
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
        [_forgetPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetPasswordButton];
    }
    return _forgetPasswordButton;
}

#pragma mark - Action

- (void)rightItemButtonClick
{
    WPUserEnrollController *vc = [[WPUserEnrollController alloc] init];
    
    __weakSelf
    vc.userEnrollSuccessBlock = ^(NSDictionary *userEnrollDict) {
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
    
    if (![WPRegex validateMobile:self.accountCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
    else if (self.passwordCell.textField.text.length < 6) {
        [WPProgressHUD showInfoWithStatus:@"请输入密码"];
    }
    else {
        [self getData];
    }
}

- (void)forgetPasswordButtonClick
{
    WPPasswordController *vc = [[WPPasswordController alloc] init];
    vc.passwordType = @"1";
    vc.navigationItem.title = @"忘记密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)start
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[WPTabBarController alloc] init];
}

#pragma mark - Data

- (void)getData
{
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"phone" : self.accountCell.textField.text,
                                 @"password" : [WPPublicTool base64EncodeString:self.passwordCell.textField.text],
//                                 @"isSon" : [NSString stringWithFormat:@"%ld", self.segmentControl.selectedSegmentIndex]
                                 };
    
    __weakSelf
    [WPHelpTool postWithURL:WPRegisterURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPUserInfor sharedWPUserInfor].clientId = [NSString stringWithFormat:@"%@", result[@"clientId"]];
            //  如果不是当前账户，还原初始设置
            if (![[WPUserInfor sharedWPUserInfor].userPhone isEqualToString:weakSelf.accountCell.textField.text]) {
                [WPUserInfor sharedWPUserInfor].userPhone = weakSelf.accountCell.textField.text;
                [WPUserInfor sharedWPUserInfor].approvePassType = @"";
                [WPUserInfor sharedWPUserInfor].payPasswordType = @"";
                [WPUserInfor sharedWPUserInfor].shopPassType = @"";
                [WPUserInfor sharedWPUserInfor].codeUrl = @"";
                [WPUserInfor sharedWPUserInfor].needTouchID = @"2";
                [WPUserInfor sharedWPUserInfor].isSubAccount = @"";
                
                [WPKeyChainTool keyChainDelete];
            }
            //  如果是子账户
            if (self.segmentControl.selectedSegmentIndex == 1) {
                [WPUserInfor sharedWPUserInfor].needTouchID = @"";
                [WPUserInfor sharedWPUserInfor].isSubAccount = @"YES";
            }
            else {
                [WPUserInfor sharedWPUserInfor].needTouchID = @"2";
                [WPUserInfor sharedWPUserInfor].isSubAccount = @"";
            }
            
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            
            NSString *userId = [NSString stringWithFormat:@"%@", result[@"mer_id"]];
            [JPUSHService setTags:nil alias:userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
                //        NSLog(@"绑定和解绑rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
                if (iResCode == 0) {//对应的状态码返回为0，代表成功
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
                }
            }];
            
            [weakSelf start];
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


@end
