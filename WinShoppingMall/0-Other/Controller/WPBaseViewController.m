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

@interface WPBaseViewController () <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation WPBaseViewController

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

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//}

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

- (UIAlertController *)alertCtr {
    if (!_alertCtr) {
        _alertCtr = [UIAlertController alertControllerWithTitle:@"请在系统设置中开启权限（设置>隐私>相机/相册>开启）" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [_alertCtr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    }
    return _alertCtr;
}

- (UIAlertController *)alertSheet {
    if (!_alertSheet) {
        UIImagePickerController *imagePicControl = [[UIImagePickerController alloc] init];
        imagePicControl.delegate = self;
        imagePicControl.allowsEditing = YES;
        
        __weakSelf
         _alertSheet = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [_alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                NSError *error;
                AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
                if (!deviceInput) {
                    [weakSelf presentViewController:weakSelf.alertCtr animated:YES completion:nil];
                }
                else {
                    imagePicControl.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicControl.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    [weakSelf presentViewController:imagePicControl animated:YES completion:^
                     {
                     }];
                }
            }]];
        }
        [_alertSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:imagePicControl animated:YES completion:^{
                
            }];
        }]];
        [_alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alertSheet;
}

- (UIAlertController *)alertCameraSheet
{
    if (!_alertCameraSheet) {
        UIImagePickerController *imagePicControl = [[UIImagePickerController alloc] init];
        imagePicControl.delegate = self;
        imagePicControl.allowsEditing = YES;
        
        __weakSelf
        _alertCameraSheet = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertCameraSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            NSError *error;
            AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
            if (!deviceInput) {
                [weakSelf presentViewController:weakSelf.alertCtr animated:YES completion:nil];
            }
            else {
                imagePicControl.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicControl.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                [weakSelf presentViewController:imagePicControl animated:YES completion:^
                 {
                 }];
            }
        }]];
        [_alertCameraSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alertCameraSheet;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - 判断用户是否设置过支付密码
- (void)getBaseUserInforTypeData
{
    //  判断是否登录
    if ([WPUserInfor sharedWPUserInfor].clientId.length != 0) {
        
        //  如果没有实名认证或者没有支付密码
        if (!([[WPUserInfor sharedWPUserInfor].payPasswordType isEqualToString:@"YES"] && [[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"])) {
            
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

- (void)userRegisterAgain
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆超时，请重新登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    __weakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!weakSelf.navigationController) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        WPRegisterController *vc = [[WPRegisterController alloc] init];
        WPNavigationController *navi = [[WPNavigationController alloc] initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        [WPUserInfor sharedWPUserInfor].clientId = @"";
        [[WPUserInfor sharedWPUserInfor] updateUserInfor];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
