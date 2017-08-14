//
//  WPJudgeTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPJudgeTool.h"
#import "WPUserInfor.h"

@implementation WPJudgeTool

#pragma mark - User Infor

/** 判断是否通过实名认证 */
+ (BOOL)isIDCardApprove
{
    return [[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"] ? YES : NO;
}

/** 判断是否通过商家认证 */
+ (BOOL)isShopApprove
{
    return [[WPUserInfor sharedWPUserInfor].shopPassType isEqualToString:@"YES"] ? YES : NO;
}

/** 判断是否有支付密码 */
+ (BOOL)isPayPassword
{
    return [[WPUserInfor sharedWPUserInfor].payPasswordType isEqualToString:@"YES"] ? YES : NO;
}

/** 判断是否是子账户 */
+ (BOOL)isSubAccount
{
    return [[WPUserInfor sharedWPUserInfor].isSubAccount isEqualToString:@"YES"] ? YES : NO;
}

/** 判断是否设置指纹支付 */
+ (BOOL)isPayTouchID
{
    return [[WPUserInfor sharedWPUserInfor].payTouchID isEqualToString:@"YES"] ? YES : NO;
}

/** 判断是否设置指纹登录 */
+ (BOOL)isRegisterTouchID
{
    return [[WPUserInfor sharedWPUserInfor].registerTouchID isEqualToString:@"YES"] ? YES : NO;
}

#pragma mark - 正则表达式

/** 验证手机号 */
+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13,15,17,18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/** 验证固定电话 */
+ (BOOL)validateTel:(NSString *)tel
{
    //010,020,021,022,023,024,025,027,028,029,400
    NSString *phoneRegex = @"^((0(10|2[0-5789]|\\d{3}))|(400))\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:tel];
}


/** 验证邮箱 */
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 验证身份证号码 */
+ (BOOL)validateIDCard:(NSString *)idCard
{
    BOOL flag;
    if (idCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}

/** 验证用户名 */
+ (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

/** 验证昵称 */
+ (BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

/** 验证密码 */
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

#pragma mark - UITextField

/** 验证价格 */
+ (BOOL)validatePrice:(NSString *)textField range:(NSRange)range replacementString:(NSString *)string
{
    if ([string length] == 0)
    {
        return YES;
    }
    else if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') //数据格式正确
        {
            if([textField length] == 0)
            {
                if(single == '.') //首字母不能为小数点
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
            if ([textField length] == 1)
            {
                if ([textField isEqualToString:@"0"] && single != '.') //首字母为0时，只能以0.开头
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
            if (single == '.')
            {
                if([textField rangeOfString:@"."].location == NSNotFound) //text中还没有小数点
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                if([textField rangeOfString:@"."].location != NSNotFound) //text中有小数点
                {
                    NSRange ran = [textField rangeOfString:@"."];
                    if (range.location - ran.location <= 2)  //小数只有两位
                    {
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

/** 验证是否是空格 */
+ (BOOL)validateSpace:(NSString *)string
{    
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}



@end
