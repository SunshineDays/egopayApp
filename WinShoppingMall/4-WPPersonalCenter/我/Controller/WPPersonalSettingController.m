//
//  WPPersonalSettingController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPersonalSettingController.h"

#import "UIView+WPExtension.h"
#import "WPSelectController.h"
#import "WPRegisterController.h"
#import "Header.h"
#import "WPUserInforCell.h"
#import "WPTouchIDController.h"
#import "WPPublicWebViewController.h"
#import "WPUserFeedBackController.h"
#import <JPush/JPUSHService.h>
#import <StoreKit/StoreKit.h>
#import "WPNavigationController.h"
#import "WPUserInforButton.h"
#import "WPAPPInfo.h"
#import "WPAboutEgoopayController.h"

static NSString * const WPUSerInforCellID = @"WPUSerInforCellID";

@interface WPPersonalSettingController () <UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) WPButton *userLogoutButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation WPPersonalSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    
    NSString *titleString = [WPJudgeTool isSubAccount] ? [NSString stringWithFormat:@"账户号:  %@", [WPUserInfor sharedWPUserInfor].userPhone] : @"密码设置";
    
    self.titleArray = @[@[titleString, @"安全管理"], @[@"用户帮助", @"意见反馈", @"用户举报"], @[[NSString stringWithFormat:@"客服电话:  %@", WPAppTelNumber], @"关于"], @[@"退出登录"]];
    
    [self.tableView reloadData];
}

#pragma mark - Init

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPUserInforCell class]) bundle:nil] forCellReuseIdentifier:WPUSerInforCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPUserInforCell *cell = [tableView dequeueReusableCellWithIdentifier:WPUSerInforCellID];
    
    if (indexPath.section == self.titleArray.count - 1) {
        cell.contentLabel.text = self.titleArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0: {
            switch (indexPath.row)
            {
                case 0:  //子账户ID/修改密码
                {
                    if (![WPJudgeTool isSubAccount]) {
                        WPSelectController *vc = [[WPSelectController alloc] init];
                        vc.selectType = 1;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
                case 1:  //安全管理
                {
                    WPTouchIDController *vc = [[WPTouchIDController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:  //用户帮助
                {
                    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
                    vc.navigationItem.title = @"用户帮助";
                    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserHelpWebURL];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                case 1:  //意见反馈
                {
                    WPUserFeedBackController *vc = [[WPUserFeedBackController alloc] init];
                    vc.navigationItem.title = @"意见反馈";
                    vc.isFeedback = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                case 2:  //用户举报
                {
                    WPUserFeedBackController *vc = [[WPUserFeedBackController alloc] init];
                    vc.navigationItem.title = @"用户举报";
                    vc.isFeedback = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:  //客服电话
                {
                    [self.view callToNum:WPAppTelNumber];
                    break;
                }
                case 1:  //关于
                {
                    WPAboutEgoopayController *vc = [[WPAboutEgoopayController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                                    
                default:
                    break;
            }
            break;
        }
            
        case 3:
        {
            [self userLogout];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - Data

- (void)userLogout
{
    __weakSelf
    [WPHelpTool alertControllerTitle:@"确定退出登录" confirmTitle:@"确定" confirm:^(UIAlertAction *alertAction)
     {
         [weakSelf userQuitRegister];
         
     } cancel:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

