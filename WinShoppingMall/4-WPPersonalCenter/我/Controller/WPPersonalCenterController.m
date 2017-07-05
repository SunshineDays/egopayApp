//
//  WPPersonalCenterController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPersonalCenterController.h"

#import "WPRechargeCell.h"
#import "WPAutonymApproveController.h"
#import "WPUserMoneyController.h"
#import "WPBankCardController.h"
#import "WPMerchantUploadController.h"
#import "WPUserLoadPhotoDetailController.h"
#import "WPUserInforController.h"
#import "WPProductSubmitController.h"
#import "WPProductController.h"
#import "WPEditUserInfoModel.h"
#import "WPStateController.h"
#import "Header.h"
#import "WPRegisterController.h"
#import "WPUserLoadIDCardPhotoController.h"
#import "WPMerchantPhotoController.h"
#import "WPUserMoneyController.h"
#import "WPUserInforButton.h"
#import "WPMessagesCenterController.h"
#import "WPSubAccountListController.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPPersonalCenterController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WPUserInforButton *userInforButton;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WPEditUserInfoModel *model;

@property (nonatomic, copy) NSString *moneyString;


@end

@implementation WPPersonalCenterController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"我";
    
    self.imageArray = @[@"icon_yue_n", @"icon_yinhang_n", @"icon_shiming_n", @"icon_shangjiarenzheng_n", @"icon_shanghushengji_n", @"icon_shanghu_n", @"icon_xiaoxi_content_n"];
    [self getUserInforData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserAvater:) name:WPNotificationChangeUserInfor object:nil];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getUserInforData];
    }];
    
    [self.indicatorView startAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WPUserInforButton *)userInforButton
{
    if (!_userInforButton) {
        _userInforButton = [[WPUserInforButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _userInforButton.backgroundColor = [UIColor whiteColor];
        [_userInforButton addTarget:self action:@selector(userInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.picurl]];
        _userInforButton.userImageView.image = data ? [UIImage imageWithData:data] : _userInforButton.userImageView.image;
        NSArray *lvArray = @[@"白银会员", @"黄金会员", @"铂金会员", @"钻石会员"];
        [_userInforButton userInforWithName:self.model.phone vip:lvArray[self.model.merchantlvid - 1] rate:nil arrowHidden:NO];
        self.tableView.tableHeaderView = _userInforButton;
    
    }
    return _userInforButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
    cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.bankNameLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {  //余额
            if ([WPAppTool isPassIDCardApprove]) {
                WPUserMoneyController *vc = [[WPUserMoneyController alloc] init];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
            
        case 1: {  //银行卡
            WPBankCardController *vc = [[WPBankCardController alloc] init];
            vc.showCardType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2: {  //实名认证
            WPAutonymApproveController *vc = [[WPAutonymApproveController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3: {  //商家认证
//            WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            if ([WPAppTool isPassIDCardApprove]) {
                if ([WPAppTool isPassShopApprove]) {
                    WPStateController *vc = [[WPStateController alloc] init];
                    vc.status = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    [self getStateData];
                }
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
            
        case 4: {  //商户升级
            if ([WPAppTool isPassIDCardApprove]) {
                WPProductController *vc = [[WPProductController alloc] init];
                vc.navigationItem.title = @"商户升级";
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
            
        case 5: {  //子账户
            if ([WPAppTool isPassIDCardApprove]) {
                WPSubAccountListController *vc = [[WPSubAccountListController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
            
        case 6: {  //消息
            WPMessagesCenterController *vc = [[WPMessagesCenterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Acition

- (void)userInfoButtonClick
{
    WPUserInforController *vc = [[WPUserInforController alloc] init];
    vc.model = self.model;
    vc.avaterImage = self.userInforButton.userImageView.image;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshUserAvater:(NSNotification *)notific
{
    if (notific.userInfo) {
        self.userInforButton.userImageView.image = notific.userInfo[@"avatarImage"];
    }
    [self getUserInforData];
}

#pragma mark - Data

- (void)getUserInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            weakSelf.model = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            NSString *money = [NSString stringWithFormat:@"余额：%.2f元", weakSelf.model.avl_balance];
            [weakSelf.dataArray addObjectsFromArray:@[money, @"银行卡", @"实名认证", @"商家认证", @"商户升级", @"子账户", @"系统消息"]];
            [weakSelf userInforButton];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)getStateData
{
    __weakSelf
    [WPHelpTool getWithURL:WPQueryShopStatusURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            
            // 1 成功 2 失败 3 认证中
            NSString *status = [NSString stringWithFormat:@"%@",result[@"status"]];
            if ([status isEqualToString:@"1"]) {
                [WPUserInfor sharedWPUserInfor].shopPassType = @"YES";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            }
            WPMerchantUploadController *merVc = [[WPMerchantUploadController alloc] init];
            merVc.failureString = result[@"msg"];
            
            WPStateController *stateVc = [[WPStateController alloc] init];
            stateVc.status = status;
            
            [weakSelf.navigationController pushViewController:[status isEqualToString:@"2"] ? merVc : stateVc animated:YES];
        }
        else {
            WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
