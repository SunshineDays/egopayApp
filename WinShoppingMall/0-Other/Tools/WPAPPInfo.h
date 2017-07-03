//
//  WPAPPInfo.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WPSingleton.h"


@interface WPAPPInfo : NSObject

Single_Interface(WPAPPInfo)

/** 网络状态 */
@property (nonatomic,copy) NSString *networkType;

/**
 *  获取Version版本号
 */
+ (NSString *)APPVersion;

/**
 *  获取Build版本号
 */
+ (NSString *)APPBuild;

/**
 *  获取设备deviceId
 */
+ (NSString *)deviceId;

/**
 *  获取 当前设备版本
 */
+ (double)iOSVersion;


@end
