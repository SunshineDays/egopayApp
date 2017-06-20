//
//  WPEditUserInfoModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/14.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPEditUserInfoModel : NSObject

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) float accountBalance;

@property (nonatomic, assign) float avl_balance;

@property (nonatomic, assign) float iscertified;

@property (nonatomic, assign) int merchantlvid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) int merchantno;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) int sex;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *picurl;

@property (nonatomic, assign) int agentGradeId;

@property (nonatomic, assign) float rate;

@end
