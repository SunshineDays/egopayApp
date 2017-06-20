//
//  WPPublicTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProgressHUD.h"


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
 *  base64 -> Data
 */
+ (NSData *)base64ToData:(NSString *)imageStr;


/**
 *  NSString -> Date
 */
+ (NSString *)dateToLocalDate:(NSString *)dateString;

//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高

/**
 * 动态计算文本高度
 **/
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

/**
 * 动态计算文本高度（可设置最小高度）
 **/
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size;

/**
 * 动态计算手续费
 */
+ (NSString *)calculateMoney:(NSString *)moneyStr rate:(float)rate;

/**
 * 字符串隐藏部分内容
 */
+ (NSString *)stringHiddenWithString:(NSString *)string headerIndex:(NSInteger)headerIndex footerIndex:(NSInteger)footerIndex;



@end
