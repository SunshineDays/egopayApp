//
//  WPQRCodeController.m
//  WinShoppingMall
//  扫码
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPQRCodeController.h"
#import "Header.h"
#import <AVFoundation/AVFoundation.h>
#import "VPScanQrCodeView.h"
#import "WPQRCodePayController.h"

@interface WPQRCodeController () <VPScanQrCodeViewDelegate>


@end

@implementation WPQRCodeController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"扫描二维码";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDevice];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [WPProgressHUD dismiss];
}

#pragma mark - Init

- (void)initDevice
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (!deviceInput)
    {
        __weakSelf
        [WPHelpTool alertControllerTitle:@"请在系统设置中开启权限（设置>隐私>相机/相册>开启）" confirmTitle:@"确定" confirm:^(UIAlertAction *alertAction)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } cancel:^(UIAlertAction *alertAction)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        VPScanQrCodeView *scanView = [[VPScanQrCodeView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight) andMaskViewWidth:222 andBorderColor:[UIColor redColor]];
        scanView.delegate = self;
        [self.view addSubview:scanView];
    }

}

#pragma mark - VPScanQrCodeViewDelegate

- (void)vpScanQrCodeCompletedWithResult:(NSString *)result
{ 
//    [WPProgressHUD showProgressIsLoading];
    WPQRCodePayController *vc = [[WPQRCodePayController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
