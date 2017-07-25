//
//  WPSubAccountPersonalController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountPersonalController.h"
#import "WPRechargeCell.h"
#import "WPUserInforController.h"
#import "WPSubAccountPersonalModel.h"
#import "Header.h"
#import "WPRegisterController.h"
#import "WPUserInforButton.h"
#import "WPMessagesCenterController.h"
#import "WPGatheringCodeController.h"
#import "WPBillController.h"
#import "WPBankCardController.h"
#import "WPMerchantController.h"
#import "WPSubAccountInforController.h"
#import "WPShareModel.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPSubAccountPersonalController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WPUserInforButton *userInforButton;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WPSubAccountPersonalModel *model;

@property (nonatomic, strong) WPShareModel *shareModel;

@end

@implementation WPSubAccountPersonalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"我";
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getSubAccountInforData];
    }];
    [self.indicatorView startAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getSubAccountInforData];
    if (self.shareModel.webpageUrl.length == 0)
    {
        [self getShareData];
    }
}

#pragma mark - Init

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray
{
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
        
        [_userInforButton.userImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headUrl] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRefreshCached];

        
        [_userInforButton userInforWithName:[NSString stringWithFormat:@"商户号:  %@", self.model.merchant] vip:self.model.clerkName rate:nil arrowHidden:NO];
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
    if (!([self.imageArray[indexPath.row] isEqualToString:@"icon_yue_n"] || [self.imageArray[indexPath.row] isEqualToString:@"icon_duizhang_content_n"] || [self.imageArray[indexPath.row] isEqualToString:@"today_income"])) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
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

    if ([self.dataArray[indexPath.row] isEqualToString:@"收款码"])
    {
        WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
        vc.codeType = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"收款账单"])
    {
        WPBillController *vc = [[WPBillController alloc] init];
        vc.isCheck = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"银行卡"])
    {
        WPBankCardController *vc = [[WPBankCardController alloc] init];
        vc.showCardType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"商家"])
    {
        WPMerchantController *vc= [[WPMerchantController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"系统消息"])
    {
        WPMessagesCenterController *vc = [[WPMessagesCenterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"推荐"])
    {
        [WPHelpTool shareToAppWithModel:self.shareModel navigationController:self.navigationController];
    }
}

#pragma mark - Acition

- (void)userInfoButtonClick
{
    WPSubAccountInforController *vc = [[WPSubAccountInforController alloc] init];
    vc.subAccountModel = self.model;
    vc.avaterImage = self.userInforButton.userImageView.image;
    __weakSelf
    vc.avaterImageBlcok = ^(UIImage *avaterImage)
    {
        weakSelf.userInforButton.userImageView.image = avaterImage;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Data
- (void)getSubAccountInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountInforURL parameters:nil success:^(id success)
    {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.imageArray removeAllObjects];
            weakSelf.model = [WPSubAccountPersonalModel mj_objectWithKeyValues:result];
            NSString *balance = [NSString stringWithFormat:@"%.2f", weakSelf.model.avl_balance];
            NSString *todayQrIncome = [NSString stringWithFormat:@"%.2f", weakSelf.model.todayQrIncome];
            
            NSArray *dictKeyArray = @[@"balance", @"today_income", @"qr_pic", @"qr_bill", @"bankcards", @"mer_shops", @"sys_msgs", @"refer_pps"];
            NSArray *titleArray = @[[NSString stringWithFormat:@"主账户余额：%@(元)", balance], [NSString stringWithFormat:@"今日收入：%@(元)", todayQrIncome], @"收款码", @"收款账单", @"银行卡", @"商家", @"系统消息", @"推荐"];
            NSArray *imageArray = @[@"icon_yue_n", @"icon_duizhang_content_n", @"icon_shoukuanma_content_n",@"icon_zhangdan_content_n", @"icon_yinhang_n", @"icon_shangjiai_content_n", @"icon_xiaoxi_content_n", @"icon_tuijian_content_n"];
            for (int i = 0; i < dictKeyArray.count; i++)
            {
                if ([[NSString stringWithFormat:@"%@", weakSelf.model.resources[dictKeyArray[i]]] isEqualToString:@"1"])
                {
                    [weakSelf.dataArray addObject:titleArray[i]];
                    [weakSelf.imageArray addObject:imageArray[i]];
                }
            }
            [weakSelf userInforButton];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)getShareData
{
    __weakSelf
    [WPHelpTool getWithURL:WPShareToAppURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.shareModel = [WPShareModel mj_objectWithKeyValues:result];
        }
    } failure:^(NSError *error)
    {
    }];
}


@end
