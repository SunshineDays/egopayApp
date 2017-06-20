//
//  WPAPPInfo.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAPPInfo.h"


@implementation WPAPPInfo

Single_Implementation(WPAPPInfo)


+ (NSString *)APPVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)APPBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)deviceId
{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

+ (double)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}



@end
