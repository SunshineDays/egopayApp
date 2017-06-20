//
//  WPAutonymApproveController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAutonymApproveController.h"
#import "WPUserLoadIDCardPhotoController.h"
#import "Header.h"

@interface WPAutonymApproveController ()


@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) WPRowTableViewCell *userNameCell;

@property (nonatomic, strong) WPRowTableViewCell *userIDNumberCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIDNumber;

//  用户认证状态
@property (nonatomic, copy) NSString *userApproveState;

@end

@implementation WPAutonymApproveController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    [self getUserApproveData];
}

#pragma mark - Init

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth - WPLeftMargin * 2, WPRowHeight)];
        _stateLabel.text = self.userApproveState;
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (WPRowTableViewCell *)userNameCell
{
    if (!_userNameCell) {
        _userNameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame), kScreenWidth, WPRowHeight);
        [_userNameCell tableViewCellTitle:@"姓        名" placeholder:self.userName rectMake:rect];
        [self.view addSubview:_userNameCell];
    }
    return _userNameCell;
}

- (WPRowTableViewCell *)userIDNumberCell
{
    if (!_userIDNumberCell) {
        _userIDNumberCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.userNameCell.frame), kScreenWidth, WPRowHeight);
        [_userIDNumberCell tableViewCellTitle:@"身份证号" placeholder:self.userIDNumber rectMake:rect];
        [self.view addSubview:_userIDNumberCell];
    }
    return _userIDNumberCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.userIDNumberCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(userLoadIDCardPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)userLoadIDCardPhotoButtonClick
{
    
    if ([self.userApproveState isEqualToString:@"请完善您的身份证照片信息"]) {
        [self pushUserInforData];
    }
    else {
        if (self.userNameCell.textField.text.length == 0) {
            [WPProgressHUD showInfoWithStatus:@"请输入姓名"];
        }
        else if (![WPRegex validateIDCard:self.userIDNumberCell.textField.text]) {
            [WPProgressHUD showInfoWithStatus:@"您输入的身份证号码有误"];
        }
        else {
            [self pushUserInforData];
        }
    }
}

#pragma mark - Methods

- (void)userIdCardApproveState:(NSString *)state
{
    switch ([state intValue]) {
        case 1: { //认证成功
            self.userApproveState = @"已认证";
            self.userNameCell.textField.enabled = NO;
            self.userIDNumberCell.textField.enabled = NO;
            self.confirmButton.hidden = YES;
        }
            break;
            
        case 2: { //认证失败
            self.userApproveState = @"认证失败";
            self.userName = @"请输入您的真实姓名";
            self.userIDNumber = @"请输入您的身份证号码";
        }
            break;
            
        case 3: { //认证中
            self.userApproveState = @"认证中";
            self.userNameCell.textField.enabled = NO;
            self.userIDNumberCell.textField.enabled = NO;
            self.confirmButton.hidden = YES;
        }
            break;
            
        case 4: { //身份证号已上传，照片未上传
            self.userApproveState = @"请完善您的身份证照片信息";
            self.userNameCell.textField.enabled = NO;
            self.userIDNumberCell.textField.enabled = NO;
        }
            break;
            
        default:
            break;
    }
    [self confirmButton];
}

#pragma mark - Data

- (void)getUserApproveData
{

    __weakSelf
    [WPHelpTool getWithURL:WPUserApproveIDCardPassURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            
            weakSelf.userName = [WPPublicTool stringHiddenWithString:result[@"fullName"] headerIndex:1 footerIndex:0];
            weakSelf.userIDNumber = [WPPublicTool stringHiddenWithString:[WPPublicTool base64DecodeString:result[@"identityCard"]] headerIndex:3 footerIndex:2];
            
            NSString *state = [NSString stringWithFormat:@"%@", result[@"state"]];
            [weakSelf userIdCardApproveState:state];
        }
        else if ([type isEqualToString:@"2"]) {
            weakSelf.userApproveState = @"请务必提交您的真实信息哦！";
            weakSelf.userName = @"请输入您的真实姓名";
            weakSelf.userIDNumber = @"请输入您的身份证号码";
            [weakSelf confirmButton];
        }
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)pushUserInforData
{
    NSDictionary *parameters = @{
                                 @"identityCard" : [WPPublicTool base64EncodeString:self.userIDNumberCell.textField.text],
                                 @"fullName" : self.userNameCell.textField.text
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPUserApproveIDCardURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            WPUserLoadIDCardPhotoController *vc = [[WPUserLoadIDCardPhotoController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
