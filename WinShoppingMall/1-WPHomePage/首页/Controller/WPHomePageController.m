//
//  WPHomePageController.m
//  WinShoppingMall
//  主页
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPHomePageController.h"
#import "WPBillController.h"
#import "WPMerchantController.h"
#import "WPGatheringController.h"
#import "WPQRCodeController.h"
#import "WPRegisterController.h"
#import "WPHomeButton.h"
#import "Header.h"
#import <SDCycleScrollView.h>
#import "WPGatheringCodeController.h"
#import "WPJpushServiceController.h"
#import "WPShareView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocialQQHandler.h"
#import "WPShareTool.h"
#import "WPMessagesCell.h"
#import "WPMessageDetailController.h"
#import "WPUserRechargeController.h"
#import "WPUserWithDrawController.h"
#import "WPUserTransferController.h"
#import "WPUserCreditCardPayController.h"

static NSString * const WPMessagesCellID = @"WPMessagesCellID";


@interface WPHomePageController ()<SDCycleScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, strong) UIButton *creditCardButton;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDescription;
@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation WPHomePageController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[WPUserInfor sharedWPUserInfor].threeTouch isEqualToString:@"gatheringCode"]) {
        __weakSelf
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeType = 2;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].userInfoDict = nil;
            [WPUserInfor sharedWPUserInfor].threeTouch = nil;
        });
    }
    
    else if ([WPUserInfor sharedWPUserInfor].userInfoDict) {
        __weakSelf
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WPJpushServiceController *vc = [[WPJpushServiceController alloc] init];
            vc.resultDict = [WPUserInfor sharedWPUserInfor].userInfoDict;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].threeTouch = nil;
            [WPUserInfor sharedWPUserInfor].userInfoDict = nil;
        });
    }

    [self getmessgaesData];
    [self initButtonClassView];
    [self initCreditCard];
    [self getCycleScrollData];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getmessgaesData];
        [weakSelf getCycleScrollData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    if (!self.shareTitle) {
        [self getShareData];
    }
}

#pragma mark - Init

- (NSMutableArray *)pictureArray
{
    if (!_pictureArray) {
        _pictureArray =[NSMutableArray array];
    }
    return _pictureArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2 + 200 + 80)];
    }
    return _headerView;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2);
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"icon_Selected"]];
        _cycleScrollView.localizationImageNamesGroup = self.pictureArray;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self.headerView addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (void)initButtonClassView
{
    NSArray *array = @[@"充值", @"提现", @"账单", @"扫码", @"商家", @"收款", @"转账", @"推荐"];
    NSArray *imageArray = @[ @"icon_chongzhi_content_n", @"icon_tixian_content_n", @"icon_zhangdan_content_n", @"icon_saoma_content_n", @"icon_shangjiai_content_n", @"icon_shoukuan_content_n", @"icon_zhuanzhangi_content_n", @"icon_tuijian_content_n"];
    CGFloat width = (kScreenWidth - 2 * WPLeftMargin) / 4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [WPHomeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WPLeftMargin + width * (i % 4), kScreenWidth / 2 + 90 * (i / 4), width, 90);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        button.tag = i;
        [button addTarget:self action:@selector(topClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 50) / 2, 20, 50, 50)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [button addSubview:imageView];
    }
}

- (void)initCreditCard
{
    self.creditCardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenWidth / 2 + 200, kScreenWidth, 80)];
    self.creditCardButton.backgroundColor = [UIColor themeColor];
    self.creditCardButton.titleLabel.numberOfLines = 0;
    [self.creditCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.creditCardButton addTarget:self action:@selector(creditCardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.creditCardButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 80)];
    titleLabel.text = @"Credit Card Payment\n\n国际信用卡";
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.creditCardButton addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + 20, 10, kScreenWidth / 2 - 30, 60)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"icon_visajcb_content_n"];
    [self.creditCardButton addSubview:imageView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMessagesCell class]) bundle:nil] forCellReuseIdentifier:WPMessagesCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:WPMessagesCellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPMessagesModel *model = self.dataArray[indexPath.row];
    WPMessageDetailController *vc =[[WPMessageDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)topClassButtonClick:(UIButton *)button{
    switch (button.tag) {
        case 0: {
            // 充值
            WPUserRechargeController *vc = [[WPUserRechargeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            // 提现
            if ([WPAppTool isPassIDCardApprove]) {
                WPUserWithDrawController *vc = [[WPUserWithDrawController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
        case 2: {
            // 账单
            WPBillController *vc = [[WPBillController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            // 扫码
            [WPProgressHUD showInfoWithStatus:@"敬请期待"];
//            WPQRCodeController *vc = [[WPQRCodeController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            // 商户
            WPMerchantController *vc= [[WPMerchantController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            // 收款
            WPGatheringController *vc = [[WPGatheringController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            // 转账
            if ([WPAppTool isPassIDCardApprove]) {
                WPUserTransferController *vc = [[WPUserTransferController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
            }
        }
            break;
        case 7: {
            // 推荐
            [self shareToApp];

        }
            break;
        default:
            break;
    }
}

- (void)shareToApp
{
    WPShareView *shareView = [[WPShareView alloc] initShareToApp];
    __weakSelf
    [shareView setShareBlock:^(NSString *appType){
        WPShareTool *shareTool = [[WPShareTool alloc] init];
        if ([appType isEqualToString:@"二维码"])
        {
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeString = weakSelf.shareUrl;
            vc.codeType = 3;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [shareTool shareWithUrl:weakSelf.shareUrl title:weakSelf.shareTitle description:weakSelf.shareDescription appType:appType];
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

- (void)creditCardButtonClick {
    if ([WPAppTool isPassIDCardApprove]) {
        WPUserCreditCardPayController *vc = [[WPUserCreditCardPayController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
    }
}

#pragma mark - Data

- (void)getCycleScrollData {
    NSDictionary *parameters = @{
                                 @"bannerCode" : @"1"
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

- (void)getmessgaesData {
    
    NSDictionary *parameters = @{
                                 @"curPage" : @"1"
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPMessageURL parameters:parameters success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:[WPMessagesModel mj_objectArrayWithKeyValuesArray:result[@"msgList"]]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)getShareData {
    __weakSelf
    [WPHelpTool getWithURL:WPShareToAppURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.shareTitle = result[@"title"];
            weakSelf.shareDescription = result[@"description"];
            weakSelf.shareUrl = result[@"webpageUrl"];
        }
    } failure:^(NSError *error) {
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
