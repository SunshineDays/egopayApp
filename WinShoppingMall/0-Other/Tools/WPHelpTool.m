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
#import "WPProgressHUD.h"
#import "WPPayTypeSelectController.h"
#import "WPPayCodeController.h"
#import "WPShareView.h"
#import "WPShareTool.h"
#import "WPBaseViewController.h"
#import "WPSuccessOrfailedController.h"


@implementation WPHelpTool

#pragma mark - 数据请求

/** GET请求 */
+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    __weakSelf
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        [manager GET:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url]
          parameters:[weakSelf joiningTogetherParameters:parameters]
            progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             // \n解析错误，把\n转化为\\n
             NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
             NSData *resultData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
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
    }];
    [operationQueue addOperation:blockOperation];
    
}

/** POST请求 */
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    __weakSelf
    NSBlockOperation *blockoperation = [NSBlockOperation blockOperationWithBlock:^{
        [WPProgressHUD showProgressIsLoading];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 40;
        
        [manager POST:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url]
           parameters:[weakSelf joiningTogetherParameters:parameters]
             progress:^(NSProgress * _Nonnull uploadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             // 把\n转化为\\n
             NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             dataString = [dataString stringByReplacingOccurrencesOfString:@"" withString:@"\\n"];
             
             NSData *resultData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
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
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             if (failure)
             {
                 [WPProgressHUD dismiss];
                 [WPProgressHUD showInfoWithStatus:@"网络错误,请重试"];
                 failure(error);
             }
         }];
    }];
    [operationQueue addOperation:blockoperation];
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

#pragma mark - 选择支付方式弹窗
+ (void)showPayTypeWithAmount:(NSString *)amount card:(void (^)(WPBankCardModel *model))card other:(void (^)(id rowType))other
{
    WPPayTypeSelectController *vc = [[WPPayTypeSelectController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.isBalance = [amount floatValue] > 0 ? YES : NO; // 判断是否需要余额支付
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
    
    [[self rootViewController] presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 返回指定界面
+ (void)popToViewController:(UIViewController *)controller
{
    for (UIViewController *ctr in ((UINavigationController *)[self rootViewController]).viewControllers)
    {
        if ([ctr isKindOfClass:[controller class]])
        {
            [[self rootViewController] popToViewController:ctr animated:YES];
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
    
    [[self rootViewController] presentViewController:alertController animated:YES completion:nil];
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

    [[self rootViewController] presentViewController:alertController animated:YES completion:nil];
    
}

#pragma marl - 分享
+ (void)shareToAppWithModel:(WPShareModel *)model
{
    if (model.title.length > 0)
    {
        WPShareView *shareView = [[WPShareView alloc] initShareToApp];
        [shareView setShareBlock:^(NSString *appType)
        {
            if ([appType isEqualToString:@"二维码"])
            {
                WPPayCodeController *vc = [[WPPayCodeController alloc] init];
                vc.codeUrl = model.webpageUrl;
                vc.codeType = 2;

                [[self rootViewController] pushViewController:vc animated:YES];
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
+ (void)payResultControllerWithTitle:(NSString *)title successResult:(id)successResult
{
    NSString *type = [NSString stringWithFormat:@"%@", successResult[@"type"]];
    NSDictionary *result = successResult[@"result"];
    if ([type isEqualToString:@"1"])
    {
        WPSuccessOrfailedController *vc = [[WPSuccessOrfailedController alloc] init];
        vc.navigationItem.title = title;
        [[self rootViewController] pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"3"])
    {
        WPQRCodeModel *codeModel = [WPQRCodeModel mj_objectWithKeyValues:result];
        
        WPPayCodeController *vc = [[WPPayCodeController alloc] init];
        vc.codeType = 1;
        vc.codeModel = codeModel;
        
        [[self rootViewController] pushViewController:vc animated:YES];
    }
}


+ (id)rootViewController
{
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    
    return rootViewController;
}



@end
