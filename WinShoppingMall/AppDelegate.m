//
//  AppDelegate.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "AppDelegate.h"
#import "WPAppRegisters.h"
#import "WPTabBarController.h"
#import "WPHomePageController.h"
#import "WPChooseInterface.h"
#import "UIImageView+WebCache.h"
#import <UserNotifications/UserNotifications.h>
#import "WPTouchIDShowController.h"
#import "WPJpushServiceController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WPGatheringCodeController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate, QQApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WPAppRegisters registUserInfor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [WPChooseInterface chooseRootViewController];
    [self.window makeKeyWindow];
    
    [WPAppRegisters registQQ];
    [WPAppRegisters registWechat];
    [WPAppRegisters registJPushWithLaunchOption:launchOptions];
    [WPAppRegisters regist3DTouch:application];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //  app在前台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
    {
//        [WPProgressHUD showInfoWithStatus:userInfo[@"aps"][@"alert"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"jpushService" userInfo:userInfo];
        [WPUserInfor sharedWPUserInfor].userInfoDict = userInfo;
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && [[[UIDevice currentDevice] systemVersion] floatValue] > 10.0)
    {
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"jpushService" userInfo:userInfo];
        [WPUserInfor sharedWPUserInfor].userInfoDict = userInfo;
    }

//    [application cancelAllLocalNotifications];
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}


- (void)applicationDidEnterBackground:(UIApplication *)application
{

    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@", @"Dv5lJFRDlu8vSOjz"]])
    {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"TWO"]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"gatheringCode" userInfo:nil];
        [WPUserInfor sharedWPUserInfor].threeTouch = @"gatheringCode";
    }
}



// 处理来至QQ的请求
- (void)onReq:(QQBaseReq *)req
{
    NSLog(@" ----req %@",req);
}

// 处理来至QQ的响应
- (void)onResp:(QQBaseResp *)resp
{
    NSLog(@" ----resp %@",resp);
    
    // SendMessageToQQResp应答帮助类
    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
        if (_qqDelegate) {
            if ([_qqDelegate respondsToSelector:@selector(shareSuccssWithQQCode:)]) {
                SendMessageToQQResp *msg = (SendMessageToQQResp *)resp;
                NSLog(@"code %@  errorDescription %@  infoType %@",resp.result,resp.errorDescription,resp.extendInfo);
                [_qqDelegate shareSuccssWithQQCode:[msg.result integerValue]];
            }
        }
    }
}

// 处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

@end
