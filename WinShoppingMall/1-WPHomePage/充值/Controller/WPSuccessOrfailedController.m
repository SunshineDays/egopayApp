//
//  WPSuccessOrfailedController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSuccessOrfailedController.h"
#import "Header.h"
#import "WPPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface WPSuccessOrfailedController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation WPSuccessOrfailedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  此界面禁止使用右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self confirmButton];
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, WPTopY + 100, 100, 100)];
        _imageView.image = [UIImage imageNamed: self.showType == 2 ? @"icon_failure" : @"icon_selected_content1_n"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
};

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth, WPRowHeight)];
        
        if (!self.showType)
        {
            _titleLabel.text = @"提交成功";
        }
        else if (self.showType == 1)
        {
            _titleLabel.text = @"充值成功";
        }
        else if (self.showType == 2)
        {
        _titleLabel.text = @"充值失败";
        }
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, CGRectGetMaxY(self.titleLabel.frame) + 40, 120, 40)];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _confirmButton.layer.borderColor = [UIColor themeColor].CGColor;
        _confirmButton.layer.borderWidth = WPLineHeight;
        _confirmButton.layer.cornerRadius = WPCornerRadius;
        [_confirmButton addTarget:self action:@selector(confrimButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)confrimButtonClick:(UIButton *)button
{
    //  开启右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (![WPJudgeTool isPayTouchID] && ![[WPUserInfor sharedWPUserInfor].isRemindTouchID isEqualToString:@"YES"])
    {
        [self judgeTouchID];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Methods

- (void)judgeTouchID
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        __weakSelf
        [WPHelpTool alertControllerTitle:@"您的手机支持指纹识别,可以开通指纹支付" confirmTitle:@"开通" confirm:^(UIAlertAction *alertAction)
        {
            [WPUserInfor sharedWPUserInfor].payTouchID = @"YES";
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            [WPProgressHUD showSuccessWithStatus:@"开通成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } cancel:^(UIAlertAction *alertAction)
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [WPUserInfor sharedWPUserInfor].isRemindTouchID = @"YES";
    [[WPUserInfor sharedWPUserInfor] updateUserInfor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
