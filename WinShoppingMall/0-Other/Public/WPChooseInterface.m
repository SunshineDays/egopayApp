//
//  WPChooseInterface.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPChooseInterface.h"
#import "WPTouchIDShowController.h"
#import "WPNavigationController.h"

@implementation WPChooseInterface

/** info.plist中记录的版本号 */
NSString * const kAppDefaultsVersionKey = @"CFBundleShortVersionString";

+ (UIViewController *)chooseRootViewController
{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAppDefaultsVersionKey];
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *newVersion = infoDic[kAppDefaultsVersionKey];
    
    if ([oldVersion isEqualToString:newVersion]) {
        NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserDefaultClientId];
        if (clientId.length == 0) {
            WPRegisterController *vc = [[WPRegisterController alloc] init];
            WPNavigationController *navi = [[WPNavigationController alloc] initWithRootViewController:vc];
            return navi;
        }
        else {
            if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"2"]) {
//                return [[WPTouchIDShowController alloc] init];
                return [[WPTabBarController alloc] init];
            } else {
                return [[WPTabBarController alloc] init];
            }
        }
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:newVersion forKey:kAppDefaultsVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[WPNewFeatureViewController alloc] init];
    }
}

@end
