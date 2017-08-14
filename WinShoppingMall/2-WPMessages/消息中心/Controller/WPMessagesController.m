//
//  WPMessagesController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMessagesController.h"
#import "Header.h"
#import "WPBillNotificationCell.h"
#import "WPBillDetailController.h"
#import "WPBillDetailController.h"
#import "WPBillModel.h"
#import "WPPayCodeController.h"
#import "WPJpushServiceController.h"
#import "WPMyCodeController.h"

static NSString * const WPBillNotificationCellID = @"WPBillNotificationCellID";


@interface WPMessagesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;


@end

@implementation WPMessagesController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"消息";
    
    if ([WPJudgeTool isSubAccount])
    {
        if ([[WPUserInfor sharedWPUserInfor].threeTouch isEqualToString:@"gatheringCode"])
        {
            __weakSelf
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                WPMyCodeController *vc = [[WPMyCodeController alloc] init];
//                vc.codeType = 2;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [WPUserInfor sharedWPUserInfor].userInfoDict = nil;
            });
        }
        
        else if ([WPUserInfor sharedWPUserInfor].userInfoDict)
        {
            __weakSelf
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                WPJpushServiceController *vc = [[WPJpushServiceController alloc] init];
                vc.resultDict = [WPUserInfor sharedWPUserInfor].userInfoDict;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [WPUserInfor sharedWPUserInfor].threeTouch = nil;
            });
        }
    }

    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getBillData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getBillData];
    }];
    [self.indicatorView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.page = 1;
    [self getBillData];
}

#pragma mark - Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(6, WPTopY, kScreenWidth - 12, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor cellColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPBillNotificationCell class]) bundle:nil] forCellReuseIdentifier:WPBillNotificationCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WPBillNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBillNotificationCellID];
    cell.model = self.dataArray[indexPath.section];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    WPBillModel *model = self.dataArray[section];
    NSString *dateStr = [WPPublicTool dateStringWith:[WPPublicTool stringToDateString:model.finishDate]];
    float width = dateStr.length * 10;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableView.frame) / 2 - width / 2, 7, width, 20)];
    titleLabel.backgroundColor = [UIColor placeholderColor];
    titleLabel.text = dateStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.layer.cornerRadius = WPCornerRadius;
    titleLabel.layer.masksToBounds = YES;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPBillDetailController *vc = [[WPBillDetailController alloc] init];
    WPBillModel *model = self.dataArray[indexPath.section];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Data

- (void)getBillData
{
    NSDictionary *parameters = @{
                                 @"curPage" : [NSString stringWithFormat:@"%ld", (long)self.page],
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPBillNotificationURL parameters:parameters success:^(id success)
    {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:[WPBillModel mj_objectArrayWithKeyValuesArray:result[@"infoList"]]];
        }
        [WPHelpTool endRefreshingOnView:weakSelf.tableView array:result[@"infoList"] noResultLabel:weakSelf.noResultLabel title:@"暂无账单记录"];
        
    } failure:^(NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any l¬resources that can be recreated.
}


@end
