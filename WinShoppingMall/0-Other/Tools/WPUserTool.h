//
//  WPUserTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+WPExtension.h"
#import "WPBillModel.h"

@interface WPUserTool : NSObject

/**
 *  第三方／余额支付名称数组
 *  微信支付, 支付宝支付, QQ钱包支付, 余额支付
 */
+ (NSMutableArray *)payTypeTitleArray;


/**
 *  第三方／余额支付ID数组
 */
+ (NSMutableArray *)payTypeIDArray;


/**
 *  第三方／余额支付图片数组
 */
+ (NSMutableArray *)payTypeImageArray;


/**
 *  支付银行图片
 */
+ (UIImage *)payBankImageWithBankCode:(NSString *)imageCode;


/**
 *  会员等级
 */
+ (NSString *)userMemberVipWithMerchantlvID:(NSInteger)vipID;


/**
 *  代理等级
 */
+ (NSString *)userAgencyVipWithAgentGradeID:(NSInteger)vipID;


/**
 *  支付状态
 *  失败, 成功, 取消, 待处理, 待确认, 待返回, 异常单
 */
+ (NSString *)billTypeStateWithModel:(WPBillModel *)model;


/**
 *  支付状态字体颜色
 */
+ (UIColor *)billTypeStateColorWithModel:(WPBillModel *)model;


/**
 *  支付目的
 *  充值, 转账, 还款, 提现到卡, 付款, 二维码收款, 退款, 提现到余额, 商户升级, 代理升级
 */
+ (NSString *)billTypePurposeWithModel:(WPBillModel *)model;


/**
 * 支付目的图片
 */
+ (UIImage *)billTypeImageWithModel:(WPBillModel *)model;


/**
 *  支付方式
 *  银行卡, 微信, 支付宝, 余额, 国际信用卡, QQ钱包
 */
+ (NSString *)billTypeWayWithModel:(WPBillModel *)model;


@end
