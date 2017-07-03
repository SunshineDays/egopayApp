//
//  WPProgressHUD.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProgressHUD.h"

#import "WPUserInforController.h"
#import "WPRegisterController.h"

@implementation WPProgressHUD

#pragma mark - 蒙版提示语
NSString * const ODAlertIsLoading = nil;

+ (void)initialize
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRGBString:@"#4a4a4a" alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
}

+ (void)showProgressIsLoading
{
    [self showProgressWithStatus:ODAlertIsLoading];
}

+ (void)showProgressWithStatus:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [SVProgressHUD showInfoWithStatus:status maskType:SVProgressHUDMaskTypeNone];
}


+ (void)showSuccessWithStatus:(NSString *)status
{
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

//+ (void)showToast:(UIView *)view status:(NSString *)status
//{
//    CGPoint center = CGPointMake(view.frame.size.width / 2, view.frame.size.height - 100);
//    [view makeToast:status duration:3 position:[NSValue valueWithCGPoint:center]];
//}


@end
