//
//  WPAppTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAppTool.h"
#import "WPUserInfor.h"

@implementation WPAppTool


+ (BOOL)isPassIDCardApprove
{
    if ([[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isPassShopApprove
{
    if ([[WPUserInfor sharedWPUserInfor].shopPassType isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isHavePayPassword
{
    if ([[WPUserInfor sharedWPUserInfor].payPasswordType isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isSubAccount
{
    if ([[WPUserInfor sharedWPUserInfor].isSubAccount isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isPayTouchID
{
    if ([[WPUserInfor sharedWPUserInfor].payTouchID isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isRegisterTouchID
{
    if ([[WPUserInfor sharedWPUserInfor].registerTouchID isEqualToString:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
