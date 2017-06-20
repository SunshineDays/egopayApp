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

@interface WPQRCodeController ()


@end

@implementation WPQRCodeController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描二维码";
    
    [self initDevice];
    
}

#pragma mark - Init

- (void)initDevice {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (!deviceInput) {
        [self presentViewController:self.alertCtr animated:YES completion:nil];
    }
    else {
        VPScanQrCodeView *scanView = [[VPScanQrCodeView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) andMaskViewWidth:222 andBorderColor:[UIColor redColor]];
        [self.view addSubview:scanView];
    }

}

#pragma mark - Action



#pragma mark - Methods



#pragma mark - Data




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
