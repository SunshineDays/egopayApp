//
//  WPSubAccountSettingController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountSettingController.h"
#import "Header.h"

@interface WPSubAccountSettingController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *switchArray;

@end

@implementation WPSubAccountSettingController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"子账户权限";
    self.titleArray = @[@"今日收入", @"收款码", @"收款账单", @"账单消息", @"商家", @"系统消息", @"推荐", @"余额", @"银行卡"];
    if (self.isFirst) {
        self.switchArray = [[NSMutableArray alloc] initWithArray:@[@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"0", @"0"]];
        [self initSubAccountView];
        [self confirmButton];
    }
    else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:@selector(deleteSubAccount) color:nil highColor:nil title:@"删除"];
        self.switchArray = [[NSMutableArray alloc] init];
        [self getSubAccountSettingData];
    }
}

#pragma mark - Init

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)initSubAccountView
{
    for (int i = 0; i < self.titleArray.count; i++) {
        WPRowTableViewCell *subAccountCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, 10 + (WPRowHeight + 10) * i, kScreenWidth, WPRowHeight);
        [subAccountCell tableViewCellTitle:self.titleArray[i] rectMake:rect];
        [subAccountCell.switchs setOn:[self.switchArray[i] isEqualToString:@"1"] ? YES : NO];
        subAccountCell.switchs.tag = i;
        [subAccountCell.switchs addTarget:self action:@selector(subAccountCellAction:) forControlEvents:UIControlEventValueChanged];
        
        [self.scrollView addSubview:subAccountCell];
    }
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, (WPRowHeight + 10) * self.titleArray.count + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAtion) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_confirmButton];
        
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.confirmButton.frame) + 10);
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)subAccountCellAction:(UISwitch *)sender
{
    for (int i = 0; i < self.titleArray.count; i++) {
        WPRowTableViewCell *rowCell = self.scrollView.subviews[i];
        if (sender.tag == i) {
            [self.switchArray replaceObjectAtIndex:i withObject:rowCell.switchs.isOn ? @"1" : @"0"];
        }
    }
}

- (void)confirmButtonAtion
{
    [self postSubAccountSettingData];
}

- (void)deleteSubAccount
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除该账户吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Data

- (void)getSubAccountSettingData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.switchArray addObjectsFromArray:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @""]];
            [self initSubAccountView];
            [self confirmButton];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)postSubAccountSettingData
{
    //@[@"今日收入", @"收款码", @"收款账单", @"账单消息", @"商家", @"系统消息", @"推荐", @"余额", @"银行卡"]
    __weakSelf
    NSDictionary *parameters = @{
                                 @"today_income" : self.switchArray[0],
                                 @"qr_pic" : self.switchArray[1],
                                 @"qr_bill" : self.switchArray[2],
                                 @"bill_msgs" : self.switchArray[3],
                                 @"mer_shops" : self.switchArray[4],
                                 @"sys_msgs" : self.switchArray[5],
                                 @"refer_pps" : self.switchArray[6],
                                 @"balance" : self.switchArray[7],
                                 @"bankCards" : self.switchArray[8]
                                 };
    [WPHelpTool postWithURL:WPUserInforURL parameters:parameters success:^(id success) {
        [WPProgressHUD showSuccessWithStatus:@"添加成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

- (void)postSubAccountDeleteData
{
    NSDictionary *parameters = @{};
    [WPHelpTool postWithURL:WPBaseURL parameters:parameters success:^(id success) {
        NSDictionary *result = success[@"result"];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
