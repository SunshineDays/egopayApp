//
//  WPPersonalController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPersonalController.h"

#import "WPRechargeCell.h"
#import "WPAutonymApproveController.h"
#import "WPUserMoneyController.h"
#import "WPBankCardController.h"
#import "WPMerchantUploadController.h"
#import "WPApproveLoadPhotoController.h"
#import "WPUserInforsController.h"
#import "WPProductSubmitController.h"
#import "WPProductController.h"
#import "WPUserInforModel.h"
#import "Header.h"
#import "WPRegisterController.h"
#import "WPMerchantPhotoController.h"
#import "WPUserMoneyController.h"
#import "WPMessagesCenterController.h"
#import "WPSubAccountListController.h"
#import "WPShareModel.h"
#import "WPPersonalCenterCell.h"
#import "WPPersonalButton.h"
#import "WPPersonalSettingController.h"
#import "WPBillController.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";
static NSString * const WPPersonalCenterCellID = @"WPPersonalCenterCellID";

@interface WPPersonalController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WPPersonalButton *headerButton;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *contentArray;

@property (nonatomic, strong) WPUserInforModel *model;

@property (nonatomic, copy) NSString *moneyString;

@property (nonatomic, strong) WPShareModel *shareModel;

@end

@implementation WPPersonalController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    
    self.titleArray = @[@[@"我的积分"], @[@"账单", @"余额", @"银行卡"], @[@"子账户", @"商户升级"],@[@"系统消息", @"分享易购付"]];
    self.imageArray = @[@[@"icon_tixian_content_n"], @[@"icon_zhangdan_content_n", @"icon_yue_n", @"icon_yinhang_n"], @[@"icon_shanghushengji_n", @"icon_shanghu_n"], @[@"icon_xiaoxi_content_n" ,@"icon_tuijian_content_n"]];
    
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
    
    [self getUserInforData];
    if (self.shareModel.webpageUrl.length == 0) {
        [self getShareData];
    }
}


#pragma mark - Init

- (WPPersonalButton *)headerButton
{
    if (!_headerButton) {
        _headerButton = [[WPPersonalButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95) avaterUrl:self.model.picurl phone:self.model.phone vip:[WPUserTool userMemberVipWithMerchantlvID:self.model.merchantlvid]];
        [_headerButton addTarget:self action:@selector(personalButonAction) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableHeaderView = _headerButton;

    }
    return _headerButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPPersonalCenterCell class]) bundle:nil] forCellReuseIdentifier:WPPersonalCenterCellID];
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
    WPPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:WPPersonalCenterCellID];
    cell.titleImageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
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
        case 0: //我的积分
        {
            
            break;
        }
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0: //账单
                {
                    WPBillController *vc = [[WPBillController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    break;
                }
                    
                case 1: //余额
                {
                    if ([WPJudgeTool isIDCardApprove])
                    {
                        WPUserMoneyController *vc = [[WPUserMoneyController alloc] init];
                        vc.model = self.model;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                    }
                    break;
                }
                    
                case 2: //银行卡
                {
                    WPBankCardController *vc = [[WPBankCardController alloc] init];
                    vc.showCardType = @"1";
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
                case 0: //子账户
                {
                    if ([WPJudgeTool isIDCardApprove])
                    {
                        WPSubAccountListController *vc = [[WPSubAccountListController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                    }
                    break;
                }
                    
                case 1: //商户升级
                {
                    if ([WPJudgeTool isIDCardApprove])
                    {
                        WPProductController *vc = [[WPProductController alloc] init];
                        vc.navigationItem.title = @"商户升级";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 3:
        {
            switch (indexPath.row)
            {
                case 0:  // 消息
                {
                    WPMessagesCenterController *vc = [[WPMessagesCenterController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                case 1: //分享
                {
                    [WPHelpTool shareToAppWithModel:self.shareModel];
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Acition

- (void)rightItemAction
{
    WPPersonalSettingController *vc = [[WPPersonalSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)personalButonAction
{
    WPUserInforsController *vc = [[WPUserInforsController alloc] init];
    vc.model = self.model;
    __weakSelf
    vc.avaterBlock = ^(UIImage *avaterImage) {
        weakSelf.headerButton.avaterImageView.image = avaterImage;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Data

- (void)getUserInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         NSDictionary *result = success[@"result"];
         
         if ([type isEqualToString:@"1"])
         {
             weakSelf.model = [WPUserInforModel mj_objectWithKeyValues:result];
             NSString *money = [NSString stringWithFormat:@"%.2f元", weakSelf.model.avl_balance];
             
             self.contentArray = @[@[@""], @[@"", money, @""], @[@"", @""], @[@"", @""]];
             
             [weakSelf headerButton];
             weakSelf.headerButton.vipLabel.text = [WPUserTool userMemberVipWithMerchantlvID:weakSelf.model.merchantlvid];
             [weakSelf.headerButton.imageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.picurl] placeholderImage:nil options:SDWebImageRefreshCached];
         }
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.tableView reloadData];
         [weakSelf.indicatorView stopAnimating];
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
