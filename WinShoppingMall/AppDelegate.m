//
//  AppDelegate.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "AppDelegate.h"
#import "WPAppRegisters.h"
#import "WPChooseInterface.h"
#import <UserNotifications/UserNotifications.h>
#import <JPush/JPUSHService.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NSURL+WPExtension.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    NSUncaughtExceptionHandler *_uncaughtExceptionHandler;
}
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
    [WPUserInfor sharedWPUserInfor].userInfoDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    return YES;
}

#pragma mark - 注册极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark - 推送 ios 10.0
//前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

// 后台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    completionHandler();
    [WPUserInfor sharedWPUserInfor].userInfoDict = response.notification.request.content.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"jpushService" userInfo:[WPUserInfor sharedWPUserInfor].userInfoDict];
}

#pragma mark - 推送 ios 7.0 - 10.0

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        //  app在前台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"jpushService" userInfo:userInfo];
            [WPUserInfor sharedWPUserInfor].userInfoDict = userInfo;
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"jpushService" userInfo:userInfo];
            [WPUserInfor sharedWPUserInfor].userInfoDict = userInfo;
        }
    }
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - 3D Touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"TWO"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationReceiveSuccess object:@"gatheringCode" userInfo:nil];
        [WPUserInfor sharedWPUserInfor].threeTouch = @"gatheringCode";
    }
}

#pragma mark - app从后台进入程序
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


@end