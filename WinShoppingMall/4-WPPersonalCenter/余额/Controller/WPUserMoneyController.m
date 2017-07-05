//
//  WPUserMoneyController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserMoneyController.h"
#import "Header.h"
#import "WPRechargeCell.h"
#import "WPUserRechargeController.h"
#import "WPUserWithDrawController.h"

static NSString *const WPRechargeCellMoneyID = @"WPRechargeCellMoneyID";

@interface WPUserMoneyController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;


@end

@implementation WPUserMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额";
    self.dataArray = @[@"充值", @"提现"];
    self.imageArray = @[@"icon_chongzhi_content_n", @"icon_tixian_content_n"];
    
    [self initTitleLabel];
    [self.tableView reloadData];
}

#pragma mark - Init

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, 160)];
        _headerView.backgroundColor = [UIColor themeColor];
    }
    return _headerView;
}

- (void)initTitleLabel
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 20, kScreenWidth / 2 - WPLeftMargin, 40)];
    titleLable.text = @"可提现金额(元)";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:WPFontDefaultSize];
    [self.headerView addSubview:titleLable];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(titleLable.frame), kScreenWidth - 2 * WPLeftMargin, 100)];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.model.avl_balance];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font = [UIFont systemFontOfSize:60 weight:10];
    [self.headerView addSubview:moneyLabel];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor cellColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellMoneyID];
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
    WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellMoneyID];
    cell.bankNameLabel.text = self.dataArray[indexPath.row];
    cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WPRowHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0: // 充值
        {
            WPUserRechargeController *vc = [[WPUserRechargeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: // 提现
        {
            if (self.model.avl_balance > 0) {
                if ([WPAppTool isPassIDCardApprove]) {
                    WPUserWithDrawController *vc = [[WPUserWithDrawController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                }
            }
        }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
