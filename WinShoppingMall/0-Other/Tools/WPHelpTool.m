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

@implementation WPHelpTool

#pragma mark - 数据请求

+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    
    [manager GET:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url]
      parameters:[self joiningTogetherParameters:parameters]
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if (success) {
                 success(dict);
             }
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", WPBaseURL, url] parameters:[self joiningTogetherParameters:parameters] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


//  拼接参数
+ (NSMutableDictionary *)joiningTogetherParameters:(NSDictionary *)paramters
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if ([WPUserInfor sharedWPUserInfor].clientId.length > 0) {
        NSDictionary *publicParameter = @{
                                          @"clientId" : [WPUserInfor sharedWPUserInfor].clientId
                                          };
        [parameter addEntriesFromDictionary:publicParameter];
    }
    [parameter addEntriesFromDictionary:paramters];
    
    return parameter;
}

#pragma mark - 数据显示

+ (void)wp_endRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array
{
    [scrollView.mj_header endRefreshing];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)scrollView reloadData];
    }
    if (array.count < 20) {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [scrollView.mj_footer endRefreshing];
    }
}


+ (void)wp_endRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title
{
    if (scrollView.mj_header) {
        [scrollView.mj_header endRefreshing];
    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)scrollView reloadData];
    }
    if (array.count < 20) {
        if (scrollView.mj_footer) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    else {
        if (scrollView.mj_footer) {
            [scrollView.mj_footer endRefreshing];
        }
    }
    
    if (array.count == 0) {
        [noResultLabel showOnSuperView:scrollView title:title];
    }
    else {
        [noResultLabel hidden];
    }
}

+ (void)messageEndRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title
{
    [scrollView.mj_header endRefreshing];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }
    else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)scrollView reloadData];
    }
    if (array.count < 10) {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [scrollView.mj_footer endRefreshing];
    }
    
    if (array.count == 0) {
        [noResultLabel showOnSuperView:scrollView title:title];
    }
    else {
        [noResultLabel hidden];
    }
}

+ (void)popToViewController:(UIViewController *)popController viewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    for (UIViewController *controller in viewControllers) {
        if ([controller isKindOfClass:[popController class]]) {
//            popController *vc = (popController *)controller;
        }
    }
}

+ (void)payWithTouchIDsuccess:(void (^)(id))touchIDSuccess failure:(void (^)(NSError *error))touchIDFailure
{
    //初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (touchIDSuccess) {
                        touchIDSuccess([WPKeyChainTool keyChainReadforKey:kUserPayPassword]);
                    }
                });
            }
            else
            {
                //                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
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
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
//                            if (weakSelf.touchIDBlock) {
//                                weakSelf.touchIDBlock(@"");
//                            }
                            if (touchIDFailure) {
                                touchIDFailure(error);
                            }
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
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
        
    }
}


@end
