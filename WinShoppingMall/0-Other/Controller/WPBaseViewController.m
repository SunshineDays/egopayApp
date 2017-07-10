//
//  WPBaseViewController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPRegisterController.h"
#import "Header.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreLocation/CoreLocation.h>
#import "WPGatheringCodeController.h"
#import "WPJpushServiceController.h"
#import "WPNavigationController.h"
#import "JPUSHService.h"


@interface WPBaseViewController () <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation WPBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noResultLabel = [[WPNoResultLabel alloc] init];
    //  防止UITableView下拉不回弹
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self getBaseUserInforTypeData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSucces:) name:WPNotificationReceiveSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRegisterAgain) name:WPNotificationUserLogout object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationReceiveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationUserLogout object:nil];
    
}

- (void)receiveSucces:(NSNotification *)notification
{
    if (self.navigationItem) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([notification.object isEqualToString:@"gatheringCode"]) {
        WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
        vc.codeType = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([notification.object isEqualToString:@"jpushService"]) {
        WPJpushServiceController *vc = [[WPJpushServiceController alloc] init];
        vc.resultDict = notification.userInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Init

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
        _indicatorView.color = [UIColor darkGrayColor];
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark - 判断用户是否设置过支付密码
- (void)getBaseUserInforTypeData
{
    //  判断是否登录
    if ([WPUserInfor sharedWPUserInfor].clientId.length != 0) {
        
        //  如果没有实名认证或者没有支付密码
        if (!([WPAppTool isHavePayPassword] && [WPAppTool isPassIDCardApprove])) {
            
            [WPHelpTool getWithURL:WPUserHasCardURL parameters:nil success:^(id success) {
                NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
                
                //  没有实名认证
                if ([type isEqualToString:@"0"]) {
                    [WPUserInfor sharedWPUserInfor].approvePassType = @"NO";
                }
                //  通过实名认证
                else {
                    [WPUserInfor sharedWPUserInfor].approvePassType = @"YES";
                    
                    //  有支付密码
                    if ([type isEqualToString:@"1"]) {
                        [WPUserInfor sharedWPUserInfor].payPasswordType = @"YES";
                    }
                    //  没有支付密码
                    else if ([type isEqualToString:@"2"]) {
                        [WPUserInfor sharedWPUserInfor].payPasswordType = @"NO";
                    }
                }
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 重新登录

- (void)userRegisterAgain
{
    __weakSelf
    [WPHelpTool alertControllerTitle:@"登录超时，请重新登录" confirmTitle:@"重新登录" confirm:^(UIAlertAction *alertAction) {
        [weakSelf userQuitRegister];
    } cancel:nil];
}

- (void)userQuitRegister
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    WPRegisterController *vc = [[WPRegisterController alloc] init];
    WPNavigationController *navi = [[WPNavigationController alloc] initWithRootViewController:vc];
    [WPHelpTool rootViewController:navi];
    
    [WPUserInfor sharedWPUserInfor].clientId = nil;
    [[WPUserInfor sharedWPUserInfor] updateUserInfor];
    
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        if (iResCode == 0) {//对应的状态码返回为0，代表成功
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
        }
    }];
    [self getUserLogout ];
}

- (void)getUserLogout
{
    [WPHelpTool getWithURL:WPUserLogoutURL parameters:nil success:^(id success) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertControllerWithPhoto:(BOOL)isPhoto
{
    __weakSelf
    UIImagePickerController *imagePicControl = [[UIImagePickerController alloc] init];
    imagePicControl.delegate = self;
    imagePicControl.allowsEditing = YES;
    [WPHelpTool alertControllerTitle:nil rowOneTitle:@"拍照" rowTwoTitle:isPhoto ? @"从相册中选择" : nil rowOne:^(UIAlertAction *alertAction) {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
        if (!deviceInput) {
            [WPHelpTool alertControllerTitle:@"请在系统设置中开启权限（设置>隐私>相机/相册>开启）" confirmTitle:@"确定" confirm:nil cancel:nil];
        }
        else {
            imagePicControl.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicControl.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [weakSelf presentViewController:imagePicControl animated:YES completion:nil];
        }
    } rowTwo:^(UIAlertAction *alertAction) {
        if (alertAction.title) {
            imagePicControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:imagePicControl animated:YES completion:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
