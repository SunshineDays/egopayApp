//
//  WPMerchantController.m
//  WinShoppingMall
//  商户
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantController.h"
#import "Header.h"
#import <SDCycleScrollView.h>
#import "WPSelectListController.h"
#import "WPMerchantCell.h"
#import "WPMerchantDetailController.h"
#import "WPMerchantSearchController.h"

static NSString * const WPMerchantCellID = @"WPMerchantCellID";

@interface WPMerchantController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIButton *backButton;

//  搜索框
@property (nonatomic, strong) UISearchBar *searchBar;

//  轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIButton *defaultButton;

@property (nonatomic, strong) UIButton *cityButton;

@property (nonatomic, strong) UIButton *classifyButton;

// 轮播图图片数组
@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) NSInteger page;


@end

@implementation WPMerchantController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商家";
    
    self.page = 1;
    self.categoryID = @"";
    self.cityName = @"";
    [self searchBar];
    [self getShopListData];
    [self getCycleScrollData];
    [self tableHeaderView];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postSelectTypeData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf postSelectTypeData];
    }];
    [self.indicatorView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Init

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + 40, kScreenWidth, kScreenWidth / 2 + 40)];
        self.tableView.tableHeaderView = _tableHeaderView;
    }
    return _tableHeaderView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + 5, kScreenWidth, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索商家";
        _searchBar.layer.borderColor = [UIColor lineColor].CGColor;
        _searchBar.layer.borderWidth = WPLineHeight;
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                  delegate:self
                                                          placeholderImage:[UIImage imageNamed:@"icon_Selected"]];
        _cycleScrollView.localizationImageNamesGroup = self.pictureArray;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self.tableHeaderView addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (UIButton *)defaultButton {
    if (!_defaultButton) {
        _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenWidth / 2, kScreenWidth / 3, 40)];
        [_defaultButton setTitle:@"默认" forState:UIControlStateNormal];
        [_defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _defaultButton.backgroundColor = [UIColor themeColor];
        [_defaultButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeaderView addSubview:_defaultButton];
    }
    return _defaultButton;
}

- (UIButton *)cityButton {
    if (!_cityButton) {
        _cityButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * 1, kScreenWidth / 2, kScreenWidth / 3, 40)];
        [_cityButton setTitle:@"城市" forState:UIControlStateNormal];
        [_cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cityButton addTarget:self action:@selector(cityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cityButton.backgroundColor = [UIColor themeColor];
        
        [self.tableHeaderView addSubview:_cityButton];
    }
    return _cityButton;
}

- (UIButton *)classifyButton {
    if (!_classifyButton) {
        _classifyButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * 2, kScreenWidth / 2, kScreenWidth / 3, 40)];
        [_classifyButton setTitle:@"分类" forState:UIControlStateNormal];
        [_classifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _classifyButton.backgroundColor = [UIColor themeColor];
        [_classifyButton addTarget:self action:@selector(classifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeaderView addSubview:_classifyButton];
    }
    return _classifyButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + 40, kScreenWidth, kScreenHeight - WPNavigationHeight - 40) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor cellColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMerchantCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCellID];
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.searchBar resignFirstResponder];
    WPMerchantModel *model = _dataArray[indexPath.row];
    
    WPMerchantDetailController *vc = [[WPMerchantDetailController alloc] init];
    vc.navigationItem.title = model.shopName;
    vc.merID = model.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UISearchbar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    WPMerchantSearchController *vc = [[WPMerchantSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)defaultButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];
    self.categoryID = @"";
    self.cityName = @"";
    [self.cityButton setTitle:@"城市" forState:UIControlStateNormal];
    [self.classifyButton setTitle:@"分类" forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
}

- (void)cityButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];

    WPSelectListController *vc = [[WPSelectListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.navigationItem.title = @"选择城市";
    vc.type = 1;
    
    __weakSelf
    
    vc.selecteNameBlock = ^(NSString *nameStr) {
        [weakSelf.cityButton setTitle:nameStr forState:UIControlStateNormal];
        weakSelf.cityName = nameStr;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)classifyButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];

    WPSelectListController *vc = [[WPSelectListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.navigationItem.title = @"选择类别";
    vc.type = 2;
    
    __weakSelf
    vc.selectCategoryBlock = ^(WPMerchantCityListModel *model) {
        [weakSelf.classifyButton setTitle:model.name forState:UIControlStateNormal];
        
        weakSelf.categoryID = [NSString stringWithFormat:@"%ld", model.id];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
  
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Data

- (void)getCycleScrollData {
    NSDictionary *parameters = @{
                                 @"bannerCode" : @"2"
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPCycleScrollURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.pictureArray addObjectsFromArray:result[@"home_banner"]];
            [weakSelf.cycleScrollView reloadInputViews];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getShopListData {

    __weakSelf
    [WPHelpTool getWithURL:WPShowMerShopsURL parameters:nil success:^(id success) {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.dataArray removeAllObjects];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantModel mj_objectArrayWithKeyValuesArray:result[@"shopList"]]];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"shopList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的商铺"];
        [weakSelf defaultButton];
        [weakSelf cityButton];
        [weakSelf classifyButton];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.indicatorView stopAnimating];
    }];
}

- (void)postSelectTypeData
{
    NSDictionary *parameters = @{
                                 @"categoryId" : self.categoryID,
                                 @"city" : self.cityName
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPShowMerShopsURL parameters:parameters success:^(id success) {
        [weakSelf.dataArray removeAllObjects];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantModel mj_objectArrayWithKeyValuesArray:result[@"shopList"]]];
            [weakSelf defaultButton];
            [weakSelf cityButton];
            [weakSelf classifyButton];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"shopList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的商铺"];
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
