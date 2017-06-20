//
//  WPConfirmVerificationController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPConfirmVerificationController.h"

#import "Header.h"

#import "WPSuccessOrfailedController.h"

#import "WPBankCardController.h"
#import "WPPayTypeController.h"
#import "WPWithdrawController.h"
#import "WPProductSubmitController.h"
#import "WPTransferAccountsController.h"



@interface WPConfirmVerificationController ()

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) WPRowTableViewCell *verifiactionCell;

@property (nonatomic, strong) UIButton *getVerificationCodeButton;

@property (nonatomic, strong) WPButton *nextButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentTime;

@end

@implementation WPConfirmVerificationController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证手机号";

    self.currentTime = getVerificationCodeTime;
    [self hintLabel];
    [self verifiactionCell];
    [self getVerificationCodeButton];
    [self nextButton];
}

#pragma mark - Init

- (NSMutableDictionary *)cardInfoDict
{
    if (!_cardInfoDict) {
        _cardInfoDict = [NSMutableDictionary dictionary];
    }
    return _cardInfoDict;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _hintLabel.numberOfLines = 0;
        _hintLabel.text = [NSString stringWithFormat:@"验证码已经发送到：%@", self.cardInfoDict[@"phone"]];
        _hintLabel.font = [UIFont systemFontOfSize:13];
        _hintLabel.textColor = [UIColor blackColor];
        [self.view addSubview:_hintLabel];
    }
    return _hintLabel;
}

- (WPRowTableViewCell *)verifiactionCell {
    if (!_verifiactionCell) {
        _verifiactionCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.hintLabel.frame) + 10, kScreenWidth, WPRowHeight);
        [_verifiactionCell tableViewCellTitle:@"验证码" placeholder:@"六位数字验证码" rectMake:rect];
        _verifiactionCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_verifiactionCell];
    }
    return _verifiactionCell;
}

- (UIButton *)getVerificationCodeButton
{
    if (!_getVerificationCodeButton) {
        _getVerificationCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - WPLeftMargin - 100, CGRectGetMaxY(self.verifiactionCell.frame) + WPLineHeight, 100, WPRowHeight)];
        [_getVerificationCodeButton setTitle:@"收不到验证码" forState:UIControlStateNormal];
        [_getVerificationCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_getVerificationCodeButton];
    }
    return _getVerificationCodeButton;
}

- (WPButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.getVerificationCodeButton.frame) + 20, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_nextButton setTitle:@"提交" forState:UIControlStateNormal];

        [_nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

#pragma mark - Action

#pragma mark - 获取验证码
- (void)getVerificationCodeButtonClick:(UIButton *)button {
    [self timer];
    [self getVerificationData];
}

#pragma mark - 定时器
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)timerClick {
    if (self.currentTime == 0) {
        [self.getVerificationCodeButton setTitle:@"收不到验证码" forState:UIControlStateNormal];
        self.getVerificationCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.currentTime = getVerificationCodeTime;
    }
    else {
        self.currentTime--;
        [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",self.currentTime] forState:UIControlStateNormal];
        self.getVerificationCodeButton.userInteractionEnabled = NO;
    }
}

#pragma mark - 获取验证码
- (void)getVerificationData {
    
    NSDictionary *parameters = @{
                                 @"phone" : self.cardInfoDict[@"phone"],
                                 @"verType" : @"3"
                                 };
    
    __weakSelf
    [WPHelpTool postWithURL:WPGetMessageURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
            weakSelf.currentTime = 0;
            [weakSelf timerClick];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)nextButton:(UIButton *)button {
    if (self.verifiactionCell.textField.text.length != 6) {
        [WPProgressHUD showInfoWithStatus:@"验证码格式不正确"];
    }
    else {
        [self pushAddCardData];
    }
}

#pragma mark - 数据请求
- (void)pushAddCardData {
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    [self.cardInfoDict setObject:self.verifiactionCell.textField.text forKey:@"ver"];
    
    __weakSelf
    [WPHelpTool postWithURL:WPUserAddCardURL parameters:self.cardInfoDict success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"绑定成功,赶快点击卡片进行认证吧！"];
            
            [weakSelf.cardInfoDict setObject:result[@"cardId"] forKey:@"cardId"];
            NSDictionary *statusDict = [[NSDictionary alloc] initWithDictionary:self.cardInfoDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationAddCardSuccess object:nil userInfo:statusDict];
            
            [weakSelf chosePopToViewController];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        [WPProgressHUD dismiss];

    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}

#pragma mark - 选择返回的界面
- (void)chosePopToViewController {
    switch ([[WPUserInfor sharedWPUserInfor].popType intValue]) {
        case 1: {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WPBankCardController class]]) {
                    WPBankCardController *vc = (WPBankCardController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        case 2: {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WPPayTypeController class]]) {
                    WPPayTypeController *vc = (WPPayTypeController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        case 3: {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WPTransferAccountsController class]]) {
                    WPTransferAccountsController *vc = (WPTransferAccountsController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        case 4: {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WPProductSubmitController class]]) {
                    WPProductSubmitController *vc = (WPProductSubmitController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
