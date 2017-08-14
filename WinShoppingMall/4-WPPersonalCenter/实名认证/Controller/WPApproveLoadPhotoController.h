//
//  WPApproveLoadPhotoController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPApproveLoadPhotoController : WPBaseViewController

//  判断是上传身份证信息还是银行卡信息。YES：身份证
@property (nonatomic, assign) BOOL isIDCard;

@property (nonatomic, copy) NSString *cardId;

@property (nonatomic, copy) void(^loadApproveBlock)(float approveState);


@property (nonatomic, strong) NSDictionary *idCardDic;

@end
