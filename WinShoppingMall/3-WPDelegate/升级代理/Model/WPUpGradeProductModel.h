//
//  WPUpGradeProductModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/4.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPUpGradeProductModel : NSObject


@property (nonatomic, assign) float benefitRate;

@property (nonatomic, assign) float commissionRate;

@property (nonatomic, copy) NSString *adesp;

@property (nonatomic, copy) NSString *gradeName;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) float price;

@end
