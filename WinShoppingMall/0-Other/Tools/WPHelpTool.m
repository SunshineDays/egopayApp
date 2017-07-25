//
//  WPHelpTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/14.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPHelpTool.h"
#import <AFNetworking/AFNetworking.h>
#import "WPAppConst.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WPProgressHUD.h"
#import "WPPayPopupController.h"
#import "WPPayTypeController.h"
#import "WPGatheringCodeController.h"
#import "WPShareView.h"
#import "WPShareTool.h"
#import "WPBaseViewController.h"
#import "WPSuccessOrfailedController.h"


@implementation WPHelpTool

#pragma mark - 数据请求

/** GET请求 */
+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    [manager GET:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url]
      parameters:[self joiningTogetherParameters:parameters]
        progress:^(NSProgress * _Nonnull downloadProgress)
    {
            
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if (success)
         {
             success(dict);
             NSString *type = [NSString stringWithFormat:@"%@", dict[@"type"]];
             if ([type isEqualToString:@"-1"])  //重新登录
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationUserLogout object:nil];
                 [WPUserInfor sharedWPUserInfor].payTouchID = nil;
                 [[WPUserInfor sharedWPUserInfor] updateUserInfor];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             failure(error);
         }
     }];
}

/** POST请求 */
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure
{
    [WPProgressHUD showProgressIsLoading];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 40;
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url]
       parameters:[self joiningTogetherParameters:parameters]
         progress:^(NSProgress * _Nonnull uploadProgress)
    {
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
 {
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if (success)
         {
             [WPProgressHUD dismiss];
             success(dict);
             NSString *type = [NSString stringWithFormat:@"%@", dict[@"type"]];
             if ([type isEqualToString:@"-1"])  //重新登录
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationUserLogout object:nil];
                 [WPUserInfor sharedWPUserInfor].payTouchID = nil;
                 [[WPUserInfor sharedWPUserInfor] updateUserInfor];
             }
             else if (dict[@"result"][@"err_msg"])
             {
                 [WPProgressHUD showInfoWithStatus:dict[@"result"][@"err_msg"]];
             }
             else if (dict[@"reuslt"][@"msg"])
             {
                 [WPProgressHUD showInfoWithStatus:dict[@"result"][@"msg"]];
             }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
     if (failure)
     {
         [WPProgressHUD dismiss];
         [WPProgressHUD showInfoWithStatus:@"网络错误,请重试"];
         failure(error);
     }
    }];
}


//  拼接参数
+ (NSMutableDictionary *)joiningTogetherParameters:(NSDictionary *)paramters
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if ([WPUserInfor sharedWPUserInfor].clientId.length > 0)
    {
        NSDictionary *publicParameter = @{
                                          @"clientId" : [WPUserInfor sharedWPUserInfor].clientId
                                          };
        [parameter addEntriesFromDictionary:publicParameter];
    }
    [parameter addEntriesFromDictionary:paramters];
    
    return parameter;
}

#pragma mark - 数据显示

/** 结束刷新提示没有更能多 */
+ (void)endRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array
{
    [scrollView.mj_header endRefreshing];
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        [(UICollectionView *)scrollView reloadData];
    }
    
    if (array.count < 20)
    {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [scrollView.mj_footer endRefreshing];
    }
}

/** 结束刷新提示没有更能多，如果没有数据(全部数据)显示提示信息 */
+ (void)endRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title
{
    if (scrollView.mj_header)
    {
        [scrollView.mj_header endRefreshing];
    }
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        [(UICollectionView *)scrollView reloadData];
    }
    
    if (array.count < 20)
    {
        if (scrollView.mj_footer)
        {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    else
    {
        if (scrollView.mj_footer)
        {
            [scrollView.mj_footer endRefreshing];
        }
    }
    if (array.count == 0)
    {
        [noResultLabel showOnSuperView:scrollView title:title];
    }
    else
    {
        [noResultLabel hidden];
    }
}

/** 消息中心服务器一页10条数据，擦 */
+ (void)messageEndRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title
{
    [scrollView.mj_header endRefreshing];
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        [(UICollectionView *)scrollView reloadData];
    }
    
    if (array.count < 10)
    {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [scrollView.mj_footer endRefreshing];
    }
    
    if (array.count == 0)
    {
        [noResultLabel showOnSuperView:scrollView title:title];
    }
    else
    {
        [noResultLabel hidden];
    }
}

#pragma mark - 支付方式弹窗
+ (void)showPayTypeWithAmount:(NSString *)amount navigationController:(UINavigationController *)navigationController Card:(void (^)(WPBankCardModel *model))card other:(void (^)(id rowType))other
{
    WPPayTypeController *vc = [[WPPayTypeController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.isBalance = amount ? YES : NO; // 判断是否需要余额支付
    vc.amount = [amount floatValue]; // 传入金额
    //银行卡支付
    vc.userCardBlock = ^(WPBankCardModel *model)
    {
        if (card)
        {
            card(model);
        }
    };
    // 第三方、余额支付
    vc.userPayTypeBlock = ^(NSInteger payTypeRow)
    {
        if (other)
        {
            other([NSString stringWithFormat:@"%ld", (long)payTypeRow]);
        }
    };
    
    [navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 支付输入密码弹窗
+ (void)showPayPasswordViewWithTitle:(NSString *)title navigationController:(UINavigationController *)navigationController success:(void (^)(id success))success
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
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
        [navigationController pushViewController:vc animated:YES];
    };
    [navigationController presentViewController:vc animated:YES completion:nil];
    
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
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError *error)
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


#pragma mark - 返回指定界面
+ (void)popToViewController:(UIViewController *)controller navigationController:(UINavigationController *)navigationController
{
    for (UIViewController *ctr in navigationController.viewControllers)
    {
        if ([ctr isKindOfClass:[controller class]])
        {
            [navigationController popToViewController:ctr animated:YES];
        }
    }
}


#pragma mark - 跳转到根控制器动画
+ (void)rootViewController:(UIViewController *)controller
{
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^
    {
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = controller;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished)
    {
        
    }];
}

#pragma mark - UIAlertController

/** UIAlertControllerStyleAlert */
+ (void)alertControllerTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle confirm:(void (^)(UIAlertAction *alertAction))confirm cancel:(void (^)(UIAlertAction *alertAction))cancel
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        if (confirm)
        {
            confirm(action);
        }
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        if (cancel)
        {
            cancel(action);
        }
    }]];
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

/** UIAlertControllerStyleActionSheet */
+ (void)alertControllerTitle:(NSString *)title rowOneTitle:(NSString *)rowOneTitle rowTwoTitle:(NSString *)rowTwoTitle rowOne:(void (^)(UIAlertAction *alertAction))rowOne rowTwo:(void (^)(UIAlertAction *alertAction))rowTwo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (rowOneTitle.length > 0)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:rowOneTitle style:([rowOneTitle containsString:@"删除"] || [rowOneTitle containsString:@"解除"]) ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            if (rowOne)
            {
                rowOne(action);
            }
        }]];
    }
    
    if (rowTwoTitle.length > 0)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:rowTwoTitle style:([rowTwoTitle containsString:@"删除"] || [rowTwoTitle containsString:@"解除"]) ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            if (rowTwo)
            {
                rowTwo(action);
            }
        }]];
    }    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        
    }]];
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

#pragma marl - 分享
+ (void)shareToAppWithModel:(WPShareModel *)model navigationController:(UINavigationController *)navigationController
{
    if (model.title.length > 0)
    {
        WPShareView *shareView = [[WPShareView alloc] initShareToApp];
        [shareView setShareBlock:^(NSString *appType)
         {
             if ([appType isEqualToString:@"二维码"])
             {
                 WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
                 vc.codeUrl = model.webpageUrl;
                 vc.codeType = 3;
                 [navigationController pushViewController:vc animated:YES];
             }
             else
             {
                 [WPShareTool shareWithModel:model appType:appType];
             }
         }];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"网络错误，请稍后"];
    }
}

#pragma mark - 支付结果界面
+ (void)payResultControllerWithTitle:(NSString *)title successResult:(id)successResult navigationController:(UINavigationController *)navigationController
{
    NSString *type = [NSString stringWithFormat:@"%@", successResult[@"type"]];
    NSDictionary *result = successResult[@"result"];
    if ([type isEqualToString:@"1"])
    {
        WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
        vc.navigationItem.title = title;
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"3"])
    {
        WPQRCodeModel *codeModel = [WPQRCodeModel mj_objectWithKeyValues:result];
        
        WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
        vc.codeType = 1;
        vc.codeModel = codeModel;
        
        [navigationController pushViewController:vc animated:YES];
    }
}


@end
