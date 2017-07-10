//
//  WPSubAccountInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountInforController.h"

#import "WPEditUserInfoController.h"
#import "UIView+WPExtension.h"
#import "WPSelectController.h"
#import "WPRegisterController.h"
#import "Header.h"
#import "WPUserInforCell.h"
#import "WPTouchIDController.h"
#import "WPPublicWebViewController.h"
#import "WPUserFeedBackController.h"
#import "JPUSHService.h"
#import <StoreKit/StoreKit.h>
#import "WPNavigationController.h"
#import "WPUserInforButton.h"
#import "WPShareView.h"
#import "WPGatheringCodeController.h"
#import "WPShareTool.h"
#import "WPAPPInfo.h"

static NSString * const WPUSerInforCellID = @"WPUSerInforCellID";

@interface WPSubAccountInforController ()  <UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WPUserInforButton *userInforButton;

@property (nonatomic, strong) UIView *footerView;;

@property (nonatomic, strong) WPButton *userLogoutButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *shareDescription;

@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation WPSubAccountInforController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    
    [self getTitle];
    [self.tableView reloadData];
    [self getShareData];
}


#pragma mark - Init

- (WPUserInforButton *)userInforButton
{
    if (!_userInforButton) {
        _userInforButton = [[WPUserInforButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _userInforButton.backgroundColor = [UIColor whiteColor];
        
        self.userInforButton.userImageView.image = self.avaterImage;
        [_userInforButton userInforWithName:[NSString stringWithFormat:@"商户号:%@", self.subAccountModel.merchant] vip:self.subAccountModel.clerkName rate:nil arrowHidden:YES];
        [_userInforButton addTarget:self action:@selector(changeAvater) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userInforButton;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        
        _userLogoutButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, 20, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_userLogoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_userLogoutButton userInteractionEnabled:YES];
        [_userLogoutButton addTarget:self action:@selector(userLogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_userLogoutButton];
    }
    return _footerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor cellColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.userInforButton;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPUserInforCell class]) bundle:nil] forCellReuseIdentifier:WPUSerInforCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WPUserInforCell *cell = [tableView dequeueReusableCellWithIdentifier:WPUSerInforCellID];
    
    switch (indexPath.section) {
        case 0: {
            cell.titleLabel.text = self.titleArray[0][indexPath.row];
            if (indexPath.row != 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
            
        case 1:
            cell.titleLabel.text = self.titleArray[1][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 2:
            cell.titleLabel.text = self.titleArray[2][indexPath.row];
            if (indexPath.row != 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WPRowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:  //手机号
                    break;
                    
                case 1: {  //安全管理
                    WPTouchIDController *vc = [[WPTouchIDController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
                case 0: {  //用户帮助
                    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
                    vc.navigationItem.title = @"用户帮助";
                    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserHelpWebURL];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 1: {  //意见反馈
                    WPUserFeedBackController *vc = [[WPUserFeedBackController alloc] init];
                    vc.navigationItem.title = @"意见反馈";
                    vc.isFeedback = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 2: {  //用户举报
                    WPUserFeedBackController *vc = [[WPUserFeedBackController alloc] init];
                    vc.navigationItem.title = @"用户举报";
                    vc.isFeedback = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 3: {  //客服电话
                    [self.view callToNum:WPAppTelNumber];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2: {
            switch (indexPath.row) {
                    
                case 0: {  //关于我们
                    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
                    vc.navigationItem.title = @"关于我们";
                    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPAboutOurWebURL];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 1: {  //分享App
                    WPShareView *shareView = [[WPShareView alloc] initShareToApp];
                    __weakSelf
                    [shareView setShareBlock:^(NSString *appType){
                        WPShareTool *shareTool = [[WPShareTool alloc] init];
                        if ([appType isEqualToString:[[WPUserTool shareWayArray] lastObject]])
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
                    break;
                    
                case 2: {  //App评分
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1240608651&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self postAvatarData:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (void)changeAvater
{
    [self alertControllerWithPhoto:YES];
}

- (void)userLogoutButtonAction:(UIButton *)button
{
    __weakSelf
    [WPHelpTool alertControllerTitle:@"确定退出登录" confirmTitle:@"确定" confirm:^(UIAlertAction *alertAction) {
        [weakSelf userQuitRegister];
    } cancel:nil];
}


#pragma mark Data

- (void)getTitle
{
    NSArray *arrayA;
    arrayA = @[[NSString stringWithFormat:@"账户号:  %@", [WPUserInfor sharedWPUserInfor].userPhone], @"安全管理"];

    NSArray *arrayB = @[@"用户帮助", @"意见反馈", @"用户举报",
                        [NSString stringWithFormat:@"客服电话:  %@", WPAppTelNumber]];
    NSArray *arrayC = @[@"关于我们", @"分享易购付App", @"App评分",
                        [NSString stringWithFormat:@"当前版本:  v%@", [WPAPPInfo APPVersion]]];
    self.titleArray = @[arrayA, arrayB, arrayC];
    
}

#pragma mark - Data

- (void)getShareData
{
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

- (void)postAvatarData:(UIImage *)image
{
    __weakSelf

    NSDictionary *parameters = @{@"headImg" : [WPPublicTool imageToString:image]};
    [WPHelpTool postWithURL:WPSubAccountAvatarURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        
        if ([type isEqualToString:@"1"]) {

            weakSelf.userInforButton.userImageView.image = image;
            if (weakSelf.avaterImageBlcok) {
                weakSelf.avaterImageBlcok(image);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
