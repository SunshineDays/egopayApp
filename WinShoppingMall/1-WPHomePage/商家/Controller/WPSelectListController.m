//
//  WPSelectListController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSelectListController.h"

#import "Header.h"

#import "WPMerchantCityListCell.h"

static NSString *const WPMerchantCityListCellID = @"WPMerchantCityListCellID";

@interface WPSelectListController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIView *contentView;
//  标题
@property (nonatomic, strong) UILabel *titleLabel;
//关闭窗口UI按钮
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *lineView;

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

    [self titleLabel];
    [self alphaButton];
    [self cancelButton];
    [self lineView];
    
    switch (self.type) { // 1:城市 2:类别 3:银行 4:日期 5:性别
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
            
        case 5:
            [self getSexListData];
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

- (UIButton *)alphaButton
{
    if (!_alphaButton) {
        _alphaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3)];
        [_alphaButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_alphaButton];
    }
    return _alphaButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 1 / 3, kScreenWidth, kScreenHeight * 2 / 3)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled  = YES;
        _contentView.layer.borderColor = [UIColor lineColor].CGColor;
        _contentView.layer.borderWidth = 1.0f;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, 0, 120, WPRowHeight)];
        _titleLabel.text = @"请选择";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, WPRowHeight, WPRowHeight)];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_x_content_n"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, 0.5f)];
        _lineView.backgroundColor = [UIColor placeholderColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), kScreenWidth, self.contentView.frame.size.height - (WPRowHeight + WPLineHeight)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMerchantCityListCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantCityListCellID];
        [self.contentView addSubview:_tableView];
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
    WPMerchantCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantCityListCellID];
    
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
    [WPHelpTool postWithURL:WPCityListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:result[@"cities"]];
            [weakSelf.tableView reloadData];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCategoryListData
{
    __weakSelf
    [WPHelpTool postWithURL:WPGetCategoryURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPMerchantCityListModel mj_objectArrayWithKeyValuesArray:result[@"cateList"]]];
            [weakSelf.tableView reloadData];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getBankListData
{
    __weakSelf
    [WPHelpTool postWithURL:WPBankListURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:result[@"bankName"]];
            [weakSelf.tableView reloadData];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDateListData {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger year = [[formatter stringFromDate:date] integerValue];
    
    [formatter setDateFormat:@"MM"];
    NSInteger month = [[formatter stringFromDate:date] integerValue];
    
    for (int i = 0; i < 12; i++) {
        if (month < 1) {
            month = month + 12;
            year = year - 1;
        }
        NSString *monthString = month < 10 ? [NSString stringWithFormat:@"0%ld", (long)month] : [NSString stringWithFormat:@"%ld", (long)month];
        NSString *dateString = [NSString stringWithFormat:@"%ld年%@月", (long)year, monthString];
        [self.dataArray addObject:dateString];
        month --;
    }
    [self.tableView reloadData];
}

- (void)getSexListData
{
    [self.dataArray addObjectsFromArray:@[@"男", @"女"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
