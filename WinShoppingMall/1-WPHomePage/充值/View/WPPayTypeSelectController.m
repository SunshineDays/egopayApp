//
//  WPPayTypeSelectController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayTypeSelectController.h"
#import "Header.h"

#import "WPBankCardModel.h"
#import "WPRechargeCell.h"
#import "WPAddCardController.h"
#import "WPUserInforModel.h"
#import "WPPopupTitleView.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPPayTypeSelectController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPPopupTitleView *titleView;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *wayArray;
@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) NSMutableArray *bankArray;

@property (nonatomic, strong) WPUserInforModel *model;

@end

@implementation WPPayTypeSelectController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
    
    if (self.isBalance)
    {
        [self getUserBalance];
    }
    else
    {
        [self.wayArray removeLastObject];
        [self.imageArray removeLastObject];
        [self getCardData];
    }
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isBalance ? [weakSelf getUserBalance] : [weakSelf getCardData];
    }];
    [self.indicatorView startAnimating];
}


#pragma mark - Init

-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [WPUserTool payTypeImageArray];
    }
    return _imageArray;
}

- (NSMutableArray *)wayArray
{
    if (!_wayArray) {
        _wayArray = [WPUserTool payTypeTitleArray];
    }
    return _wayArray;
}

- (NSMutableArray *)cardArray
{
    if (!_cardArray) {
        _cardArray = [NSMutableArray array];
    }
    return _cardArray;
}

- (NSMutableArray *)bankArray
{
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
    }
    return _bankArray;
}

- (WPPopupTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPPopupTitleView alloc] init];
        _titleView.titleLabel.text = @"选择付款方式";
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section)
    {
        case 0:
            return self.wayArray.count;
            break;
        case 1:
            return self.cardArray.count;
            break;
//            case 2:
//                return 1;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
        cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.bankNameLabel.text = self.wayArray[indexPath.row];
        return cell;
    }
    else
    {
        WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
        cell.model = self.cardArray[indexPath.row];
        return cell;
    }
//        else {
//            WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
//            cell.bankNameLabel.text = @"添加银行卡";
//            cell.imageView.image = [UIImage imageNamed:@"icon_yinhang_n"];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (((self.model.avl_balance < self.amount || self.model.avl_balance == 0) && indexPath.row == self.wayArray.count - 1) && self.isBalance)  //判断余额是否够
            {
            }
            else
            {
                if (self.userPayTypeBlock)
                {
                    self.userPayTypeBlock(indexPath.row);
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
            }
            break;
        }
        case 1:
        {
            WPBankCardModel *model = [[WPBankCardModel alloc] init];
            model = self.cardArray[indexPath.row];
            if (self.userCardBlock)
            {
                self.userCardBlock(model);
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            break;
        }
//            case 2: {
//                if (self.userAddCardBlock) {
//                    self.userAddCardBlock();
//                }
//            }
//                break;
        default:
            break;
    }
}

#pragma mark - Action

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Data

- (void)getCardData
{
    NSDictionary *parameters = @{
                                 @"clitype" : @"4",
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPUserBanKCardURL parameters:parameters success:^(id success)
    {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.cardArray removeAllObjects];
            [weakSelf.cardArray addObjectsFromArray:[WPBankCardModel mj_objectArrayWithKeyValuesArray:result[@"cardList"]]];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.indicatorView stopAnimating];
    }];
}

#pragma mark - 获取余额
- (void)getUserBalance
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.model = [WPUserInforModel mj_objectWithKeyValues:result];
            NSString *userMoney = [NSString stringWithFormat:@"%@(可用余额:%.2f元)", weakSelf.amount > weakSelf.model.avl_balance ? @"余额不足" : @"余额支付", weakSelf.model.avl_balance];
            [weakSelf.wayArray replaceObjectAtIndex:weakSelf.wayArray.count - 1 withObject:userMoney];
            [weakSelf getCardData];
        }
    } failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.indicatorView stopAnimating];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
