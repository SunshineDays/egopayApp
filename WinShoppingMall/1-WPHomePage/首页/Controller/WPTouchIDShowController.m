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
#import "WPGatheringCodeController.h"
#import "WPNavigationController.h"

@interface WPTouchIDShowController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *touchButton;

@property (nonatomic, strong) UIImageView *touchIDImageView;


@property (nonatomic, strong) UILabel *buttonLabel;

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
        _touchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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

#pragma mark - Action

- (void)touchButtonClick:(UIButton *)button
{
    [self showTouchIDView];
}

- (void)showTouchIDView
{
    [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
        [WPHelpTool rootViewController:[[WPTabBarController alloc] init]];
        
    } failure:^(NSError *error) {
        WPRegisterController *vc = [[WPRegisterController alloc] init];
        WPNavigationController *navi = [[WPNavigationController alloc] initWithRootViewController:vc];
        [WPHelpTool rootViewController:navi];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
