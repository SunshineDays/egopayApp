//
//  WPPayTypeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayTypeController.h"
#import "Header.h"

#import "WPBankCardModel.h"
#import "WPRechargeCell.h"
#import "WPAddCardController.h"
#import "WPEditUserInfoModel.h"
#import "WPPopupTitleView.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPPayTypeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPPopupTitleView *titleView;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *wayArray;
@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) NSMutableArray *bankArray;

@property (nonatomic, strong) WPEditUserInfoModel *model;

@end

@implementation WPPayTypeController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
    
//    [self getUserBalance];
    
    if (self.isUseMoney) {
        [self getUserInforData];
        self.imageArray = @[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"];
    }
    else {
        self.wayArray = @[@"微信支付", @"支付宝支付", @"QQ钱包支付"];
        self.imageArray = @[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon"];
    }

        
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCardData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Init

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
        _tableView.backgroundColor = [UIColor whiteColor];
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

    switch (section) {
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

    if (indexPath.section == 0) {
        WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
        cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.bankNameLabel.text = self.wayArray[indexPath.row];
        return cell;
    }
    else {
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
    
    switch (indexPath.section) {
        case 0: {
            if (((self.model.avl_balance < self.amount || self.model.avl_balance == 0) && indexPath.row == self.wayArray.count - 1) && self.isUseMoney) {
            }
            else {
                if (self.userPayTypeBlock) {
                    self.userPayTypeBlock(indexPath.row);
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
            }
        }
            break;
        case 1: {
            WPBankCardModel *model = [[WPBankCardModel alloc] init];
            model = self.cardArray[indexPath.row];
            if (self.userCardBlock) {
                self.userCardBlock(model);
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
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
    [WPHelpTool getWithURL:WPUserBanCardURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.cardArray removeAllObjects];
            [weakSelf.cardArray addObjectsFromArray:[WPBankCardModel mj_objectArrayWithKeyValuesArray:result[@"cardList"]]];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 获取用户信息
- (void)getUserInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.model = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            NSString *userMoney = [NSString stringWithFormat:@"%@(可用余额:%.2f元)", weakSelf.amount > weakSelf.model.avl_balance ? @"余额不足" : @"余额支付", weakSelf.model.avl_balance];
            weakSelf.wayArray = @[@"微信支付", @"支付宝支付", @"QQ钱包支付", userMoney];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserBalance
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.model = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            NSString *userMoney = [NSString stringWithFormat:@"%@(可用余额:%.2f元)", weakSelf.amount > weakSelf.model.avl_balance ? @"余额不足" : @"余额支付", weakSelf.model.avl_balance];
            weakSelf.wayArray = @[@"微信支付", @"支付宝支付", @"QQ钱包支付", userMoney];
            weakSelf.imageArray = @[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"];
            [weakSelf getCardData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
