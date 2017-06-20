//
//  NSURL+WPExtension.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "NSURL+WPExtension.h"
#import <objc/message.h>

@implementation NSURL (WPExtension)

+ (instancetype)WP_URLWithString:(NSString *)URLString
{
    NSString *string = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:string];
}

@end
