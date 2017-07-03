//
//  WPMerchantSearchController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantSearchController.h"
#import "Header.h"
#import "WPMerchantCell.h"
#import "WPMerchantDetailController.h"

static NSString * const WPMerchantCellID = @"WPMerchantCellID";

@interface WPMerchantSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WPMerchantSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.searchBar becomeFirstResponder];
    [self searchBar];
    [self cancelButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 30, kScreenWidth - 55, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入关键字";
        _searchBar.layer.borderWidth = WPLineHeight;
        _searchBar.layer.borderColor = [UIColor lineColor].CGColor;
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 5, 30, 40, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMerchantCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantCellID];
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
    WPMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    WPMerchantModel *model = _dataArray[indexPath.row];
    
    WPMerchantDetailController *vc = [[WPMerchantDetailController alloc] init];
    vc.merID = model.shop_id;
    vc.navigationItem.title = model.shopName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchbar Delegate

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [self getMerchantData];
    }
}

#pragma mark - Action

- (void)cancelButton:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMerchantData
{
    NSDictionary *parameters = @{
                                 @"shopName" : self.searchBar.text.length > 0 ? self.searchBar.text : @""
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPShowMerShopsURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantModel mj_objectArrayWithKeyValuesArray:result[@"shopList"]]];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"shopList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的商家"];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
