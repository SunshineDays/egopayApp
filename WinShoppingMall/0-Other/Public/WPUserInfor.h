//
//  WPUserInfor.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSingleton.h"
#import "WPAppConst.h"
#import "WPUserInforModel.h"

@interface WPUserInfor : NSObject

Single_Interface(WPUserInfor)

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *clientId;

/**
 *  是否通过实名认证  YES NO
 */
@property (nonatomic, copy) NSString *approvePassType;

/**
 *  是否有支付密码  YES NO
 */
@property (nonatomic, copy) NSString *payPasswordType;

/**
 *  商户是否通过商家认证  YES NO
 */
@property (nonatomic, copy) NSString *shopPassType;

/**
 *  电话号码
 */
@property (nonatomic, copy) NSString *userPhone;

/**
 *  3D Touch
 */
@property (nonatomic, copy) NSString *threeTouch;

/**
 *  推送得到的字典
 */
@property (nonatomic, strong) NSDictionary *userInfoDict;

/**
 * 1:登录/支付都需要 2:登录需要 3:支付需要
 */
@property (nonatomic, copy) NSString *needTouchID;

/**
 *  是否是子账户 YES NO
 */
@property (nonatomic, copy) NSString *isSubAccount;


- (void)updateUserInfor;

@end
