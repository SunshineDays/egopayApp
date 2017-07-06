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
#import "WPPayPopupController.h"
#import "WPUserEnrollController.h"
#import "WPPublicWebViewController.h"

@interface WPTouchIDController ()


@property (nonatomic, strong) UIImageView *touchIdImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *protocolLabel;

@property (nonatomic, strong) UIButton *protocolButton;

@property (nonatomic, strong) UILabel *touchIdLabel;

@property (nonatomic, strong) WPRowTableViewCell *registerCell;

@property (nonatomic, strong) WPRowTableViewCell *payCell;

@property (nonatomic, strong) UILabel *stateLabel;


@end

@implementation WPTouchIDController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"指纹";
    self.view.backgroundColor = [UIColor cellColor];
    
    [self touchIdImageView];
    [self protocolLabel];
    [self protocolButton];
    [self registerCell];
    if (![WPAppTool isSubAccount]) {
        [self payCell];
    }

    [self stateLabel];
}


#pragma mark - Init

- (UIImageView *)touchIdImageView {
    if (!_touchIdImageView) {
        _touchIdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, WPNavigationHeight + 30, 100, 103)];
        _touchIdImageView.image = [UIImage imageNamed:@"touchID"];
        [self.view addSubview:_touchIdImageView];
    }
    return _touchIdImageView;
}

- (UILabel *)titleLabel {
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

- (UILabel *)protocolLabel {
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

- (UIButton *)protocolButton {
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

- (WPRowTableViewCell *)registerCell {
    if (!_registerCell) {
        _registerCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.protocolLabel.frame) + 5, kScreenWidth, WPRowHeight);
        [_registerCell tableViewCellTitle:@"指纹登录" rectMake:rect];
        _registerCell.switchs.on = [WPAppTool isRegisterTouchID];
        [_registerCell.switchs addTarget:self action:@selector(registerSwitchClick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_registerCell];
    }
    return _registerCell;
}

- (WPRowTableViewCell *)payCell {
    if (!_payCell) {
        _payCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.registerCell.frame), kScreenWidth, WPRowHeight);
        [_payCell tableViewCellTitle:@"指纹支付" rectMake:rect];
        _payCell.switchs.on = [WPAppTool isPayTouchID];
        [_payCell.switchs addTarget:self action:@selector(paySwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        _payCell.hidden = [WPAppTool isSubAccount] ? YES : NO;
        [self.view addSubview:_payCell];
    }
    return _payCell;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [WPAppTool isSubAccount] ? CGRectGetMaxY(self.registerCell.frame) + 20 : CGRectGetMaxY(self.payCell.frame) + 20, kScreenWidth, 30)];
        _stateLabel.text = @"开通后，可使用Touch ID验证指纹快速完成登录或支付";
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (void)createPayPopupView {
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = @"绑定/解绑指纹支付";
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        [weakSelf postAddTouchIDDataWithPassword:payPassword];
    };
    vc.forgetPasswordBlock = ^{
        WPPasswordController *vc = [[WPPasswordController alloc] init];
        vc.passwordType = @"2";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self.payCell.switchs setOn:!self.payCell.switchs.on];
}

#pragma mark - Action

- (void)protocolButtonClick:(UIButton *)button {
    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
    vc.navigationItem.title = @"易购付指纹相关协议";
    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPTouchIDWebURL];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerSwitchClick:(UISwitch *)click {
    [self judgeTouchIDWithSwitchIsOn:[click isOn] type:1];
}

- (void)paySwitchClick:(UISwitch *)click {
    
    if ([WPAppTool isHavePayPassword]) {
        [self createPayPopupView];
    }
    else {
        __weakSelf
        [WPHelpTool alertControllerTitle:@"您还没有设置支付密码" confirmTitle:@"设置支付密码" confirm:^(UIAlertAction *alertAction) {
            WPPasswordController *vc = [[WPPasswordController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } cancel:nil];
    }
}

#pragma mark - Data

- (void)postAddTouchIDDataWithPassword:(NSString *)payPassword {
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPAddTouchIDPayPasswordURL parameters:parameters success:^(id success) {
        

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [weakSelf judgeTouchIDWithSwitchIsOn:weakSelf.payCell.switchs.on type:2];
            [WPKeyChainTool keyChainSave:payPassword forKey:kUserPayPassword];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)judgeTouchIDWithSwitchIsOn:(BOOL)switchIsOn type:(int)type
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [WPProgressHUD showSuccessWithStatus:@"设置成功"];
        switch (type) {
            case 1: {
                [WPUserInfor sharedWPUserInfor].registerTouchID = switchIsOn ? @"YES" : @"NO";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            }
                break;
                
            case 2: {
                [self.payCell.switchs setOn:!switchIsOn];
                [WPUserInfor sharedWPUserInfor].payTouchID = !switchIsOn ? @"YES" : @"NO";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        [WPProgressHUD showInfoWithStatus:@"您的设备不支持指纹识别"];
        [self.payCell.switchs setOn:NO];
        [self.registerCell.switchs setOn:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
