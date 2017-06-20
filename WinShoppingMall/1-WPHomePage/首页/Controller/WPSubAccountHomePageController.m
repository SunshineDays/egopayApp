
//
//  WPSubAccountHomePageController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountHomePageController.h"
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
#import "WPBillController.h"

static NSString * const WPMessagesCellID = @"WPMessagesCellID";

@interface WPSubAccountHomePageController () <SDCycleScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

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

@implementation WPSubAccountHomePageController

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
        });
    }
    else if ([WPUserInfor sharedWPUserInfor].userInfoDict) {
        __weakSelf
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WPJpushServiceController *vc = [[WPJpushServiceController alloc] init];
            vc.resultDict = [WPUserInfor sharedWPUserInfor].userInfoDict;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].threeTouch = @"";
        });
    }
    [self getmessgaesData];
    [self initButtonClassView];
    [self getCycleScrollData];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getmessgaesData];
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
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2 + 100)];
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
    NSArray *array = @[@"收款码", @"对账", @"商家", @"推荐"];
    NSArray *imageArray = @[ @"icon_chongzhi_content_n", @"icon_tixian_content_n", @"icon_shangjiai_content_n", @"icon_tuijian_content_n"];
    CGFloat width = (kScreenWidth - 2 * WPLeftMargin) / 4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [WPHomeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WPLeftMargin + width * (i % 4), kScreenWidth / 2 + 90 * (i / 4), width, 90);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        [button addTarget:self action:@selector(topClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 50) / 2, 20, 50, 50)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [button addSubview:imageView];
    }
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
    return 50;
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
        case 0: {  // 收款码
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1: {  // 对账
            WPBillController *vc = [[WPBillController alloc] init];
            vc.isCheck = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2: {  // 商户
            WPMerchantController *vc= [[WPMerchantController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3: {  // 推荐
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
            vc.codeString = self.shareUrl;
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
        else if ([type isEqualToString:@"-1"]) {
            [weakSelf userRegisterAgain];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
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
        [weakSelf.dataArray removeAllObjects];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObjectsFromArray:[WPMessagesModel mj_objectArrayWithKeyValuesArray:result[@"msgList"]]];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
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

@end
