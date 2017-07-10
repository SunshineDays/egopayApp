//
//  WPUserFriendPhoneController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/29.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserFriendPhoneController.h"
#import "Header.h"

@interface WPUserFriendPhoneController ()

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPButton *confirmButton;

@end

@implementation WPUserFriendPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"转到易购付账户";
}

#pragma mark - Init

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"对方账户" placeholder:@"请输入对方手机号码" rectMake:rect];
        [_phoneCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.phoneCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.confirmButton userInteractionEnabled:self.phoneCell.textField.text.length > 6 ? YES : NO];
}

- (void)nextButtonAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
