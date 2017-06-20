//
//  WPPublicTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPublicTool.h"
#import "WPChooseInterface.h"
#import "WPTabBarController.h"

//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

//空字符串
#define     LocalStr_None           @""

@implementation WPPublicTool

#pragma mark - NSString -> base64

+(NSString *)base64EncodeString:(NSString *)string
{
    //1.先把字符串转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.对二进制数据进行base64编码，返回编码后的字符串
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark - base64 -> NSString

+(NSString *)base64DecodeString:(NSString *)string
{
    //1.将base64编码后的字符串『解码』为二进制数据
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    
    //2.把二进制数据转换为字符串返回
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - base64 -> Data

+ (NSData *)base64ToData:(NSString *)imageStr
{
    NSURL *url = [NSURL URLWithString:imageStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark - NSString -> Date

+ (NSString *)dateToLocalDate:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"MMM d, yyyy h:mm:ss aa"];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:inputDate];
    NSDate *localDate = [inputDate dateByAddingTimeInterval:interval];
    
    NSString *dateString = [NSString stringWithFormat:@"%@", localDate];
    if (dateString.length > 9) {
        dateString = [dateString substringToIndex:dateString.length - 9];
    }
    return dateString;
}

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr
{
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}


//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size
{
    //iOS7之后
    /*
     第一个参数: 预设空间 宽度固定  高度预设 一个最大值
     第二个参数: 行间距
     第三个参数: 属性字典 可以设置字体大小
     */
    //xxxxxxxxxxxxxxxxxx
    //ghjdgkfgsfgskdgfjk
    //sdhgfsdjkhgfjd
    
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    //        NSString *str = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
    
    
}

//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度(可设置最小高度)
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat) textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size
{
    
    //iOS7之后
    /*
     第一个参数: 预设空间 宽度固定  高度预设 一个最大值
     第二个参数: 行间距
     第三个参数: 属性字典 可以设置字体大小
     */
    //xxxxxxxxxxxxxxxxxx
    //ghjdgkfgsfgskdgfjk
    //sdhgfsdjkhgfjd
    
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    
    if (rect.size.height < miniHeight - 15)
    {
        return miniHeight;
    }
    else
    {
        //返回计算出的行高
        return rect.size.height + 15;
    }
}

+ (NSString *)calculateMoney:(NSString *)moneyStr rate:(float)rate
{
    float money = [moneyStr floatValue];
    float poundage = money * rate;
    
    NSString *poundageStr = [NSString stringWithFormat:@"%.2f X %.2f%@ = %.2f", money, rate * 100, @"%", poundage];

    return poundageStr;
}

+ (NSString *)stringHiddenWithString:(NSString *)string headerIndex:(NSInteger)headerIndex footerIndex:(NSInteger)footerIndex
{
    NSString *headerStr = headerIndex == 0 ? @"" : [string substringToIndex:headerIndex];
    NSString *footherStr = footerIndex == 0 ? @"" : [string substringWithRange:NSMakeRange(string.length - footerIndex, footerIndex)];
    NSInteger hiddenLength = string.length - headerIndex - footerIndex;
    NSString *hiddenStr = @"";
    for (int i = 0; i < hiddenLength; i++) {
        hiddenStr = [NSString stringWithFormat:@"%@%@", hiddenStr, [NSString stringWithFormat:@"%@", i % 4 == 0 ? @" *" : @"*"]];
    }
    NSString *resultStr = [NSString stringWithFormat:@"%@%@ %@", headerStr, hiddenStr, footherStr];
    
    return resultStr;
}



@end
