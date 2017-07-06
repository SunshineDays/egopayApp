//
//  WPDelegateController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPDelegateController.h"
 
#import "UIView+WPExtension.h"
#import <SDCycleScrollView.h>
#import "Header.h"
#import "WPTodayProfitController.h"
#import "WPProfitBalanceController.h"
#import "WPProfitDetailController.h"
#import "WPBillController.h"
#import "WPProductController.h"
#import "WPPublicWebViewController.h"
#import "WPDelegateAgreementController.h"
#import "WPInvitingPeopleController.h"

@interface WPDelegateController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, copy) NSString *todayProfit;

@property (nonatomic, copy) NSString *profitBalance;

//  是否同意代理协议
@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, copy) NSString *agreementString;

@end

@implementation WPDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.indicatorView startAnimating];
    self.navigationItem.title = @"代理";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getDelegateData];
    [self getCycleScrollData];
}

- (NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenWidth / 2);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"icon_Selected"]];
        _cycleScrollView.localizationImageNamesGroup = self.pictureArray;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self.view addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + kScreenWidth / 2, kScreenWidth, 300)];
        _contentView.userInteractionEnabled = YES;
        [self.view addSubview:_contentView];
        
        NSString *todayProfitStr = [NSString stringWithFormat:@"今日分润\n%@(元)", self
                                    .todayProfit];
        NSString *profitBalanceStr = [NSString stringWithFormat:@"分润余额\n%@(元)", self.profitBalance];
        NSArray *array = @[todayProfitStr, profitBalanceStr, @"分润明细", @"邀请的人", @"代理升级", @"代理介绍"];
        float width = (kScreenWidth - 2 * WPLeftMargin - 30) / 2;
        
        for (NSInteger i = 0; i < array.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin + (width + 30) * (i % 2), 10 + (80 + 20) * (i / 2), width, 80)];
            button.backgroundColor = i == 0 || i == 3 || i == 4 ? [UIColor themeColor] : [UIColor colorWithRGBString:@"50bca3"];
            button.titleLabel.numberOfLines = 0;
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(delegateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
        }
    }
    return _contentView;
}

- (void)cyclicPictureClick:(UIButton *)button {
    
    
}

- (void)delegateButtonClick:(UIButton *)button {
    switch (button.tag) {
            //  今日分润
        case 0: {
//            WPTodayProfitController *vc = [[WPTodayProfitController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            //  分润余额
        case 1: {
            WPProfitBalanceController *vc = [[WPProfitBalanceController alloc] init];
            vc.moneyString = self.profitBalance;
//            WPWithdrawController *vc = [[WPWithdrawController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            //  分润明细
        case 2: {
            WPProfitDetailController *vc = [[WPProfitDetailController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            //  邀请的人
        case 3: {
            WPInvitingPeopleController *vc = [[WPInvitingPeopleController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            //  升级代理
        case 4: {
            if ([WPAppTool isPassIDCardApprove]) {
                if (self.isAgree) {
                    WPProductController *vc = [[WPProductController alloc] init];
                    vc.navigationItem.title = @"代理升级";
                    vc.isDelegateView = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    WPDelegateAgreementController *vc = [[WPDelegateAgreementController alloc] init];
                    vc.agreementString = self.agreementString;
                    __weakSelf
                    vc.agreeBlock = ^{
                        WPProductController *vc = [[WPProductController alloc] init];
                        vc.navigationItem.title = @"代理升级";
                        vc.isDelegateView = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
            
            //  代理介绍
        case 5: {
            WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
            vc.navigationItem.title = @"代理介绍";
            vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPDelegateAgentWebURL];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Data

- (void)getCycleScrollData {
    NSDictionary *parameters = @{
                                 @"bannerCode" : @"3"
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

- (void)getDelegateData
{
    __weakSelf
    [WPHelpTool getWithURL:WPDelegateURL parameters:nil success:^(id success) {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            
            weakSelf.todayProfit = [NSString stringWithFormat:@"%.2f", [result[@"todayBenef"] floatValue]];
            weakSelf.profitBalance = [NSString stringWithFormat:@"%.2f", [result[@"benefitBalance"] floatValue]];
            weakSelf.isAgree = [[NSString stringWithFormat:@"%@", result[@"isAgreeAg"]] isEqualToString:@"1"] ? YES : NO;
            weakSelf.agreementString = [NSString stringWithFormat:@"%@", result[@"agAgreement"]];
            weakSelf.contentView = nil;
            [weakSelf contentView];
        }
    } failure:^(NSError *error) {
        [weakSelf.indicatorView stopAnimating];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
