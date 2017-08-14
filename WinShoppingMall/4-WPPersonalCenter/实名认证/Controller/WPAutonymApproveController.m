//
//  WPAutonymApproveController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAutonymApproveController.h"
#import "WPAutonymApproveStateController.h"
#import "Header.h"

@interface WPAutonymApproveController () <UITextFieldDelegate>

@property (nonatomic, strong) WPCustomRowCell *userNameCell;

@property (nonatomic, strong) WPCustomRowCell *userIDNumberCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPAutonymApproveController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    
    [self confirmButton];
}

#pragma mark - Init



- (WPCustomRowCell *)userNameCell
{
    if (!_userNameCell) {
        _userNameCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_userNameCell rowCellTitle:@"真实姓名" placeholder:@"请输入您的真实姓名" rectMake:rect];
        [_userNameCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        _userNameCell.textField.delegate = self;
        [self.view addSubview:_userNameCell];
    }
    return _userNameCell;
}

- (WPCustomRowCell *)userIDNumberCell
{
    if (!_userIDNumberCell) {
        _userIDNumberCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.userNameCell.frame), kScreenWidth, WPRowHeight);
        [_userIDNumberCell rowCellTitle:@"身份证号" placeholder:@"请输入你的身份证号码" rectMake:rect];
        [_userIDNumberCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        _userIDNumberCell.textField.delegate = self;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validateSpace:string];
}

#pragma mark - Action

- (void)changeButtonSurface
{
    BOOL isEnabled = (self.userNameCell.textField.text.length > 1 && self.userIDNumberCell.textField.text.length > 15) ? YES : NO;
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:isEnabled];
}

- (void)userLoadIDCardPhotoButtonClick
{

    if (self.userNameCell.textField.text.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入姓名"];
    }
    else if (![WPJudgeTool validateIDCard:self.userIDNumberCell.textField.text])
    {
        [WPProgressHUD showInfoWithStatus:@"您输入的身份证号码有误"];
    }
    else
    {
        WPAutonymApproveStateController *vc = [[WPAutonymApproveStateController alloc] init];
        vc.idCardDic = @{
                        @"identityCard" : [WPPublicTool base64EncodeString:self.userIDNumberCell.textField.text],
                        @"fullName" : self.userNameCell.textField.text
                        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
