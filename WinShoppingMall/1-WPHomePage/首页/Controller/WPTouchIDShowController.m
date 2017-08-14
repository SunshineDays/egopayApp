//
//  WPTouchIDShowController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/18.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPTouchIDShowController.h"
#import "Header.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WPTabBarController.h"
#import "WPRegisterController.h"
#import "WPJpushServiceController.h"
#import "WPPayCodeController.h"
#import "WPNavigationController.h"
#import "WPUserEnrollController.h"

@interface WPTouchIDShowController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *touchButton;

@property (nonatomic, strong) UIImageView *touchIDImageView;

@property (nonatomic, strong) UILabel *buttonLabel;

@property (nonatomic, strong) UIButton *otherWayButton;

@end

@implementation WPTouchIDShowController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showTouchIDView];
    [self titleLabel];
    [self touchButton];
    [self buttonLabel];
    [self otherWayButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Init

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, WPNavigationHeight)];
        _titleLabel.text = @"欢迎回来";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:25];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)touchButton
{
    if (!_touchButton) {
        _touchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50)];
        [_touchButton addTarget:self action:@selector(touchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_touchButton];
    }
    return _touchButton;
}

- (UIImageView *)touchIDImageView
{
    if (!_touchIDImageView) {
        _touchIDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight / 2 - 50, 100, 100)];
        _touchIDImageView.image = [UIImage imageNamed:@"touchID"];
        [self.view addSubview:_touchIDImageView];
    }
    return _touchIDImageView;
}

- (UILabel *)buttonLabel
{
    if (!_buttonLabel) {
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.touchIDImageView.frame), kScreenWidth, 50)];
        _buttonLabel.text = @"点击验证指纹登录";
        _buttonLabel.textColor = [UIColor themeColor];
        _buttonLabel.textAlignment = NSTextAlignmentCenter;
        _buttonLabel.font = [UIFont systemFontOfSize:17];
        _buttonLabel.numberOfLines = 0;
        [self.view addSubview:_buttonLabel];
    }
    return _buttonLabel;
}

- (UIButton *)otherWayButton
{
    if (!_otherWayButton) {
        _otherWayButton  = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - WPLeftMargin - 100, kScreenHeight - 50, 100, 50)];
        [_otherWayButton setTitle:@"切换登录方式" forState:UIControlStateNormal];
        [_otherWayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _otherWayButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _otherWayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_otherWayButton addTarget:self action:@selector(otherWayButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_otherWayButton];
        
    }
    return _otherWayButton;
}

#pragma mark - Action

- (void)touchButtonClick:(UIButton *)button
{
    [self showTouchIDView];
}

- (void)showTouchIDView
{
    __weakSelf
    [WPPayTool payWithTouchIDsuccess:^(id success)
    {
        [WPHelpTool rootViewController:[[WPTabBarController alloc] init]];
        
    } failure:^(NSError *error)
    {
        [weakSelf otherWayButtonAction];
    }];
}

- (void)otherWayButtonAction
{
    WPRegisterController *vc = [[WPRegisterController alloc] init];
    WPNavigationController *navi = [[WPNavigationController alloc] initWithRootViewController:vc];
    [WPHelpTool rootViewController:navi];
    [WPUserInfor sharedWPUserInfor].clientId = nil;
    [[WPUserInfor sharedWPUserInfor] updateUserInfor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
