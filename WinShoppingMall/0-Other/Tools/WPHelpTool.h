//
//  WPHelpTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/14.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+MJRefresh.h"
#import "WPProgressHUD.h"
#import "WPNoResultLabel.h"

@interface WPHelpTool : NSObject

/**
 *  GET请求
 */
+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

/**
 *  POST请求
 */
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

/**
 *  数据显示,无提示信息
 */
+ (void)wp_endRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array;

/**
 *  数据显示,有提示信息
 */
+ (void)wp_endRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title;

/**
 * 消息中心一页10条数据，擦！
 */
+ (void)messageEndRefreshWith:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title;

/**
 * Touch ID
 */
+ (void)payWithTouchIDsuccess:(void (^)(id))touchIDSuccess failure:(void (^)(NSError *error))touchIDFailure;

/**
 * 获取日期数组
 * monthNumber : 需要几个月
 */
+ (NSMutableArray *)dateArrayWithMonthNumber:(NSInteger)monthNumber;


/**
 *  返回指定界面
 */
+ (void)popToViewController:(UIViewController *)controller navigationController:(UINavigationController *)navigationController;

/**
 * 跳转到根控制器动画
 */
+ (void)rootViewController:(UIViewController *)controller;

/**
 * 弹出UIAlertController
 * UIAlertControllerStyleAlert
 */
+ (void)alertControllerTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle confirm:(void (^)(UIAlertAction *alertAction))confirm cancel:(void (^)(UIAlertAction *alertAction))cancel;

/**
 * 弹出UIAlertController
 * UIAlertControllerStyleActionSheet
 */
+ (void)alertControllerTitle:(NSString *)title rowOneTitle:(NSString *)rowOneTitle rowTwoTitle:(NSString *)rowTwoTitle rowOne:(void (^)(UIAlertAction *alertAction))rowOne rowTwo:(void (^)(UIAlertAction *alertAction))rowTwo;

@end
