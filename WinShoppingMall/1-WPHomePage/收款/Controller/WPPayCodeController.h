//
//  WPPayCodeController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPQRCodeModel.h"


@interface WPPayCodeController : WPBaseViewController

/**
 *  二维码图片链接
 */
@property (nonatomic, copy) NSString *codeUrl;

/**
 *  1:支付二维码  2:分享二维码
 */
@property (nonatomic, assign) NSInteger codeType;

/**
 *  支付二维码Model
 */
@property (nonatomic, strong) WPQRCodeModel *codeModel;


@end
