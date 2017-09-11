//
//  WPSelectListPopupController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSelectListPopupController.h"
#import "Header.h"
#import "WPPopupTitleView.h"
#import "WPSelectListCell.h"

static NSString *const WPMerchantCityListCellID = @"WPMerchantCityListCellID";

@interface WPSelectListPopupController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPPopupTitleView *titleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *alphaButton;


@end

@implementation WPSelectListPopupController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3];
    
    switch (self.type)
    {
        case 1:// 城市
            [self getCityListData];
            break;
            
        case 2:// 类别
            [self getCategoryListData];
            break;
            
        case 3:// 银行
            [self getBankListData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCityListCellID];
    
    if (self.type == 2)//类别
    {
        cell.model = self.dataArray[indexPath.row];
    }
    else
    {
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
    if (self.type == 2)// 类别
    {
        WPMerchantCityListModel *model = self.dataArray[indexPath.row];
        if (self.selectCategoryBlock)
        {
            self.selectCategoryBlock(model);
        }
    }
    else
    {
        if (self.selecteNameBlock)
        {
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
    [WPProgressHUD showProgressIsLoading];
    [WPHelpTool getWithURL:WPCityListURL parameters:nil success:^(id success)
    {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray addObjectsFromArray:result[@"cities"]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [WPProgressHUD dismiss];
    }];
}

- (void)getCategoryListData
{
    __weakSelf
    [WPProgressHUD showProgressIsLoading];
    [WPHelpTool getWithURL:WPGetCategoryURL parameters:nil success:^(id success)
    {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantCityListModel mj_objectArrayWithKeyValuesArray:result[@"cateList"]]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [WPProgressHUD dismiss];
    }];
}

- (void)getBankListData
{
    __weakSelf
    [WPProgressHUD showProgressIsLoading];
    [WPHelpTool getWithURL:WPBankListURL parameters:nil success:^(id success)
    {
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray addObjectsFromArray:result[@"bankName"]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [WPProgressHUD dismiss];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
