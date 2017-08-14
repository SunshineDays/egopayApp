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
#import "WPBankCardModel.h"
#import "WPQRCodeModel.h"
#import "WPShareModel.h"

@interface WPHelpTool : NSObject

/**
 *  GET请求
 */
+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure;


/**
 *  POST请求
 */
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id success))success failure:(void (^)(NSError *error))failure;


/**
 *  数据显示,无提示信息
 */
+ (void)endRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array;


/**
 *  数据显示,有提示信息
 */
+ (void)endRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title;


/**
 * 消息中心一页10条数据，擦！
 */
+ (void)messageEndRefreshingOnView:(UIScrollView *)scrollView array:(NSArray *)array noResultLabel:(WPNoResultLabel *)noResultLabel title:(NSString *)title;


/**
 * 选择支付方式弹窗
 */
+ (void)showPayTypeWithAmount:(NSString *)amount card:(void (^)(WPBankCardModel *model))card other:(void (^)(id rowType))other;


/**
 *  返回指定界面
 */
+ (void)popToViewController:(UIViewController *)controller;


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


/**
 * 分享
 */
+ (void)shareToAppWithModel:(WPShareModel *)model;


/**
 *  支付结果界面
 */
+ (void)payResultControllerWithTitle:(NSString *)title successResult:(id)successResultnavigationControlle;

+ (id)rootViewController;


@end
