//
//  WPAppRegisters.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAppRegisters.h"
#import "WPUserInfor.h"
#import <AdSupport/AdSupport.h>
#import <JPush/JPUSHService.h>
#import "OpenShareHeader.h"
#import "WPJudgeTool.h"

/** 友盟的apiKey */
//NSString * const kGetUMAppkey = @"591bc4f58630f57b330013c2";

/** 微信 */
static NSString * const kWeChat_AppID = @"wxa2e49f2b1fd0f1a0";
static NSString * const kWeChat_AppSecret = @"c55dd72333184f3cc27c3c0674c1e932";

/** QQ */
NSString * const kQQ_AppID = @"1106169312";
NSString * const kQQ_AppKey = @"Dv5lJFRDlu8vSOjz";

/** 极光推送 */
static NSString * const kJPush_AppKey = @"55f5117c0a951e9a96623403";
static NSString * const kJPush_MasterSecret = @"77ba49ce163388addcd23c8a";

static NSString * const channel = @"AppStore";
static BOOL const isProduction = FALSE;


@interface WPAppRegisters ()

@end

@implementation WPAppRegisters

#pragma mark - 设置用户信息

+ (void)registUserInfor
{
    [WPUserInfor sharedWPUserInfor].clientId = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserDefaultClientId];
    [WPUserInfor sharedWPUserInfor].approvePassType = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserApprovePass];
    [WPUserInfor sharedWPUserInfor].payPasswordType = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserHasPayPassword];
    [WPUserInfor sharedWPUserInfor].shopPassType = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserShopPass];
    [WPUserInfor sharedWPUserInfor].userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserPhone];
    [WPUserInfor sharedWPUserInfor].payTouchID = [[NSUserDefaults standardUserDefaults] objectForKey:WPPayTouchID];
    [WPUserInfor sharedWPUserInfor].registerTouchID = [[NSUserDefaults standardUserDefaults] objectForKey:WPRegisterTouchID];
    [WPUserInfor sharedWPUserInfor].isSubAccount = [[NSUserDefaults standardUserDefaults] objectForKey:WPIsSubAccount];
    
    [[WPUserInfor sharedWPUserInfor] updateUserInfor];
}

+ (void)registThirdApp
{
    [OpenShare connectQQWithAppId:kQQ_AppID];
    [OpenShare connectWeixinWithAppId:kWeChat_AppID];
}

//#pragma mark - 注册极光推送
+ (void)registJPushWithLaunchOption:(NSDictionary *)launchOptions
{
    NSString *advertisingID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert
                                          categories:nil];
    [JPUSHService crashLogON];
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPush_AppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingID];
}

#pragma mark - 注册3D Touch
+ (void)regist3DTouch:(UIApplication *)application
{
    if ([WPJudgeTool isShopApprove]) // 通过商家认证之后才有收款码
    {
        UIApplicationShortcutIcon *codeIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_shoukuanma_content_n"];
        UIApplicationShortcutItem *codeItem = [[UIApplicationShortcutItem alloc] initWithType:@"TWO" localizedTitle:@"我的收款码" localizedSubtitle:nil icon:codeIcon userInfo:nil];
        application.shortcutItems = @[codeItem];
    }
}


@end
