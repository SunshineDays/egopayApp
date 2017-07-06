//
//  WPUserTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserTool.h"

@implementation WPUserTool

+ (NSMutableArray *)payTypeTitleArray
{
    return [NSMutableArray arrayWithArray:@[@"微信支付", @"支付宝支付", @"QQ钱包支付", @"余额支付"]];
}

+ (NSMutableArray *)payTypeImageArray
{
    return [NSMutableArray arrayWithArray:@[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"]];
}

+ (UIImage *)payBankImageCode:(NSString *)imageCode
{
    UIImage *resultImage = [UIImage imageNamed:[NSString stringWithFormat:@"BANK_%@", imageCode]];
    if (!resultImage) {
        resultImage = [UIImage imageNamed:@"icon_yinhang_n"];
    }
    return resultImage;
}

+ (UIImage *)payTypeImageWith:(NSInteger)row
{
    return [UIImage imageNamed:[self payTypeImageArray][row]];
}

+ (NSString *)payTypeTitleWith:(NSInteger)row
{
    return [self payTypeTitleArray][row];
}

+ (NSString *)payTypeNumberWith:(NSInteger)row
{
    NSArray *payTypeArray = @[@"2", @"3", @"6", @"4"];
    return payTypeArray[row];
}

+ (NSString *)userMemberVipWith:(NSInteger)vipID
{
    NSArray *memberVipArray = @[@"白银会员",@"黄金会员", @"铂金会员", @"钻石会员"];
    return memberVipArray[vipID - 1];
}

+ (NSString *)userAgencyVipWith:(NSInteger)vipID
{
    NSArray *agencyVipArray = @[@"您还不是代理哦", @"银牌代理", @"金牌代理", @"钻石代理", @"黑钻代理"];
    return agencyVipArray[vipID];
}

+ (UIImage *)typeImageWith:(NSInteger)typeID
{
    NSArray *imageArray = @[@"", @"icon_chongzhi_content_n", @"icon_zhuanzhangi_content_n", @"icon_huankuan_content_n", @"icon_tixian_content_n", @"icon_fukuan_content_n", @"icon_shoukuanma_content_n", @"icon_fukuan_content_n", @"icon_tixian_content_n", @"icon_shanghushengji_n", @"icon_shanghushengji_n"];
    return [UIImage imageNamed:imageArray[typeID]];
}

+ (NSString *)typeStateWith:(NSInteger)typeID
{
    NSArray *stateArray = @[@"失败", @"成功", @"取消", @"待处理", @"待确认", @"待返回", @"异常单", @" ", @" "];
    return stateArray[typeID];
}

+ (NSString *)typeStateColorWith:(NSInteger)typeID
{
    NSArray *stateColorArray = @[@"EE3B3B", @"", @"", @"909090", @"50bca3", @"50bca3", @"50bca3", @"EE3B3B", @" ", @" "];
    return stateColorArray[typeID];
}

+ (NSString *)typePurposeWith:(NSInteger)typeID
{
    NSArray *typeArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @" ", @" "];
    return typeArray[typeID];
}

+ (NSString *)typeWayWith:(NSInteger)typeID
{
    NSArray *wayArray = @[@" ", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @" ", @" "];
    return wayArray[typeID];
}

@end
