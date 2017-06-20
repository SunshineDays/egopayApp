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

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPPayTypeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *rechargeView;

@property (nonatomic, strong) UIButton *alphaButton;

//  标题
@property (nonatomic, strong) UILabel *titleLabel;
//关闭窗口UI按钮
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *lineView;

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
    
    if (self.isUseMoney) {
        [self getUserInforData];
        self.imageArray = @[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"];
    }
    else {
        self.wayArray = @[@"微信支付", @"支付宝支付", @"QQ钱包支付"];
        self.imageArray = @[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon"];
    }
    [self alphaButton];
    [self titleLabel];
    [self cancelButton];
    [self lineView];
        
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

- (UIButton *)alphaButton
{
    if (!_alphaButton) {
        _alphaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3)];
        [_alphaButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_alphaButton];
    }
    return _alphaButton;
}

- (UIView *)rechargeView
{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 1 / 3, kScreenWidth, kScreenHeight * 2 / 3)];
        _rechargeView.backgroundColor = [UIColor whiteColor];
        _rechargeView.layer.borderColor = [UIColor lineColor].CGColor;
        _rechargeView.layer.borderWidth = 1.0f;
        _rechargeView.userInteractionEnabled  = YES;
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, 0, 120, WPRowHeight)];
        _titleLabel.text = @"选择付款方式";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.rechargeView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, WPRowHeight, WPRowHeight)];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_x_content_n"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.rechargeView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, 0.5f)];
        _lineView.backgroundColor = [UIColor placeholderColor];
        [self.rechargeView addSubview:_lineView];
    }
    return _lineView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), kScreenWidth, self.rechargeView.frame.size.height - (WPRowHeight + WPLineHeight)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.rechargeView addSubview:_tableView];
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
                    self.userPayTypeBlock(self.wayArray[indexPath.row]);
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
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
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
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
