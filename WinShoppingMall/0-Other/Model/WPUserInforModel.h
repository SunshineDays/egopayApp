//
//  WPUserInforModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPUserInforModel : NSObject

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
 *  收款码url
 */
@property (nonatomic, copy) NSString *codeUrl;

/**
 *  分享url
 */
@property (nonatomic, copy) NSString *shareUrl;

@end
