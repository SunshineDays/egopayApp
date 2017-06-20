//
//  WPBillModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPBillModel : NSObject

@property (nonatomic, assign) float amount;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *finishDate;

@property (nonatomic, assign) float frozen;

@property (nonatomic, assign) float id;

@property (nonatomic, assign) int inPaystate;

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, assign) float merchantid;

@property (nonatomic, copy) NSString *orderno;

@property (nonatomic, assign) int payState;

@property (nonatomic, assign) int paychannelid;

@property (nonatomic, assign) float refund;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) float showNews;

@property (nonatomic, assign) int tradeType;

@property (nonatomic, assign) float userlvid;

@property (nonatomic, assign) float counterRate;

@property (nonatomic, assign) float counterFee;

@property (nonatomic, assign) float avl_amount;


@end
