//
//  WPNotificationBillDetailModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNotificationBillDetailModel : NSObject

@property (nonatomic, assign) float amount;

@property (nonatomic, assign) NSInteger billid;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *finishDate;

@property (nonatomic, assign) NSInteger frozen;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger inPaystate;

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, assign) NSInteger merchantid;

@property (nonatomic, copy) NSString *orderno;

@property (nonatomic, assign) NSInteger payState;

@property (nonatomic, assign) NSInteger paychannelid;

@property (nonatomic, assign) NSInteger refund;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger showNews;

@property (nonatomic, assign) NSInteger tradeType;

@property (nonatomic, assign) NSInteger userlvid;

@property (nonatomic, assign) float counterRate;

@property (nonatomic, assign) float counterFee;

@property (nonatomic, assign) float avl_amount;


@end
