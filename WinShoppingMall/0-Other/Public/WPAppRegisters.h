//
//  WPAppRegisters.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MobClick.h"
//#import "UMSocial.h"

#import "WPAPPInfo.h"


@interface WPAppRegisters : NSObject

+ (void)registUserInfor;

/**
 *  极光推送
 */
+ (void)registJPushWithLaunchOption:(NSDictionary *)launchOptions;

+ (void)registThirdApp;


/**
 *  3DTouch
 */
+ (void)regist3DTouch:(UIApplication *)application;





@end
