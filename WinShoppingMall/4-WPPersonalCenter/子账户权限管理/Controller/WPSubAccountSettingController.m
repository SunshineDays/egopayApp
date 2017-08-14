//
//  WPSubAccountSettingController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountSettingController.h"
#import "Header.h"
#import "WPSubAccountListController.h"
#import "WPSubAccountSettingModel.h"
#import "WPSubAccountChangePasswordController.h"

@interface WPSubAccountSettingController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *switchArray;

@end

@implementation WPSubAccountSettingController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = self.isFirst ? @"设置子账户权限" : self.clerkName;
    self.titleArray = @[@"今日收入", @"收款码", @"收款账单", @"账单消息", @"商家", @"系统消息", @"推荐", @"余额", @"银行卡"];
    if (self.isFirst)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popToViewController)];
        self.switchArray = [[NSMutableArray alloc] initWithArray:@[@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"0", @"0"]];
        
        [self initSubAccountSettingView];
        [self confirmButton];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingSubAccount)];
        self.switchArray = [[NSMutableArray alloc] init];
        [self getSubAccountJurisdictionData];
    }
}

#pragma mark - Init

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight - WPButtonHeight - 10)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = [NSString stringWithFormat:@"子账户登录ID：%@", self.clerkRegisterID];
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:16];
        [self.scrollView addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (void)initSubAccountSettingView
{
    for (int i = 0; i < self.titleArray.count; i++) {
        WPCustomRowCell *rowCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame) + (WPRowHeight + 10) * i, kScreenWidth, WPRowHeight);
        [rowCell rowCellTitle:self.titleArray[i] rectMake:rect];
        [rowCell.switchs setOn:[self.switchArray[i] isEqualToString:@"1"] ? YES : NO animated:YES];
        [rowCell.switchs addTarget:self action:@selector(rowCellAction:) forControlEvents:UIControlEventValueChanged];
        rowCell.switchs.tag = i;
        [self.scrollView addSubview:rowCell];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(rowCell.frame) + 10);
    }
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, kScreenHeight - WPNavigationHeight - WPButtonHeight - 10, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_confirmButton userInteractionEnabled:YES];
        [_confirmButton addTarget:self action:@selector(confirmButtonAtion) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)rowCellAction:(UISwitch *)sender
{
    for (int i = 0; i < self.titleArray.count; i++)
    {
        if (sender.tag == i)
        {
            [self.switchArray replaceObjectAtIndex:i withObject:[self.switchArray[i] isEqualToString: @"0"] ? @"1" : @"0"];
        }
    }
}

- (void)confirmButtonAtion
{
    [self postSubAccountSettingData];
}

- (void)popToViewController
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[WPSubAccountListController class]])
        {
            WPSubAccountListController *vc = (WPSubAccountListController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)settingSubAccount
{
    __weakSelf
    [WPHelpTool alertControllerTitle:nil rowOneTitle:@"删除子账户" rowTwoTitle:@"重置密码" rowOne:^(UIAlertAction *alertAction)
    {
        [WPHelpTool alertControllerTitle:@"确定删除该子账户" confirmTitle:@"删除" confirm:^(UIAlertAction *alertAction)
        {
            [weakSelf postSubAccountDeleteData];
        } cancel:nil];
    } rowTwo:^(UIAlertAction *alertAction)
    {
        WPSubAccountChangePasswordController *vc = [[WPSubAccountChangePasswordController alloc] init];
        vc.clerkID = weakSelf.clerkID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Data

- (void)getSubAccountJurisdictionData
{
    NSDictionary *parameters = @{@"clerkId" : self.clerkID};
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountJurisdictionURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            WPSubAccountSettingModel *model = [WPSubAccountSettingModel mj_objectWithKeyValues:result[@"resources"]];
            [weakSelf.switchArray addObjectsFromArray:@[model.today_income, model.qr_pic, model.qr_bill, model.bill_msgs, model.mer_shops, model.sys_msgs, model.refer_pps, model.balance, model.bankcards]];
            
            [weakSelf initSubAccountSettingView];
            [weakSelf confirmButton];
        }
        
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)postSubAccountSettingData
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObject:self.clerkID forKey:@"clerkId"];
    
    //@[@"今日收入", @"收款码", @"收款账单", @"账单消息", @"商家", @"系统消息", @"推荐", @"余额", @"银行卡"]
    NSArray *keyArray = @[@"today_income", @"qr_pic", @"qr_bill", @"bill_msgs", @"mer_shops", @"sys_msgs", @"refer_pps", @"balance", @"bankcards"];
    for (int i = 0; i < 9; i++)
    {
        [parameter addEntriesFromDictionary:@{keyArray[i] : self.switchArray[i]}];
    }
    
    __weakSelf
    [WPHelpTool postWithURL:WPSubAccountSettingURL parameters:parameter success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf popToViewController];
            [WPProgressHUD showSuccessWithStatus:@"设置成功"];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)postSubAccountDeleteData
{
    NSDictionary *parameters = @{@"clerkId" : self.clerkID};
    __weakSelf
    [WPHelpTool postWithURL:WPSubAccountDeleteURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.subAccountDeleteBlock)
            {
                weakSelf.subAccountDeleteBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [WPProgressHUD showSuccessWithStatus:@"删除成功"];
        }
    } failure:^(NSError *error)
    {
        
    }];
    
}

@end
