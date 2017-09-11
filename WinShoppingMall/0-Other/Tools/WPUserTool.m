//
//  WPUserTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserTool.h"
#import "UIColor+WPExtension.h"

@implementation WPUserTool

/** 支付方式名数组 */
+ (NSMutableArray *)payTypeTitleArray
{
    return [NSMutableArray arrayWithArray:@[@"微信支付", @"支付宝支付", @"QQ钱包支付", @"余额支付"]];
}


/**  支付方式ID数组 */
+ (NSMutableArray *)payTypeIDArray
{                             //微信支付, 支付宝支付, QQ钱包支付, 余额支付
    return [NSMutableArray arrayWithArray:@[@"2", @"3", @"6", @"4"]];
}


/** 支付方式图片数组 */
+ (NSMutableArray *)payTypeImageArray
{                                        //微信支付, 支付宝支付, QQ钱包支付, 余额支付
    return [NSMutableArray arrayWithArray:@[@"icon_weixin_content_n", @"icon_zhifubao_content_n", @"qqIcon", @"icon_yue_content_n"]];
}


/** 支付银行图片 */
+ (UIImage *)payBankImageWithBankCode:(NSString *)imageCode
{
    UIImage *resultImage = [UIImage imageNamed:[NSString stringWithFormat:@"BANK_%@", imageCode]];
    if (!resultImage)
    {
        resultImage = [UIImage imageNamed:@"icon_yinhang_n"];
    }
    return resultImage;
}


/**  会员等级 */
+ (NSString *)userMemberVipWithMerchantlvID:(NSInteger)vipID
{
    NSArray *memberVipArray = @[@" ", @"白银会员", @"黄金会员", @"铂金会员", @"钻石会员"];
    return memberVipArray[vipID];
}


/**  代理等级 */
+ (NSString *)userAgencyVipWithAgentGradeID:(NSInteger)vipID
{
    NSArray *agencyVipArray = @[@"您还不是代理", @"银牌代理", @"金牌代理", @"钻石代理", @"黑钻代理"];
    return agencyVipArray[vipID];
}


/**  支付状态 */
+ (NSString *)billTypeStateWithModel:(WPBillModel *)model
{
    NSString *str = @"待处理";
    
                     // 充值、转账、付款、商户升级、代理升级
    NSArray *array = @[@"1", @"2", @"5", @"9", @"10"];
    for (int i = 0; i < array.count; i++)
    {
        if (model.tradeType == [array[i] integerValue])
        {
            str = @"待支付";
        }
    }
    
    NSArray *stateArray = @[@"失败", @"成功", @"", @"已取消", str, @"待确认", @"待返回", @"异常单", @"", @""];
    
    return stateArray[model.payState];
}


/**  支付状态字体颜色 */
+ (UIColor *)billTypeStateColorWithModel:(WPBillModel *)model
{
    NSArray *stateColorArray = @[@"EE3B3B", @"", @"", @"909090", @"50bca3", @"50bca3", @"50bca3", @"EE3B3B", @"", @""];
    return [UIColor colorWithRGBString:stateColorArray[model.payState]];
}

/**  支付目的 */
+ (NSString *)billTypePurposeWithModel:(WPBillModel *)model
{
    NSArray *typeArray = @[@"", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @"", @""];
    return typeArray[model.tradeType];
}


/**  支付目的图片 */
+ (UIImage *)billTypeImageWithModel:(WPBillModel *)model
{
    NSArray *imageArray = @[@"", @"icon_chongzhi_content_n", @"icon_zhuanzhangi_content_n", @"icon_huankuan_content_n", @"icon_tixian_content_n", @"icon_fukuan_content_n", @"icon_shoukuanma_content_n", @"icon_fukuan_content_n", @"icon_tixian_content_n", @"icon_shanghushengji_n", @"icon_shanghushengji_n", @"", @""];
    return [UIImage imageNamed:imageArray[model.tradeType]];
}


/**  支付方式 */
+ (NSString *)billTypeWayWithModel:(WPBillModel *)model
{
    NSArray *wayArray = @[@"", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @"京东钱包", @""];
    return wayArray[model.paychannelid];
}


@end
