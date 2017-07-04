//
//  Header.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "WPAppConst.h"
#import "WPUserInfor.h"
#import "WPProgressHUD.h"
#import "UIColor+WPExtension.h"
#import <MJExtension/MJExtension.h>
//#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import "WPPublicTool.h"
//#import "IQKeyboardManager.h"
#import "UIColor+WPColor.h"
#import "NSURL+WPExtension.h"
#import "UIImageView+WebCache.h"
#import "WPHelpTool.h"
#import "WPRegex.h"
#import "MJRefresh.h"
#import "WPKeyChainTool.h"
#import "WPRowTableViewCell.h"
#import "WPButton.h"
#import "WPPasswordController.h"
//#import "UIBarButtonItem+WPExtention.h"


/***  自定义Log函数 ***/
#ifdef DEBUG // 如果定义了DEBUG这个宏，说明是处在调试阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 不是调试阶段，是发布阶段
#define NSLog(...)
#endif

/**************************  从这里开始写宏定义 ************************************/

/** 打印方法 */
#define NSLogFunc NSLog(@"%s", __func__);
/** 打印错误信息  */
#define NSLogError  NSLog(@"_____error______ = %@",error);
/**  打印是否销毁   */
#define NSLogDealloc  - (void)dealloc {  NSLogFunc  }

/**  self弱引用 */
#define __weakSelf __weak typeof(self) weakSelf = self;
/**  self强引用 */
#define __strongSelf  __strong __typeof(self) strongSelf = weakSelf;

/**  判断手机的系统版本 */
#define iOS(v) ([UIDevice currentDevice].systemVersion.doubleValue >= (v))


// 屏幕尺寸
#define kScreenSize [UIScreen mainScreen].bounds.size
// 屏幕宽度
#define kScreenWidth kScreenSize.width
// 屏幕高度
#define kScreenHeight kScreenSize.height


#endif /* Header_h */
