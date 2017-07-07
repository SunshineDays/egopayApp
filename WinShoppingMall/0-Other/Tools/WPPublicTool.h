//
//  WPPublicTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProgressHUD.h"
#import "WPButton.h"

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


/**
 *  把一个秒字符串 转化为真正的本地时间
 *  @"1419055200" -> 转化 日期字符串
 */
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;

/**
 * 动态计算手续费
 */
+ (NSString *)stringWithRateMoney:(NSString *)moneyStr rate:(float)rate;

/**
 * 字符串 -> 带*的字符串
 * eg: ***3456 , 李*
 */
+ (NSString *)stringWithStarString:(NSString *)string headerIndex:(NSInteger)headerIndex footerIndex:(NSInteger)footerIndex;

/**
 *  银行字符串 -> XX银行 尾号XXXX
 */
+ (NSString *)stringWithCardName:(NSString *)bankName cardNumber:(NSString *)cardNumber;

/**
 * 改变字符串部分颜色
 */
+ (NSAttributedString *)stringColorWithString:(NSString *)string replaceColor:(UIColor *)replaceColor index:(NSInteger)index;

/**
 *  image -> NSString
 */
+ (NSString *)imageToString:(UIImage *)image;

/**
 * 动态计算文本高度（可设置最小高度）
 **/
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size;

/**
 * 根据文本框内容动态调节button颜色
 */
+ (void)buttonWithButton:(WPButton *)button userInteractionEnabled:(BOOL)enabled;


@end
