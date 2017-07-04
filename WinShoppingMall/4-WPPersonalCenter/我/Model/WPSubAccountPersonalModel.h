//
//  WPSubAccountPersonalModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSubAccountPersonalModel : NSObject

@property (nonatomic, assign) float avl_balance;

@property (nonatomic, assign) float todayQrIncome;

@property (nonatomic, copy) NSString *clerkName;

@property (nonatomic, copy) NSString *merchant;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *headUrl;

@property (nonatomic, strong) NSDictionary *resources;


@end
