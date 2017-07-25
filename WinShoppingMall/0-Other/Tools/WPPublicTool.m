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


// NSString -> base64
+ (NSString *)base64EncodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}


// base64 -> NSString
+ (NSString *)base64DecodeString:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


// base64 -> Data
+ (NSData *)base64ToData:(NSString *)imageStr
{
    NSURL *url = [NSURL URLWithString:imageStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}


// NSString -> Date String
+ (NSString *)stringToDateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"MMM d, yyyy h:mm:ss aa"]; //得到的时间字符串的格式
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:inputDate];
    NSDate *localDate = [inputDate dateByAddingTimeInterval:interval];
    
    NSString *dateString = [NSString stringWithFormat:@"%@", localDate];
    if (dateString.length > 9)
    {
        dateString = [dateString substringToIndex:dateString.length - 9];
    }
    return dateString;
}


// NSString -> Date String
// 把一个秒字符串 转化为真正的本地时间   @"1419055200" -> 日期字符串
+ (NSString *)stringDateFromNumberTimer:(NSString *)timerStr
{
    double t = [timerStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df stringFromDate:date];
}


// UIImage -> NSStirng
+ (NSString *)imageToString:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.2f);
    NSString *imageString = [data base64EncodedStringWithOptions:0];
    return imageString;
}


// 动态计算手续费
+ (NSString *)stringPoundageWithString:(NSString *)moneyStr rate:(float)rate
{
    float money = [moneyStr floatValue];
    float poundage = money * rate;
    
    NSString *poundageStr = [NSString stringWithFormat:@"%.2f X %.2f%@ = %.2f", money, rate * 100, @"%", poundage];
    
    return poundageStr;
}


// 字符串转 -> 带*的字符串
+ (NSString *)stringStarWithString:(NSString *)string headerIndex:(NSInteger)headerIndex footerIndex:(NSInteger)footerIndex
{
    NSString *headerStr = headerIndex == 0 ? @"" : [string substringToIndex:headerIndex];
    NSString *footherStr = footerIndex == 0 ? @"" : [string substringWithRange:NSMakeRange(string.length - footerIndex, footerIndex)];
    NSInteger hiddenLength = string.length - headerIndex - footerIndex;
    NSString *hiddenStr = @"";
    for (int i = 0; i < hiddenLength; i++)
    {
        hiddenStr = [NSString stringWithFormat:@"%@%@", hiddenStr, [NSString stringWithFormat:@"%@", i % 4 == 0 ? @" *" : @"*"]];
    }
    NSString *resultStr = [NSString stringWithFormat:@"%@%@ %@", headerStr, hiddenStr, footherStr];
    
    return resultStr;
}


// 改变字符串部分颜色
+ (NSAttributedString *)stringColorWithString:(NSString *)string replaceColor:(UIColor *)replaceColor index:(NSInteger)index
{
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [[colorString string] rangeOfString:[string substringFromIndex:index]];
    [colorString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WPFontDefaultSize] range:range];
    [colorString addAttribute:NSForegroundColorAttributeName value:replaceColor range:range];
    return colorString;
}


// 银行字符串 -> XX银行 尾号XXXX
+ (NSString *)stringCardNameWithModel:(WPBankCardModel *)model
{
    NSString *resultString;
    NSString *cardNumber = model.cardNumber;
    cardNumber = [self base64DecodeString:cardNumber];
    cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
    resultString = [NSString stringWithFormat:@"%@\n\n尾号%@", model.bankName, cardNumber];
    return resultString;
}


//动态计算文本高度(可设置最小高度)
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat) textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    
    if (rect.size.height < miniHeight - 15)
    {
        return miniHeight;
    }
    else
    {
        return rect.size.height + 15;
    }
}


// 根据文本框内容动态调节button颜色以及交互状态
+ (void)buttonWithButton:(WPButton *)button userInteractionEnabled:(BOOL)enabled
{
    button.userInteractionEnabled = enabled;
    if (enabled)
    {
        [button setBackgroundColor:[UIColor themeColor]];
        [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundColor:[UIColor buttonBackgroundDefaultColor]];
        [button setTitleColor:[UIColor buttonTitleDefaultColor] forState:UIControlStateNormal];
    }
}


// 选择银行卡支付
+ (NSString *)payCardWithView:(WPCardTableViewCell *)cardView model:(WPBankCardModel *)model
{
    [cardView.contentLabel setAttributedText:[self stringColorWithString:[self stringCardNameWithModel:model] replaceColor:[UIColor placeholderColor] index:model.bankName.length]];

    cardView.cardImageView.image = [WPUserTool payBankImageWithBankCode:model.bankCode];
    
    return @"1";
}


//  选择第三方、余额支付
+ (NSString *)payThirdWithView:(WPCardTableViewCell *)cardView rowType:(NSString *)rowType
{
    NSInteger row = [rowType integerValue];
    
    cardView.contentLabel.text = [WPUserTool payTypeTitleArray][row];
    cardView.cardImageView.image = [UIImage imageNamed:[WPUserTool payTypeImageArray][row]];
    
    return [WPUserTool payTypeIDArray][row];
}


@end
