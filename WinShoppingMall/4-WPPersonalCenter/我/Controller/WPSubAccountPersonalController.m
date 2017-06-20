//
//  WPSubAccountPersonalController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountPersonalController.h"
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
#import "WPWithdrawController.h"
#import "WPUserLoadIDCardPhotoController.h"
#import "WPMerchantPhotoController.h"
#import "WPUserMoneyController.h"
#import "WPUserInforButton.h"
#import "WPMessagesCenterController.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPSubAccountPersonalController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WPUserInforButton *userInforButton;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WPEditUserInfoModel *model;

@property (nonatomic, copy) NSString *moneyString;

@end

@implementation WPSubAccountPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"我";
    self.navigationItem.leftBarButtonItem =nil;
    
    [self.indicatorView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserAvater:) name:WPNotificationChangeUserInfor object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getUserInforData];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
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
        _userInforButton.userImageView.image = [UIImage imageWithData:data];
        if (!_userInforButton.userImageView.image) {
            _userInforButton.userImageView.image = [UIImage imageNamed:@"titlePlaceholderImage"];
        }
        NSArray *lvArray = @[@"白银会员", @"黄金会员", @"铂金会员", @"钻石会员"];
        [_userInforButton userInforWithName:self.model.phone vip:lvArray[self.model.merchantlvid - 1] rate:nil arrowHidden:NO];
    }
    return _userInforButton;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.userInforButton;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
    cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.bankNameLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0: {  //余额
            if ([[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
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
            
        }
            break;
            
        case 3: {  //商家认证
            
        }
            break;
            
        case 4: {  //商户升级
            
        }
            break;
            
        case 5: {  //子账户
            
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

- (void)userInfoButtonClick {
    WPUserInforController *vc = [[WPUserInforController alloc] init];
    vc.model = self.model;
    vc.avaterImage = self.userInforButton.userImageView.image;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userAvatarImageViewClick {
    
}

- (void)refreshUserAvater:(NSNotification *)notific {
    if (notific.userInfo) {
        self.userInforButton.userImageView.image = notific.userInfo[@"avatarImage"];
    }
    [self getUserInforData];
}

#pragma mark - Data
- (void)getUserInforData {
    
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.dataArray removeAllObjects];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            weakSelf.model = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            NSString *money = [NSString stringWithFormat:@"余额  %.2f元", weakSelf.model.avl_balance];
            [self.imageArray addObjectsFromArray:@[@"icon_yue_n", @"icon_yinhang_n", @"icon_shiming_n", @"icon_shangjiarenzheng_n", @"icon_shanghushengji_n", @"icon_shanghushengji_n", @"icon_xiaoxi_content_n"]];
            [weakSelf.dataArray addObjectsFromArray:@[@"今日收入", @"收款码", @"对账", @"商家", @"银行卡", @"消息中心", @"推荐"]];
            
            [weakSelf.tableView reloadData];
        }
        else if ([type isEqualToString:@"-1"]) {
            [weakSelf userRegisterAgain];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.indicatorView stopAnimating];
    }];
}


@end
