//
//  WPAgencyController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAgencyController.h"
 
#import "SDCycleScrollView.h"
#import "Header.h"
#import "WPTodayProfitController.h"
#import "WPProfitBalanceController.h"
#import "WPProfitDetailController.h"
#import "WPProductController.h"
#import "WPPublicWebViewController.h"
#import "WPAgencyprotocolController.h"
#import "WPInvitingPeopleController.h"
#import "WPAgencyCell.h"
#import "WPAgencyModel.h"

@interface WPAgencyController ()<SDCycleScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, strong) WPAgencyModel *agencyModel;

@end

static NSString * const WPAgencyCellID = @"WPAgencyCellID";

@implementation WPAgencyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"代理";
    self.view.backgroundColor = [UIColor tableViewColor];
    [self getCycleScrollData];
    [self.indicatorView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getAgencyData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)pictureArray
{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"bannerImage"]];
        _cycleScrollView.localizationImageNamesGroup = self.pictureArray;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _cycleScrollView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((kScreenWidth - WPLeftMargin * 2 - 30) / 2, (kScreenWidth - WPLeftMargin * 2 - 30) / 2 / 2);
        _flowLayout.minimumLineSpacing = 20;
        _flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, kScreenWidth / 2);
        _flowLayout.scrollDirection  = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight - 49) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor cellColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WPAgencyCell class]) bundle:nil] forCellWithReuseIdentifier:WPAgencyCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPAgencyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WPAgencyCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) ? [UIColor themeColor] : [UIColor colorWithRGBString:@"50bca3"];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [headerView addSubview:self.cycleScrollView];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, kScreenWidth / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0: //  今日分润
        {
//            WPTodayProfitController *vc = [[WPTodayProfitController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: //  分润余额
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                WPProfitBalanceController *vc = [[WPProfitBalanceController alloc] init];
                vc.moneyString = [NSString stringWithFormat:@"%.2f", self.agencyModel.benefitBalance];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 2: //  分润明细
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                WPProfitDetailController *vc = [[WPProfitDetailController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 3: //  邀请的人
        {
            WPInvitingPeopleController *vc = [[WPInvitingPeopleController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: //  升级代理
        {
            if ([WPJudgeTool isIDCardApprove])
            {
                if (self.agencyModel.isAgreeAg == 1)
                {
                    WPProductController *vc = [[WPProductController alloc] init];
                    vc.navigationItem.title = @"代理升级";
                    vc.isAgencyView = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    WPAgencyprotocolController *vc = [[WPAgencyprotocolController alloc] init];
                    __weakSelf
                    vc.agreeBlock = ^
                    {
                        WPProductController *vc = [[WPProductController alloc] init];
                        vc.navigationItem.title = @"代理升级";
                        vc.isAgencyView = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }
            else
            {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
            break;
        }
        case 5: //  代理介绍
        {
            WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
            vc.navigationItem.title = @"代理介绍";
            vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPDelegateAgentWebURL];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}



#pragma mark - Data

- (void)getCycleScrollData
{
    NSDictionary *parameters = @{
                                 @"bannerCode" : @"3"
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPCycleScrollURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.pictureArray addObjectsFromArray:result[@"home_banner"]];
            [weakSelf.cycleScrollView reloadInputViews];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)getAgencyData
{
    __weakSelf
    [WPHelpTool getWithURL:WPAgencyURL parameters:nil success:^(id success)
    {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray removeAllObjects];
            weakSelf.agencyModel = [WPAgencyModel mj_objectWithKeyValues:result];
            
            NSString *todayProfitStr = [NSString stringWithFormat:@"今日分润\n%@(元)", [NSString stringWithFormat:@"%.2f", weakSelf.agencyModel.todayBenef]];
            NSString *profitBalanceStr = [NSString stringWithFormat:@"分润余额\n%@(元)", [NSString stringWithFormat:@"%.2f", weakSelf.agencyModel.benefitBalance]];
            [weakSelf.dataArray addObjectsFromArray:@[todayProfitStr, profitBalanceStr, @"分润明细", @"邀请的人", @"代理升级", @"代理介绍"]];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
