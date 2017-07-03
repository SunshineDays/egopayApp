//
//  WPSubAccountListController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountListController.h"
#import "WPMessagesCell.h"
#import "WPSubAccountListModel.h"
#import "Header.h"
#import "WPSubAccountAddController.h"
#import "WPSubAccountSettingController.h"

static NSString * const WPMessageCellID = @"WPMessageCellID";
@interface WPSubAccountListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WPSubAccountListController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"子账户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_jia_content_n"] style:UIBarButtonItemStylePlain target:self action:@selector(addSubAccount)];
    [self getSubAccountListData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSubAccountListData) name:WPNotificationSubAccountAddSuccess object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMessagesCell class]) bundle:nil] forCellReuseIdentifier:WPMessageCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPMessagesCell *cell = [_tableView dequeueReusableCellWithIdentifier:WPMessageCellID];
    WPSubAccountListModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.clerkName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPSubAccountSettingController *vc = [[WPSubAccountSettingController alloc] init];
    WPSubAccountListModel *model = self.dataArray[indexPath.row];
    vc.clerkID = model.clerkId;
    vc.clerkName = model.clerkName;
    vc.clerkRegisterID = model.clerkNo;
    __weakSelf
    vc.subAccountDeleteBlock = ^{
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)addSubAccount
{
    WPSubAccountAddController *vc = [[WPSubAccountAddController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Data

- (void)getSubAccountListData {
    
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:[WPSubAccountListModel mj_objectArrayWithKeyValuesArray:result[@"clerkList"]]];
            [weakSelf.tableView reloadData];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"clerkList"] noResultLabel:weakSelf.noResultLabel title:@"暂无子账户"];
    } failure:^(NSError *error) {
        
    }];
}


@end
