//
//  WPProfitDetailModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"


@interface WPProfitDetailModel : NSObject

@property (nonatomic, assign) NSInteger agentId;

@property (nonatomic, assign) float benefit;

@property (nonatomic, assign) float commission;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *merchantno;

@property (nonatomic, copy) NSString *orderno;

@property (nonatomic, assign) float txAmount;

@end

