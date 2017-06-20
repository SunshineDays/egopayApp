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

@interface WPTouchIDShowController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *touchButton;

@property (nonatomic, strong) UILabel *buttonLabel;

@end

@implementation WPTouchIDShowController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showSystemPassword];
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
        _touchButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight / 2 - 50, 100, 100)];
        [_touchButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
        [_touchButton addTarget:self action:@selector(touchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_touchButton];
    }
    return _touchButton;
}

- (UILabel *)buttonLabel
{
    if (!_buttonLabel) {
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.touchButton.frame), kScreenWidth, 50)];
        _buttonLabel.text = @"点击登录";
        _buttonLabel.textColor = [UIColor themeColor];
        _buttonLabel.textAlignment = NSTextAlignmentCenter;
        _buttonLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:_buttonLabel];
    }
    return _buttonLabel;
}

#pragma mark - Action

- (void)touchButtonClick:(UIButton *)button
{
    [self showSystemPassword];
}

- (void)showSystemPassword
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
//    __weakSelf
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //验证成功，主线程处理UI
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[WPTabBarController alloc] init];
//                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
