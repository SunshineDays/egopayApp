//
//  WPMessagesController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMessagesCenterController.h"
#import "Header.h"
#import "WPMessagesCell.h"
#import "WPMessageDetailController.h"

static NSString * const WPMessagesCellID = @"WPMessagesCellID";


@interface WPMessagesCenterController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation WPMessagesCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"系统消息";
    self.page = 1;
    [self getmessgaesData];

    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getmessgaesData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getmessgaesData];
    }];
}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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

- (void)getmessgaesData
{
    NSDictionary *parameters = @{
                                 @"curPage" : [NSString stringWithFormat:@"%ld", (long)self.page]
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPMessageURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:[WPMessagesModel mj_objectArrayWithKeyValuesArray:result[@"msgList"]]];
        }
        [WPHelpTool messageEndRefreshingOnView:weakSelf.tableView array:result[@"msgList"] noResultLabel:weakSelf.noResultLabel title:@"暂无消息"];
    } failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any l¬resources that can be recreated.
}


@end
