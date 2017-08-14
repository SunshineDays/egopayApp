//
//  WPSubAccountPersonalController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountPersonalController.h"
#import "WPRechargeCell.h"
#import "WPSubAccountPersonalModel.h"
#import "Header.h"
#import "WPRegisterController.h"
#import "WPUserInforButton.h"
#import "WPMessagesCenterController.h"
#import "WPPayCodeController.h"
#import "WPBillController.h"
#import "WPBankCardController.h"
#import "WPMerchantController.h"
#import "WPShareModel.h"
#import "WPMyCodeController.h"
#import "WPPersonalButton.h"
#import "WPPersonalSettingController.h"

static NSString * const WPRechargeCellID = @"WPRechargeCellID";

@interface WPSubAccountPersonalController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WPPersonalButton *headerButton;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WPSubAccountPersonalModel *model;

@property (nonatomic, strong) WPShareModel *shareModel;

@end

@implementation WPSubAccountPersonalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"我";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getSubAccountInforData];
    }];
    [self.indicatorView startAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getSubAccountInforData];
    if (self.shareModel.webpageUrl.length == 0)
    {
        [self getShareData];
    }
}

#pragma mark - Init

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (WPPersonalButton *)headerButton
{
    if (!_headerButton) {
        _headerButton = [[WPPersonalButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95) avaterUrl:self.model.headUrl phone:[NSString stringWithFormat:@"商户号:  %@", self.model.merchant] vip:self.model.clerkName];
        [_headerButton addTarget:self action:@selector(changeAvater) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableHeaderView = _headerButton;
    }
    return _headerButton;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPRechargeCell class]) bundle:nil] forCellReuseIdentifier:WPRechargeCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:WPRechargeCellID];
    cell.bankImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.bankNameLabel.text = self.dataArray[indexPath.row];
    if (!([self.imageArray[indexPath.row] isEqualToString:@"icon_yue_n"] || [self.imageArray[indexPath.row] isEqualToString:@"icon_duizhang_content_n"] || [self.imageArray[indexPath.row] isEqualToString:@"today_income"])) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.dataArray[indexPath.row] isEqualToString:@"收款码"])
    {
        WPMyCodeController *vc = [[WPMyCodeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"收款账单"])
    {
        WPBillController *vc = [[WPBillController alloc] init];
        vc.isCheck = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"银行卡"])
    {
        WPBankCardController *vc = [[WPBankCardController alloc] init];
        vc.showCardType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"商家"])
    {
        WPMerchantController *vc= [[WPMerchantController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"系统消息"])
    {
        WPMessagesCenterController *vc = [[WPMessagesCenterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.dataArray[indexPath.row] isEqualToString:@"分享易购付"])
    {
        [WPHelpTool shareToAppWithModel:self.shareModel];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self postAvatarData:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Acition

- (void)rightItemAction
{
    WPPersonalSettingController *vc = [[WPPersonalSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeAvater
{
    [self alertControllerWithPhoto:YES];
}

#pragma mark - Data
- (void)getSubAccountInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPSubAccountInforURL parameters:nil success:^(id success)
    {
        [weakSelf.indicatorView stopAnimating];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.imageArray removeAllObjects];
            weakSelf.model = [WPSubAccountPersonalModel mj_objectWithKeyValues:result];
            NSString *balance = [NSString stringWithFormat:@"%.2f", weakSelf.model.avl_balance];
            NSString *todayQrIncome = [NSString stringWithFormat:@"%.2f", weakSelf.model.todayQrIncome];
            
            NSArray *dictKeyArray = @[@"balance", @"today_income", @"qr_pic", @"qr_bill", @"bankcards", @"mer_shops", @"sys_msgs", @"refer_pps"];
            NSArray *titleArray = @[[NSString stringWithFormat:@"主账户余额：%@(元)", balance], [NSString stringWithFormat:@"今日收入：%@(元)", todayQrIncome], @"收款码", @"收款账单", @"银行卡", @"商家", @"系统消息", @"推荐"];
            NSArray *imageArray = @[@"icon_yue_n", @"icon_duizhang_content_n", @"icon_shoukuanma_content_n",@"icon_zhangdan_content_n", @"icon_yinhang_n", @"icon_shangjiai_content_n", @"icon_xiaoxi_content_n", @"icon_tuijian_content_n"];
            for (int i = 0; i < dictKeyArray.count; i++)
            {
                if ([[NSString stringWithFormat:@"%@", weakSelf.model.resources[dictKeyArray[i]]] isEqualToString:@"1"])
                {
                    [weakSelf.dataArray addObject:titleArray[i]];
                    [weakSelf.imageArray addObject:imageArray[i]];
                }
            }
            [weakSelf headerButton];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error)
    {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)postAvatarData:(UIImage *)image
{
    __weakSelf
    
    NSDictionary *parameters = @{@"headImg" : [WPPublicTool imageToString:image]};
    [WPHelpTool postWithURL:WPSubAccountAvatarURL parameters:parameters success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         if ([type isEqualToString:@"1"])
         {
             weakSelf.headerButton.avaterImageView.image = image;
         }
     } failure:^(NSError *error)
     {
         
     }];
}

- (void)getShareData
{
    __weakSelf
    [WPHelpTool getWithURL:WPShareToAppURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.shareModel = [WPShareModel mj_objectWithKeyValues:result];
        }
    } failure:^(NSError *error)
    {
    }];
}



@end
