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


static NSString * const WPBillNotificationCellID = @"WPBillNotificationCellID";


@interface WPMessagesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation WPMessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"消息";
    self.page = 1;
    [self getBillData];
    __weakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getBillData];
    }];
    [self.indicatorView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.page = 1;
    [self getBillData];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(6, WPNavigationHeight, kScreenWidth - 12, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor cellColor];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPBillNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBillNotificationCellID];
    cell.model = self.dataArray[indexPath.section];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WPBillModel *model = self.dataArray[section];
    NSString *dateStr = [[WPPublicTool dateToLocalDate:model.finishDate] substringFromIndex:[WPPublicTool dateToLocalDate:model.finishDate].length - 6];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = dateStr;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:0.6];
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    return titleLabel;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPBillDetailController *vc = [[WPBillDetailController alloc] init];
    WPBillModel *model = self.dataArray[indexPath.section];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取消息数据
- (void)getBillData {
    
    __weakSelf
    [WPHelpTool getWithURL:WPBillNotificationURL parameters:nil success:^(id success) {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:[WPBillModel mj_objectArrayWithKeyValuesArray:result[@"infoList"]]];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"infoList"] noResultLabel:weakSelf.noResultLabel title:@"暂无账单记录"];
    } failure:^(NSError *error) {
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
