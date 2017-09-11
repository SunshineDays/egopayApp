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
#import "WPSelectListPopupController.h"
#import "WPBillDatePickerView.h"
#import "WPBillMonthController.h"

static NSString *const WPBillCellID = @"WPBillCellID";


@interface WPBillController () <UITableViewDelegate, UITableViewDataSource, WPBillDatePickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

/**  选择日期字符串 */
@property (nonatomic, copy) NSString *dateString;

/**  记录请求到的数据的数组 */
@property (nonatomic, strong) NSMutableArray *billArray;

/**  不一样日期(月份)的数组 */
@property (nonatomic, strong) NSMutableArray *dateArray;

/**  最终的结果 */
@property (nonatomic, strong) NSMutableArray *contentArray;

/**  上一个日期(月份)字符串 */
@property (nonatomic, copy) NSString *lastDate;



@end

@implementation WPBillController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = self.isCheck ? @"对账" : @"账单";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ixon_zhangdan_content_n"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    
    
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

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
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
    return self.contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPBillCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBillCellID];
    cell.model = self.contentArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor tableViewColor];
    headerView.layer.borderColor = [UIColor lineColor].CGColor;
    headerView.layer.borderWidth = WPLineHeight;
    headerView.userInteractionEnabled = YES;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger nowYear = [[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger nowMonth = [[formatter stringFromDate:date] integerValue];
    
    NSInteger year =  [[self.dateArray[section] substringToIndex:4] floatValue];
    NSInteger month = [[self.dateArray[section] substringWithRange:NSMakeRange(5, 2)] integerValue];

    NSString *dateString;
    if (nowYear == year) {
        if (nowMonth == month)
        {
            dateString = @"本月";
        }
        else
        {
            dateString = [NSString stringWithFormat:@"%ld月", (long)month];
        }
    }
    else
    {
        dateString = [NSString stringWithFormat:@"%@月", [self.dateArray[section] stringByReplacingOccurrencesOfString:@"-" withString:@"年"]];
    }
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, 200, 35)];
    headerLabel.text = dateString;
    [headerView addSubview:headerLabel];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - WPLeftMargin - 20, 7.5, 20, 20)];
    [headerButton setImage:[UIImage imageNamed:@"icon_fanhui_n"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(monthBillAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerButton];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPBillDetailController *vc = [[WPBillDetailController alloc] init];
    vc.model = self.contentArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Action

- (void)rightItemAction
{
    WPBillDatePickerView *pickerView = [[WPBillDatePickerView alloc] initPickerView];
    pickerView.pickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)monthBillAction
{
    WPBillMonthController *vc = [[WPBillMonthController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wp_selecteBillDataWithYear:(NSString *)year month:(NSString *)month
{
    self.dateString = [NSString stringWithFormat:@"%@%@", year, month];
    [self.tableView.mj_header beginRefreshing];
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
                [weakSelf.contentArray removeAllObjects];
                [weakSelf.dateArray removeAllObjects];
            }
            
            // 请求获取的数组
            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[WPBillModel mj_objectArrayWithKeyValuesArray:result[@"tradeList"]]];
            
            for (int i = 0; i < resultArray.count; i++)
            {
                WPBillModel *billModel = resultArray[i];
                NSString *date = [[WPPublicTool stringToDateString:billModel.createDate] substringToIndex:7];
                
                // 提取不一样的日期(月份)数组
                [weakSelf.dateArray addObject:date];
                NSSet *set = [NSSet setWithArray:weakSelf.dateArray];
                weakSelf.dateArray = [NSMutableArray arrayWithArray:[set allObjects]];
                
                // 日期数组从大到小排序
                [weakSelf.dateArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                {
                    return [obj2 compare:obj1];
                }];
                
                // 账单数组长度 = 日期数组长度
                weakSelf.contentArray[weakSelf.dateArray.count - 1] = @[];
                
                // 判断日期是否变化
                if ([weakSelf.lastDate isEqualToString:date] && weakSelf.lastDate.length > 0)
                {
                    // 相同日期的账单数组
                    [weakSelf.billArray addObject:billModel];
                }
                else
                {
                    // 日期改变，移除数据，重新添加
                    [weakSelf.billArray removeAllObjects];
                    [weakSelf.billArray addObject:billModel];
                }
                
                // 记录日期
                weakSelf.lastDate = date;
                
                // 把账单数组按照日期加入数组中
                [weakSelf.contentArray replaceObjectAtIndex:weakSelf.dateArray.count - 1 withObject:[weakSelf.billArray mutableCopy]];
            }
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
