//
//  WPKeyChainTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPKeyChainTool.h"
#import "WPAppConst.h"


@implementation WPKeyChainTool


+ (void)keyChainSave:(NSString *)string forKey:(NSString *)sKey
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:string forKey:sKey];
    [self save:kUserPayPassword_Infor data:tempDic];
}

+ (NSString *)keyChainReadforKey:(NSString *)sKey
{
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:kUserPayPassword_Infor];
    return [tempDic objectForKey:sKey];
}

+ (void)keyChainDelete
{
    [self delete:kUserPayPassword_Infor];
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {
            
        }
        @finally
        {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


@end
