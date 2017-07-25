//
//  WPBillController.m
//  WinShoppingMall
//  账单
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillController.h"
#import "Header.h"
#import "WPBillCell.h"
#import "WPBillModel.h"
#import "WPBillDetailController.h"
#import "WPSelectListController.h"
#import "WPBillTitleView.h"

static NSString *const WPBillCellID = @"WPBillCellID";


@interface WPBillController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPBillTitleView *titleView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *billArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *incomeString;
@property (nonatomic, copy) NSString *expensesString;

@end

@implementation WPBillController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = self.isCheck ? @"对账" : @"账单";
    self.page = 1;
    self.dateString = @"";
    [self.indicatorView startAnimating];
    [self getBillListData];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getBillListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getBillListData];
    }];
}

#pragma mark - Init

- (NSMutableArray *)billArray
{
    if (!_billArray) {
        _billArray = [[NSMutableArray alloc] init];
    }
    return _billArray;
}

- (WPBillTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPBillTitleView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, 50)];
        NSString *titleStr = self.isCheck ? [NSString stringWithFormat:@"全部账单\n收入 ¥%@", self.incomeString] : [NSString stringWithFormat:@"全部账单\n收入 ¥%@, 支出 ¥%@", self.incomeString, self.expensesString];
        [_titleView.titleButton setTitle:titleStr forState:UIControlStateNormal];
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
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = [UIColor lineColor].CGColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPBillCell class]) bundle:nil] forCellReuseIdentifier:WPBillCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.billArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPBillCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBillCellID];
    cell.model = self.billArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPBillDetailController *vc = [[WPBillDetailController alloc] init];
    vc.model = self.billArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
        weakSelf.year = [nameStr substringToIndex:4];
        weakSelf.month = [nameStr substringWithRange:NSMakeRange(nameStr.length - 3, 2)];
        weakSelf.dateString = [NSString stringWithFormat:@"%@%@", self.year, self.month];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Data

- (void)getBillListData
{
    NSDictionary *parameters = @{
                                 @"curPage" : [NSString stringWithFormat:@"%ld", (long)self.page],
                                 @"queryDate" : self.dateString
                                 };
    __weakSelf
    [WPHelpTool getWithURL:self.isCheck ? WPCheckBillURL : WPBillURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.billArray removeAllObjects];
            }
            [weakSelf.billArray addObjectsFromArray:[WPBillModel mj_objectArrayWithKeyValuesArray:result[@"tradeList"]]];
            NSString *qr_income = [NSString stringWithFormat:@"%.2f", [result[@"qr_income"] floatValue]];
            NSString *income = [NSString stringWithFormat:@"%.2f", [result[@"income"] floatValue]];
            
            weakSelf.incomeString = weakSelf.isCheck ? qr_income : income;
            weakSelf.expensesString = result[@"expenses"];
            NSString *titleStr = weakSelf.isCheck ? [NSString stringWithFormat:@"%@\n收入 ¥%@", weakSelf.dateString.length > 0 ? [NSString stringWithFormat:@"%@年%@月", weakSelf.year, weakSelf.month] : @"全部账单", weakSelf.incomeString] : [NSString stringWithFormat:@"%@\n收入 ¥%@, 支出 ¥%@", weakSelf.dateString.length > 0 ? [NSString stringWithFormat:@"%@年%@月", weakSelf.year, weakSelf.month] : @"全部账单", weakSelf.incomeString, weakSelf.expensesString];
            [_titleView.titleButton setTitle:titleStr forState:UIControlStateNormal];
            [weakSelf titleView];
        }
        [WPHelpTool endRefreshingOnView:weakSelf.tableView array:result[@"tradeList"] noResultLabel:weakSelf.noResultLabel title:@"暂无记录"];
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
