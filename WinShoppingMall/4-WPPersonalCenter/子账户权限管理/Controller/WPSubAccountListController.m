//
//  WPSubAccountListController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountListController.h"
#import "WPRechargeCell.h"
#import "WPSubAccountListModel.h"
#import "Header.h"
#import "WPAddSubAccountController.h"
#import "WPSubAccountSettingController.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";
@interface WPSubAccountListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WPSubAccountListController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"子账户";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem  WP_itemWithTarget:self action:@selector(addSubAccount) image:[UIImage imageNamed:@"icon_jia_content_n"] highImage:nil];
    [self getSubAccountListData];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPRechargeCell *cell = [_tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
    cell.subAccountListModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WPRowHeight;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPSubAccountSettingController *vc = [[WPSubAccountSettingController alloc] init];
    WPSubAccountListModel *model = self.dataArray[indexPath.row];
    vc.clerkID = model.clerkId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)addSubAccount
{
    WPAddSubAccountController *vc = [[WPAddSubAccountController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Data

- (void)getSubAccountListData {
    
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPSubAccountListModel mj_objectArrayWithKeyValuesArray:result[@"clerkList"]]];
            [weakSelf.tableView reloadData];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"clerkList"] noResultLabel:weakSelf.noResultLabel title:@"暂无记录"];
    } failure:^(NSError *error) {
        
    }];
}


@end
