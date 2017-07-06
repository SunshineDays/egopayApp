//
//  WPUserTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+WPExtension.h"

@interface WPUserTool : NSObject

/**
 * 支付方式名数组
 */
+ (NSMutableArray *)payTypeTitleArray;

/**
 * 支付方式图片数组
 */
+ (NSMutableArray *)payTypeImageArray;

/**
 * 支付银行图片
 */
+ (UIImage *)payBankImageCode:(NSString *)imageCode;

/**
 * 第三方支付图片
 */
+ (UIImage *)payTypeImageWith:(NSInteger)row;

/**
 *  支付类型ID
 */
+ (NSString *)payTypeNumberWith:(NSInteger)row;

/**
 *  支付方式名
 */
+ (NSString *)payTypeTitleWith:(NSInteger)row;

/**
 *  代理等级
 */
+ (NSString *)userMemberVipWith:(NSInteger)vipID;

/**
 *  会员等级
 */
+ (NSString *)userAgencyVipWith:(NSInteger)vipID;

/**
 * 支付方式图片
 */
+ (UIImage *)typeImageWith:(NSInteger)typeID;

/**
 *  支付状态
 *  失败, 成功, 取消, 待处理, 待确认, 待返回, 异常单
 */
+ (NSString *)typeStateWith:(NSInteger)typeID;

/**
 *  支付状态字体颜色
 */
+ (NSString *)typeStateColorWith:(NSInteger)typeID;

/**
 *  支付目的
 *  充值, 转账, 还款, 提现到卡, 付款, 二维码收款, 退款, 提现到余额, 商户升级, 代理升级
 */
+ (NSString *)typePurposeWith:(NSInteger)typeID;

/**
 *  支付方式
 *  银行卡, 微信, 支付宝, 余额, 国际信用卡, QQ钱包
 */
+ (NSString *)typeWayWith:(NSInteger)typeID;


@end
