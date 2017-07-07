//
//  WPUserTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserTool.h"

@implementation WPUserTool

/** 支付方式名数组 */
+ (NSMutableArray *)payTypeTitleArray
{
    return [NSMutableArray arrayWithArray:@[@"微信支付", @"支付宝支付", @"QQ钱包支付", @"余额支付"]];
}

/** 支付方式图片数组 */
+ (NSMutableArray *)payTypeImageArray
{
    return [NSMutableArray arrayWithArray:@[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"]];
}

/** 支付银行图片 */
+ (UIImage *)payBankImageCode:(NSString *)imageCode
{
    UIImage *resultImage = [UIImage imageNamed:[NSString stringWithFormat:@"BANK_%@", imageCode]];
    if (!resultImage) {
        resultImage = [UIImage imageNamed:@"icon_yinhang_n"];
    }
    return resultImage;
}

/**  选择的第三方支付图片 */
+ (UIImage *)payTypeImageWith:(NSInteger)row
{
    return [UIImage imageNamed:[self payTypeImageArray][row]];
}

/**  选择的支付方式名 */
+ (NSString *)payTypeTitleWith:(NSInteger)row
{
    return [self payTypeTitleArray][row];
}

/**  选择的支付类型ID */
+ (NSString *)payTypeNumberWith:(NSInteger)row
{
    NSArray *payTypeArray = @[@"2", @"3", @"6", @"4"];
    return payTypeArray[row];
}

/**  代理等级 */
+ (NSString *)userMemberVipWith:(NSInteger)vipID
{
    NSArray *memberVipArray = @[@"白银会员",@"黄金会员", @"铂金会员", @"钻石会员"];
    return memberVipArray[vipID - 1];
}

/**  会员等级 */
+ (NSString *)userAgencyVipWith:(NSInteger)vipID
{
    NSArray *agencyVipArray = @[@"您还不是代理", @"银牌代理", @"金牌代理", @"钻石代理", @"黑钻代理"];
    return agencyVipArray[vipID];
}

/**  账单支付方式图片 */
+ (UIImage *)typeImageWith:(NSInteger)typeID
{
    NSArray *imageArray = @[@"", @"icon_chongzhi_content_n", @"icon_zhuanzhangi_content_n", @"icon_huankuan_content_n", @"icon_tixian_content_n", @"icon_fukuan_content_n", @"icon_shoukuanma_content_n", @"icon_fukuan_content_n", @"icon_tixian_content_n", @"icon_shanghushengji_n", @"icon_shanghushengji_n", @"", @""];
    return [UIImage imageNamed:imageArray[typeID]];
}

/**  支付状态 */
+ (NSString *)typeStateWith:(NSInteger)typeID
{
    NSArray *stateArray = @[@"失败", @"成功", @"", @"取消", @"待处理", @"待确认", @"待返回", @"异常单", @" ", @" "];
    return stateArray[typeID];
}

/**  支付状态字体颜色 */
+ (NSString *)typeStateColorWith:(NSInteger)typeID
{
    NSArray *stateColorArray = @[@"EE3B3B", @"", @"", @"909090", @"50bca3", @"50bca3", @"50bca3", @"EE3B3B", @" ", @" "];
    return stateColorArray[typeID];
}

/**  支付目的 */
+ (NSString *)typePurposeWith:(NSInteger)typeID
{
    NSArray *typeArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @" ", @" "];
    return typeArray[typeID];
}

/**  支付方式 */
+ (NSString *)typeWayWith:(NSInteger)typeID
{
    NSArray *wayArray = @[@" ", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @"京东钱包", @" "];
    return wayArray[typeID];
}

/**  日期数组 */
+ (NSMutableArray *)dateArrayWithMonthNumber:(NSInteger)monthNumber
{
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger year = [[formatter stringFromDate:date] integerValue];
    
    [formatter setDateFormat:@"MM"];
    NSInteger month = [[formatter stringFromDate:date] integerValue];
    
    for (int i = 0; i < monthNumber; i++) {
        if (month < 1) {
            month = month + 12;
            year = year - 1;
        }
        NSString *monthString = month < 10 ? [NSString stringWithFormat:@"0%ld", (long)month] : [NSString stringWithFormat:@"%ld", (long)month];
        NSString *dateString = [NSString stringWithFormat:@"%ld年%@月", (long)year, monthString];
        [dateArray addObject:dateString];
        month --;
    }
    return dateArray;
}

@end
