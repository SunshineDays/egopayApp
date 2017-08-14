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

- (void)viewDidLoad
{
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMessagesCell class]) bundle:nil] forCellReuseIdentifier:WPMessageCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPMessagesCell *cell = [_tableView dequeueReusableCellWithIdentifier:WPMessageCellID];
    cell.subAccountModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if ([WPJudgeTool isShopApprove])
    {
        WPSubAccountAddController *vc = [[WPSubAccountAddController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self getMerchantInforData];
    }
}

#pragma mark - Data

- (void)getSubAccountListData
{
    
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountListURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:[WPSubAccountListModel mj_objectArrayWithKeyValuesArray:result[@"clerkList"]]];
            [weakSelf.tableView reloadData];
        }
        [WPHelpTool endRefreshingOnView:weakSelf.tableView array:result[@"clerkList"] noResultLabel:weakSelf.noResultLabel title:@"暂无子账户"];
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)getMerchantInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPQueryShopStatusURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            // 1 成功 2 失败 3 认证中
            NSString *status = [NSString stringWithFormat:@"%@",result[@"status"]];
            
            if ([status intValue] == 1) {
                WPSubAccountAddController *vc = [[WPSubAccountAddController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [WPUserInfor sharedWPUserInfor].shopPassType = @"YES";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请先完成商家认证"];
            }
        }
        else
        {
            [WPProgressHUD showInfoWithStatus:@"请先完成商家认证"];
        }
        
    } failure:^(NSError *error)
    {
        
    }];
}


@end
