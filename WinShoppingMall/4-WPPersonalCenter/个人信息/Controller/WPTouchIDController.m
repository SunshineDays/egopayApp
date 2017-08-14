//
//  WPTouchIDController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPTouchIDController.h"
#import "Header.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WPUserEnrollController.h"
#import "WPPublicWebViewController.h"

@interface WPTouchIDController ()


@property (nonatomic, strong) UIImageView *touchIdImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *protocolLabel;

@property (nonatomic, strong) UIButton *protocolButton;

@property (nonatomic, strong) UILabel *touchIdLabel;

@property (nonatomic, strong) WPCustomRowCell *registerCell;

@property (nonatomic, strong) WPCustomRowCell *payCell;

@property (nonatomic, strong) UILabel *stateLabel;

/**  记录开始的指纹支付开启状态 */
@property (nonatomic, assign) BOOL isOpenPay;

@end

@implementation WPTouchIDController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"指纹";
    self.view.backgroundColor = [UIColor cellColor];
    
    [self touchIdImageView];
    [self protocolLabel];
    [self protocolButton];
    [self registerCell];
    if (![WPJudgeTool isSubAccount])
    {
        [self payCell];
    }

    [self stateLabel];
}


#pragma mark - Init

- (UIImageView *)touchIdImageView
{
    if (!_touchIdImageView) {
        _touchIdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, WPTopY + 30, 100, 103)];
        _touchIdImageView.image = [UIImage imageNamed:@"touchID"];
        [self.view addSubview:_touchIdImageView];
    }
    return _touchIdImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.touchIdImageView.frame), kScreenWidth, 30)];
        _titleLabel.text = @"指纹密码只对本机有效";
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)protocolLabel
{
    if (!_protocolLabel) {
        _protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth / 2, 30)];
        _protocolLabel.text = @"开通即视为同意";
        _protocolLabel.textColor = [UIColor grayColor];
        _protocolLabel.font = [UIFont systemFontOfSize:13];
        _protocolLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_protocolLabel];
    }
    return _protocolLabel;
}

- (UIButton *)protocolButton
{
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth / 2, 30)];
        [_protocolButton setTitle:@"《易购付指纹相关协议》" forState:UIControlStateNormal];
        [_protocolButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _protocolButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_protocolButton addTarget:self action:@selector(protocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_protocolButton];
    }
    return _protocolButton;
}

- (WPCustomRowCell *)registerCell
{
    if (!_registerCell) {
        _registerCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.protocolLabel.frame) + 5, kScreenWidth, WPRowHeight);
        [_registerCell rowCellTitle:@"指纹登录" rectMake:rect];
        _registerCell.switchs.on = [WPJudgeTool isRegisterTouchID];
        [_registerCell.switchs addTarget:self action:@selector(registerSwitchClick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_registerCell];
    }
    return _registerCell;
}

- (WPCustomRowCell *)payCell
{
    if (!_payCell) {
        _payCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.registerCell.frame), kScreenWidth, WPRowHeight);
        [_payCell rowCellTitle:@"指纹支付" rectMake:rect];
        _payCell.switchs.on = [WPJudgeTool isPayTouchID];
        self.isOpenPay = _payCell.switchs.on;
        [_payCell.switchs addTarget:self action:@selector(paySwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        _payCell.hidden = [WPJudgeTool isSubAccount] ? YES : NO;
        [self.view addSubview:_payCell];
    }
    return _payCell;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [WPJudgeTool isSubAccount] ? CGRectGetMaxY(self.registerCell.frame) + 10 : CGRectGetMaxY(self.payCell.frame) + 10, kScreenWidth, 30)];
        _stateLabel.text = @"开通后，可使用Touch ID验证指纹快速完成登录或支付";
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.numberOfLines = 0;
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (void)createPayPopupView
{
    __weakSelf
    [WPPayTool payWithViewTitle:@"绑定/解绑指纹支付" success:^(id success)
    {
        [weakSelf postAddTouchIDDataWithPassword:success];        
    }];
}

#pragma mark - Action

- (void)protocolButtonClick:(UIButton *)button
{
    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
    vc.navigationItem.title = @"易购付指纹相关协议";
    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPTouchIDWebURL];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerSwitchClick:(UISwitch *)click
{
    [self judgeTouchIDWithType:1];
}

- (void)paySwitchClick:(UISwitch *)click
{
    [self.payCell.switchs setOn:self.isOpenPay]; // 只有当通过密码验证以后才改变按钮状态
    if ([WPJudgeTool isPayPassword])
    {
        [self judgeTouchIDWithType:2];
    }
    else
    {
        __weakSelf
        [WPHelpTool alertControllerTitle:@"您还没有设置支付密码" confirmTitle:@"设置支付密码" confirm:^(UIAlertAction *alertAction)
        {
            WPPasswordController *vc = [[WPPasswordController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } cancel:nil];
    }
}

#pragma mark - Data

- (void)postAddTouchIDDataWithPassword:(NSString *)payPassword
{
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPAddTouchIDPayPasswordURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.payCell.switchs setOn:!weakSelf.isOpenPay];
            [WPKeyChainTool keyChainSave:payPassword forKey:kUserPayPassword];
            
            [WPUserInfor sharedWPUserInfor].payTouchID = weakSelf.payCell.switchs.on ? @"YES" : @"NO";
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            
            [WPProgressHUD showSuccessWithStatus:weakSelf.payCell.switchs.on ? @"开通成功" : @"已关闭"];
        }
    } failure:^(NSError *error)
    {
        
    }];
}


- (void)judgeTouchIDWithType:(int)type
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        switch (type)
        {
            case 1:
            {
                [WPUserInfor sharedWPUserInfor].registerTouchID = self.registerCell.switchs.on ? @"YES" : @"NO";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
                [WPProgressHUD showSuccessWithStatus:self.registerCell.switchs.on ? @"开通成功" : @"已关闭"];
                break;
            }
                
            case 2:
            {
                [self createPayPopupView];
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"您的设备不支持指纹识别"];
        [self.payCell.switchs setOn:NO];
        [self.registerCell.switchs setOn:NO];
        [WPUserInfor sharedWPUserInfor].registerTouchID = @"NO";
        [WPUserInfor sharedWPUserInfor].payTouchID = @"YES";
        [[WPUserInfor sharedWPUserInfor] updateUserInfor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
