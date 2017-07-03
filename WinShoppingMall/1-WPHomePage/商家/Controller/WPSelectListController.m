//
//  WPSelectListController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSelectListController.h"
#import "Header.h"
#import "WPPopupTitleView.h"
#import "WPSelectListCell.h"

static NSString *const WPMerchantCityListCellID = @"WPMerchantCityListCellID";

@interface WPSelectListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPPopupTitleView *titleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *alphaButton;


@end

@implementation WPSelectListController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3];
    
    switch (self.type) { // 1:城市 2:类别 3:银行 4:日期
        case 1:
            [self getCityListData];
            break;
            
        case 2:
            [self getCategoryListData];
            break;
            
        case 3:
            [self getBankListData];
            break;
            
        case 4:
            [self getDateListData];
            break;
            
        default:
            break;
    }
}

#pragma mark - Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (WPPopupTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPPopupTitleView alloc] init];
        _titleView.titleLabel.text = @"请选择";
        [_titleView.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView.imageButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.titleView.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPSelectListCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantCityListCellID];
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
    WPSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCityListCellID];
    
    if (self.type == 2) {
        cell.model = self.dataArray[indexPath.row];
    }
    else {
        cell.cityName.text = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 2) {
        WPMerchantCityListModel *model = self.dataArray[indexPath.row];
        if (self.selectCategoryBlock) {
            self.selectCategoryBlock(model);
        }
    }
    else {
        if (self.selecteNameBlock) {
            self.selecteNameBlock(self.dataArray[indexPath.row]);
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma Action

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Data

- (void)getCityListData
{
    __weakSelf
    [WPHelpTool getWithURL:WPCityListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:result[@"cities"]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCategoryListData
{
    __weakSelf
    [WPHelpTool getWithURL:WPGetCategoryURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantCityListModel mj_objectArrayWithKeyValuesArray:result[@"cateList"]]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getBankListData
{
    __weakSelf
    [WPHelpTool getWithURL:WPBankListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:result[@"bankName"]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDateListData {
    [self.dataArray addObjectsFromArray:[WPHelpTool dateArrayWithMonthNumber:12]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
