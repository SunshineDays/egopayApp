//
//  WPKeyChainTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPKeyChainTool : NSObject

/**
 *  存储字符串到 KeyChain
 *
 */
+ (void)keyChainSave:(NSString *)string forKey:(NSString *)sKey;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @return NSString
 */
+ (NSString *)keyChainReadforKey:(NSString *)sKey;

/**
 *  删除 KeyChain 信息
 */
+ (void)keyChainDelete;



@end
