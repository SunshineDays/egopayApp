//
//  WPProductController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProductController.h"
#import "Header.h"
#import "WPProductSubmitController.h"
#import "WPMerchantGradeProuctModel.h"
#import "WPMerchantGradeProductCell.h"
#import "WPProductDetailController.h"
#import "WPUpGradeProductModel.h"
#import "WPUserInforButton.h"

static NSString * const WPMerchantGradeProductCellID = @"WPMerchantGradeProductCellID";

@interface WPProductController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WPUserInforButton *userInforButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) WPEditUserInfoModel *userInforModel;

@property (nonatomic, copy) NSString *benefitRate;

@property (nonatomic, copy) NSString *commissionRate;


@end

@implementation WPProductController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    
    [self getUserInforData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WPUserInforButton *)userInforButton
{
    if (!_userInforButton) {
        _userInforButton = [[WPUserInforButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _userInforButton.backgroundColor = [UIColor whiteColor];
        [[SDImageCache sharedImageCache] clearDisk];
        [_userInforButton.userImageView sd_setImageWithURL:[NSURL URLWithString:self.userInforModel.picurl] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];

        NSString *vipStr = self.isAgencyView ? [WPUserTool userAgencyVipWith:self.userInforModel.agentGradeId] : [WPUserTool userMemberVipWith:self.userInforModel.merchantlvid];
        NSString *rateString = self.isAgencyView ? [NSString stringWithFormat:@"分润费率:%@,佣金比例:%@", self.benefitRate, self.commissionRate] : [NSString stringWithFormat:@"充值费率:%.2f%@", self.userInforModel.rate * 100, @"%"];
        [_userInforButton userInforWithName:self.userInforModel.phone vip:vipStr rate:rateString arrowHidden:YES];
    }
    return _userInforButton;
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.userInforButton;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMerchantGradeProductCell class]) bundle:nil] forCellReuseIdentifier:WPMerchantGradeProductCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPMerchantGradeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMerchantGradeProductCellID];
    
    if (self.isAgencyView) {
        self.imageArray = @[@"icon_yin_content_n", @"icon_jin_content_n", @"icon_zuanshi_n", @"icon_heizuan_n"];
        cell.lvImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.lvImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.delegateLvModel = self.dataArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        
        self.imageArray = @[@"icon_huangjin_content_n", @"icon_bojin_content_n", @"icon_zuanshijin_content_n"];
        cell.lvImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.lvImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.merchantLvModel = self.dataArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isAgencyView) {
        WPUpGradeProductModel *model = self.dataArray[indexPath.row];
        WPProductDetailController *vc = [[WPProductDetailController alloc] init];
        [vc initWithTitle:@"代理升级" titleImage:[UIImage imageNamed:self.imageArray[indexPath.row]] model:model isAgency:self.isAgencyView isUpgrade:model.id > self.userInforModel.agentGradeId ? YES : NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        WPMerchantGradeProuctModel *model = self.dataArray[indexPath.row];
        WPProductDetailController *vc = [[WPProductDetailController alloc] init];
        [vc initWithTitle:@"商户升级" titleImage:[UIImage imageNamed:self.imageArray[indexPath.row]] model:model isAgency:self.isAgencyView isUpgrade:model.id > self.userInforModel.merchantlvid ? YES : NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Data

- (void)getUserInforData
{
    
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];

            weakSelf.userInforModel = [WPEditUserInfoModel mj_objectWithKeyValues:result];
            
            if (weakSelf.isAgencyView) {
                [weakSelf getPoundageData];
            }
            else {
                [weakSelf getMerGradeProductData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getMerGradeProductData
{
    
    __weakSelf
    [WPHelpTool getWithURL:self.isAgencyView ? WPShowAgUpgradeURL : WPShowMerUpgradeURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            if (weakSelf.isAgencyView) {
                [weakSelf.dataArray addObjectsFromArray:[WPUpGradeProductModel mj_objectArrayWithKeyValuesArray:result[@"agUpList"]]];
            }
            else {
                [weakSelf.dataArray addObjectsFromArray:[WPMerchantGradeProuctModel mj_objectArrayWithKeyValuesArray:result[@"merLvList"]]];
                [weakSelf.dataArray removeObjectAtIndex:0];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getPoundageData
{
    NSDictionary *parameter = @{
                                @"rateType" : @"2"
                                };
    __weakSelf
    [WPHelpTool getWithURL:WPPoundageURL parameters:parameter success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.benefitRate = [NSString stringWithFormat:@"%.2f%@", [result[@"benefitRate"] floatValue] * 100, @"%"];
            weakSelf.commissionRate = [NSString stringWithFormat:@"%.2f%@", [result[@"commissionRate"] floatValue] * 100, @"%"];

            [weakSelf getMerGradeProductData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
