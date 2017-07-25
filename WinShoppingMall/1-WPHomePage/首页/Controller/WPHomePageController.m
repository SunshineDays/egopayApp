//
//  WPHomePageController.m
//  WinShoppingMall
//  主页
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPHomePageController.h"
#import "WPBillController.h"
#import "WPMerchantController.h"
#import "WPGatheringController.h"
#import "WPQRCodeController.h"
#import "WPRegisterController.h"
#import "Header.h"
#import <SDCycleScrollView.h>
#import "WPGatheringCodeController.h"
#import "WPJpushServiceController.h"
#import "WPMessagesCell.h"
#import "WPMessageDetailController.h"
#import "WPUserRechargeController.h"
#import "WPUserWithDrawController.h"
#import "WPUserTransferController.h"
#import "WPUserCreditCardPayController.h"
#import "WPShareModel.h"
#import "WPHomePageView.h"

static NSString * const WPMessagesCellID = @"WPMessagesCellID";


@interface WPHomePageController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPHomePageView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WPShareModel *shareModel;


@end

@implementation WPHomePageController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  3DTouch跳转到我的收款码
    if ([[WPUserInfor sharedWPUserInfor].threeTouch isEqualToString:@"gatheringCode"])
    {
        __weakSelf
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeType = 2;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].userInfoDict = nil;
            [WPUserInfor sharedWPUserInfor].threeTouch = nil;
        });
    }
    //  推送受到的字典消息
    else if ([WPUserInfor sharedWPUserInfor].userInfoDict)
    {
        __weakSelf
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WPJpushServiceController *vc = [[WPJpushServiceController alloc] init];
            vc.resultDict = [WPUserInfor sharedWPUserInfor].userInfoDict;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].threeTouch = nil;
            [WPUserInfor sharedWPUserInfor].userInfoDict = nil;
        });
    }

    [self headerView];
    [self getmessgaesData];
    [self getCycleScrollData];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getmessgaesData];
        [weakSelf getCycleScrollData];
        if (weakSelf.shareModel.webpageUrl.length == 0)
        {
            [weakSelf getShareData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    if (self.shareModel.webpageUrl.length == 0)
    {
        [self getShareData];
    }
}

#pragma mark - Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WPHomePageView *)headerView
{
    if (!_headerView) {
        _headerView = [[WPHomePageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2 + 200 + 80)];
        
        for (int i = 0; i < 8; i++)
        {
            WPHomePageClassButton *homeButton = _headerView.classView.subviews[i];
            homeButton.tag = i;
            [homeButton addTarget:self action:@selector(topClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_headerView.creditButton addTarget:self action:@selector(creditCardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMessagesCell class]) bundle:nil] forCellReuseIdentifier:WPMessagesCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMessagesCellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPMessagesModel *model = self.dataArray[indexPath.row];
    WPMessageDetailController *vc =[[WPMessageDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)topClassButtonClick:(WPHomePageClassButton *)button
{
    switch (button.tag)
    {
        case 0:// 充值
        {
            WPUserRechargeController *vc = [[WPUserRechargeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:// 提现
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                WPUserWithDrawController *vc = [[WPUserWithDrawController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 2:// 账单
        {
            WPBillController *vc = [[WPBillController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:// 扫码
        {
            [WPProgressHUD showInfoWithStatus:@"敬请期待"];
//            WPQRCodeController *vc = [[WPQRCodeController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:// 商户
        {
            WPMerchantController *vc= [[WPMerchantController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:// 收款
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                WPGatheringController *vc = [[WPGatheringController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 6:// 转账
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                WPUserTransferController *vc = [[WPUserTransferController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 7:// 推荐
        {
            [WPHelpTool shareToAppWithModel:self.shareModel navigationController:self.navigationController];
            break;
        }
        default:
            break;
    }
}

- (void)creditCardButtonClick
{
    if ([WPJudgeTool isIDCardApprove])
    {
        WPUserCreditCardPayController *vc = [[WPUserCreditCardPayController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
    }
}

#pragma mark - Data

- (void)getCycleScrollData
{
    NSDictionary *parameters = @{
                                 @"bannerCode" : @"1"
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPCycleScrollURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.headerView.cycleScrollView.localizationImageNamesGroup = result[@"home_banner"];
            [weakSelf.headerView.cycleScrollView reloadInputViews];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)getmessgaesData
{
    
    NSDictionary *parameters = @{
                                 @"curPage" : @"1"
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPMessageURL parameters:parameters success:^(id success)
    {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:[WPMessagesModel mj_objectArrayWithKeyValuesArray:result[@"msgList"]]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [WPProgressHUD showInfoWithStatus:@"网络错误,请重试"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
