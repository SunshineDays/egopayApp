//
//  WPGatheringCodeController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPGatheringCodeController : WPBaseViewController

/**
 *  二维码图片链接
 */
@property (nonatomic, copy) NSString *codeString;

/**
 *  微信／支付宝
 *  1:微信 2:支付宝 3:QQ钱包
 */
@property (nonatomic, assign) NSInteger payType;

/**
 *  1:支付二维码 2:我的收款码 3:分享二维码
 */
@property (nonatomic, assign) NSInteger codeType;


@end
