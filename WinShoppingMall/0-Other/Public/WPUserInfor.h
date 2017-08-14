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
 *  登录是否需要Touch ID   YES NO
 */
@property (nonatomic, copy) NSString *registerTouchID;

/**
 *  支付是否需要Touch ID   YES NO
 */
@property (nonatomic, copy) NSString *payTouchID;

/**
 *  是否提醒用户开通Touch ID
 */
@property (nonatomic, copy) NSString *isRemindTouchID;


/**
 *  是否是子账户 YES NO
 */
@property (nonatomic, copy) NSString *isSubAccount;


- (void)updateUserInfor;

@end
