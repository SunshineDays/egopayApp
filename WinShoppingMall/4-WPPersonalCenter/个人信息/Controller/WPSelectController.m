//
//  WPSelectController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSelectController.h"
#import "WPUserEnrollController.h"
#import "WPSelectListCell.h"
#import "Header.h"
#import "WPAddCardController.h"

static NSString * const WPMerchantCityListCellID = @"WPMerchantCityListCellID";

@interface WPSelectController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation WPSelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor tableViewColor];
    [self judgeTitleType];
    [self.tableView reloadData];
}

- (void)judgeTitleType
{
    switch (self.selectType)
    {
        case 1:
        {
            self.navigationItem.title = @"重置密码";
            self.dataArray = @[@"重置登录密码", @"重置支付密码"];
            break;
        }
        
        case 2:
        {
            self.navigationItem.title = @"添加银行卡";
            self.dataArray = @[@"添加信用卡", @"添加储蓄卡"];
            break;
        }
        
        default:
            break;
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY + 15, kScreenWidth, kScreenHeight - WPNavigationHeight - 15) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPSelectListCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantCityListCellID];
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
    WPSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCityListCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.cityName.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WPRowHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.selectType)
    {
        case 1:
        {
            WPPasswordController *vc = [[WPPasswordController alloc] init];
            vc.passwordType = indexPath.row == 0 ? @"1" : @"2";
            vc.navigationItem.title = indexPath.row == 0 ? @"重置登录密码" : @"重置支付密码";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        
        case 2:
        {
            WPAddCardController *vc = [[WPAddCardController alloc] init];
            vc.cardType = indexPath.row == 0 ? @"1" : @"2";
            vc.navigationItem.title = indexPath.row == 0 ? @"添加信用卡" : @"添加储蓄卡";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
