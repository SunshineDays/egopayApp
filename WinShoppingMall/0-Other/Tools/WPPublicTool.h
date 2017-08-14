//
//  WPPublicTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProgressHUD.h"
#import "WPCustomButton.h"
#import "WPCardTableViewCell.h"
#import "WPBankCardModel.h"

@interface WPPublicTool : NSObject

/**
 *  NSString->base64
 */
+ (NSString *)base64EncodeString:(NSString *)string;


/**
 *  base64->NSString
 */
+ (NSString *)base64DecodeString:(NSString *)string;


/**
 *  base64 -> Date String
 *  只适用于本app
 */
+ (NSData *)base64ToData:(NSString *)imageStr;


/**
 *  NSString -> Date String
 */
+ (NSString *)stringToDateString:(NSString *)dateString;


/**
 *  把一个秒字符串 转化为真正的本地时间
 *  @"1419055200" -> 转化 日期字符串
 */
+ (NSString *)stringDateFromNumberTimer:(NSString *)timerStr;


/**
 *  image -> NSString
 */
+ (NSString *)imageToString:(UIImage *)image;


/**
 * 动态计算手续费
 */
+ (NSString *)stringPoundageWithString:(NSString *)moneyStr rate:(float)rate;


/**
 * 字符串 -> 带*的字符串
 * eg: ***3456 , 李*
 */
+ (NSString *)stringStarWithString:(NSString *)string headerIndex:(NSInteger)headerIndex footerIndex:(NSInteger)footerIndex;


/**
 * 改变字符串部分颜色/字体大小
 */
+ (NSAttributedString *)stringColorWithString:(NSString *)string replaceColor:(UIColor *)replaceColor replaceFontSize:(float)replaceFontSize index:(NSInteger)index;

/**
 * 动态计算文本高度（可设置最小高度）
 **/
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size;


/**
 * 根据文本框内容动态调节button颜色
 */
+ (void)buttonWithButton:(WPButton *)button userInteractionEnabled:(BOOL)enabled;


/**
 * 选择银行卡支付
 */
+ (NSString *)payCardWithView:(WPCardTableViewCell *)cardView model:(WPBankCardModel *)model;


/**
 * 选择第三方、余额支付
 */
+ (NSString *)payThirdWithView:(WPCardTableViewCell *)cardView rowType:(NSString *)rowType;

/**
 *  清除WebView缓存
 */
+ (void)cleanCacheAndCookie;

/**
 *  显示日期
 */
+ (NSString *)dateStringWith:(NSString *)dateString;



@end
