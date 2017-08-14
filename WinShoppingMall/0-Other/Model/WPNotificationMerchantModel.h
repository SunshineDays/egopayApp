//
//  WPNotificationMerchantModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNotificationMerchantModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger merId;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *linkMan;

@property (nonatomic, assign) NSInteger linkMan_sex;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *detailAddr;

@property (nonatomic, copy) NSString *busilicence_no;

@property (nonatomic, copy) NSString *busilicence_img;

@property (nonatomic, copy) NSString *shopCover_url;

@property (nonatomic, assign) NSInteger categoryId;

//@property (nonatomic, copy) NSString *description;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, copy) NSString *applyTime;

@property (nonatomic, copy) NSString *auditTime;

@property (nonatomic, copy) NSString *operator;

@property (nonatomic, copy) NSString *auditMsg;


@end
