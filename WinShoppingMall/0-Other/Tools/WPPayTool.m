//
//  WPPayTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayTool.h"
#import "WPPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WPAppConst.h"
#import "WPKeyChainTool.h"
#import "WPJudgeTool.h"
#import "WPHelpTool.h"

@implementation WPPayTool

#pragma mark - 支付输入密码弹窗
+ (void)payWithViewTitle:(NSString *)title success:(void (^)(id success))success
{
    WPPayPasswordController *vc = [[WPPayPasswordController alloc] init];
    vc.titleString = title;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.payPasswordBlock = ^(NSString *payPassword)
    {
        if (success)
        {
            success(payPassword);
        }
    };
    vc.forgetPasswordBlock = ^
    {
        WPPasswordController *vc = [[WPPasswordController alloc] init];
        vc.passwordType = @"2";
        [[WPHelpTool rootViewController] pushViewController:vc animated:YES];
    };
    [[WPHelpTool rootViewController] presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - Touch ID
+ (void)payWithTouchIDsuccess:(void (^)(id success))touchIDSuccess failure:(void (^)(NSError *error))touchIDFailure
{
    //初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹，用于登录" reply:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 //验证成功，主线程处理UI
                 dispatch_sync(dispatch_get_main_queue(), ^
                               {
                                   if (touchIDSuccess)
                                   {
                                       touchIDSuccess([WPKeyChainTool keyChainReadforKey:kUserPayPassword]);
                                   }
                               });
             }
             else
             {
                 switch (error.code)
                 {
                     case LAErrorSystemCancel:
                     {
                         //系统取消验证Touch ID
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              if (touchIDFailure)
                              {
                                  touchIDFailure(error);
                              }
                          }];
                         break;
                     }
                     case LAErrorUserCancel:
                     {
                         //用户取消验证Touch ID
                         break;
                     }
                     case LAErrorUserFallback:
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              if (touchIDFailure)
                              {
                                  touchIDFailure(error);
                              }
                          }];
                         break;
                     }
                     default:
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              //其他情况，切换主线程处理
                              [[NSOperationQueue mainQueue] addOperationWithBlock:^
                               {
                                   if (touchIDFailure)
                                   {
                                       touchIDFailure(error);
                                   }
                               }];
                          }];
                         break;
                     }
                 }
             }
         }];
    }
    //不支持指纹识别
    else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             if (touchIDFailure)
             {
                 touchIDFailure(error);
             }
         }];
    }
}


+ (void)payWithTitle:(NSString *)title password:(void (^)(id password))password
{
    //初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //判断设备支持状态和用户是否开通指纹支付
    BOOL isTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error] && [WPJudgeTool isPayTouchID];
    //支持指纹验证
    if (isTouchID)
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹，用于支付" reply:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 //验证成功，主线程处理UI
                 dispatch_sync(dispatch_get_main_queue(), ^
                               {
                                   if (password)
                                   {
                                       password([WPKeyChainTool keyChainReadforKey:kUserPayPassword]);
                                   }
                               });
             }
             else
             {
                 switch (error.code)
                 {
                     case LAErrorSystemCancel:
                     {
                         //系统取消验证Touch ID
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              if (password)
                              {
                                  WPPayPasswordController *vc = [[WPPayPasswordController alloc] init];
                                  vc.titleString = title;
                                  vc.modalPresentationStyle = UIModalPresentationCustom;
                                  vc.payPasswordBlock = ^(NSString *payPassword)
                                  {
                                      if (password)
                                      {
                                          password(payPassword);
                                      }
                                  };
                                  vc.forgetPasswordBlock = ^
                                  {
                                      WPPasswordController *vc = [[WPPasswordController alloc] init];
                                      vc.passwordType = @"2";
                                      [[WPHelpTool rootViewController] pushViewController:vc animated:YES];
                                  };
                                  [[WPHelpTool rootViewController] presentViewController:vc animated:YES completion:nil];
                                  
                              }
                          }];
                         break;
                     }
                     case LAErrorUserCancel:
                     {
                         //用户取消验证Touch ID
                         break;
                     }
                     case LAErrorUserFallback:
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              if (password)
                              {
                                  WPPayPasswordController *vc = [[WPPayPasswordController alloc] init];
                                  vc.titleString = title;
                                  vc.modalPresentationStyle = UIModalPresentationCustom;
                                  vc.payPasswordBlock = ^(NSString *payPassword)
                                  {
                                      if (password)
                                      {
                                          password(payPassword);
                                      }
                                  };
                                  vc.forgetPasswordBlock = ^
                                  {
                                      WPPasswordController *vc = [[WPPasswordController alloc] init];
                                      vc.passwordType = @"2";
                                      [[WPHelpTool rootViewController] pushViewController:vc animated:YES];
                                  };
                                  [[WPHelpTool rootViewController] presentViewController:vc animated:YES completion:nil];
                                  
                              }
                          }];
                         break;
                     }
                     default:
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^
                          {
                              if (password)
                              {
                                  WPPayPasswordController *vc = [[WPPayPasswordController alloc] init];
                                  vc.titleString = title;
                                  vc.modalPresentationStyle = UIModalPresentationCustom;
                                  vc.payPasswordBlock = ^(NSString *payPassword)
                                  {
                                      if (password)
                                      {
                                          password(payPassword);
                                      }
                                  };
                                  vc.forgetPasswordBlock = ^
                                  {
                                      WPPasswordController *vc = [[WPPasswordController alloc] init];
                                      vc.passwordType = @"2";
                                      [[WPHelpTool rootViewController] pushViewController:vc animated:YES];
                                  };
                                  [[WPHelpTool rootViewController] presentViewController:vc animated:YES completion:nil];
                                  
                              }
                          }];
                         break;
                     }
                 }
             }
         }];
    }
    //不支持指纹识别
    else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             if (password)
             {
                 WPPayPasswordController *vc = [[WPPayPasswordController alloc] init];
                 vc.titleString = title;
                 vc.modalPresentationStyle = UIModalPresentationCustom;
                 vc.payPasswordBlock = ^(NSString *payPassword)
                 {
                     if (password)
                     {
                         password(payPassword);
                     }
                 };
                 vc.forgetPasswordBlock = ^
                 {
                     WPPasswordController *vc = [[WPPasswordController alloc] init];
                     vc.passwordType = @"2";
                     [[WPHelpTool rootViewController] pushViewController:vc animated:YES];
                 };
                 [[WPHelpTool rootViewController] presentViewController:vc animated:YES completion:nil];
             }
         }];
    }
}


@end
