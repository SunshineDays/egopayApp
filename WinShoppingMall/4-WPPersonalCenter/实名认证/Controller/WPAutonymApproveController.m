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
        _stateLabel.text = @"请务必提交您的真实信息哦！";
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
        [_userNameCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
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
        [_userIDNumberCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
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

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:(self.userNameCell.textField.text.length >= 2 && self.userIDNumberCell.textField.text.length > 15) ? YES : NO];
}

- (void)userLoadIDCardPhotoButtonClick
{
    
    if ([self.stateLabel.text isEqualToString:@"请完善您的身份证照片信息"]) {
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

- (void)userIdCardApproveState:(int)state
{
    //  state = 1 认证成功 2认证失败 3认证中 4身份证号已上传，照片未上传
    NSArray *approveStateArray = @[@"已认证", @"认证失败，请重新提交身份信息", @"认证中", @"请完善您的身份证照片信息"];
    self.stateLabel.text = approveStateArray[state - 1];
    self.userNameCell.textField.enabled = state == 2 ? YES : NO;
    self.userIDNumberCell.textField.enabled = state == 2 ? YES : NO;
    self.confirmButton.hidden = (state == 1 || state == 3) ? YES : NO;
    if (state == 4) {
        [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:YES];
    }
}

#pragma mark - Data

- (void)getUserApproveData
{

    __weakSelf
    [WPHelpTool getWithURL:WPUserApproveIDCardPassURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            
            weakSelf.userName = [WPPublicTool stringWithStarString:result[@"fullName"] headerIndex:1 footerIndex:0];
            weakSelf.userIDNumber = [WPPublicTool stringWithStarString:[WPPublicTool base64DecodeString:result[@"identityCard"]] headerIndex:3 footerIndex:2];
            [self confirmButton];
            
            NSString *state = [NSString stringWithFormat:@"%@", result[@"state"]];
            [weakSelf userIdCardApproveState:[state intValue]];
        }
        else if ([type isEqualToString:@"2"]) {
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
        if ([type isEqualToString:@"1"]) {
            WPUserLoadIDCardPhotoController *vc = [[WPUserLoadIDCardPhotoController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
