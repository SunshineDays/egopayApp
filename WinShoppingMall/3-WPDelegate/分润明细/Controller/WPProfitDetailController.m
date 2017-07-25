//
//  WPProfitDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProfitDetailController.h"
#import "Header.h"
#import "WPProfitDetailCell.h"
#import "WPProfitDetailModel.h"
#import "WPBillTitleView.h"
#import "WPSelectListController.h"

static NSString * const WPProfitDetailCellID = @"WPProfitDetailCellID";

@interface WPProfitDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPBillTitleView *titleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *benefitStr;

@end

@implementation WPProfitDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"分润明细";

    self.page = 1;
    self.dateString = @"";
    [self getProfitAndTradingData];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        weakSelf.page = 1;
        [weakSelf getProfitAndTradingData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^
    {
        weakSelf.page ++;
        [weakSelf getProfitAndTradingData];
    }];
}

#pragma mark - Init

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WPBillTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPBillTitleView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, 50)];
        [_titleView.titleButton setTitle:self.benefitStr forState:UIControlStateNormal];
        [_titleView.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView.imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + 50, kScreenWidth, kScreenHeight - WPNavigationHeight - 50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor cellColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.layer.borderColor = [UIColor lineColor].CGColor;
        _tableView.layer.borderWidth = 1.0f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPProfitDetailCell class]) bundle:nil] forCellReuseIdentifier:WPProfitDetailCellID];
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
    WPProfitDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WPProfitDetailCellID];
    cell.profitModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Action

- (void)titleButtonClick:(UIButton *)sender
{
    self.dateString = @"";
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)imageButtonClick:(UIButton *)sender
{
    WPSelectListController *vc = [[WPSelectListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.type = 4;
    
    __weakSelf
    vc.selecteNameBlock = ^(NSString *nameStr)
    {
        self.year = [nameStr substringToIndex:4];
        self.month = [nameStr substringWithRange:NSMakeRange(nameStr.length - 3, 2)];
        weakSelf.dateString = [NSString stringWithFormat:@"%@%@", self.year, self.month];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Data

- (void)getProfitAndTradingData
{
    NSDictionary *parameters = @{
                                 @"curPage" : [NSString stringWithFormat:@"%ld", (long)self.page],
                                 @"queryDate" : self.dateString
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPProfitDetailURL parameters:parameters success:^(id success)
    {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:[WPProfitDetailModel mj_objectArrayWithKeyValuesArray:result[@"benefitDetails"]]];

            weakSelf.benefitStr = weakSelf.dateString.length > 0 ? [NSString stringWithFormat:@"%@\n总分润 ¥%.2f，佣金 ¥%.2f", [NSString stringWithFormat:@"%@年%@月", self.year, self.month], [result[@"benefit"] floatValue], [result[@"commission"] floatValue]] : [NSString stringWithFormat:@"全部账单\n总分润 ¥%.2f，佣金 ¥%.2f", [result[@"benefit"] floatValue], [result[@"commission"] floatValue]];
            [_titleView.titleButton setTitle:weakSelf.benefitStr forState:UIControlStateNormal];
            
            [weakSelf titleView];
        }
        [WPHelpTool endRefreshingOnView:weakSelf.tableView array:result[@"benefitDetails"] noResultLabel:weakSelf.noResultLabel title:@"暂无记录"];
    } failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
