//
//  WPNotificationCardModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNotificationCardModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger merId;

@property (nonatomic, assign) NSInteger bankId;

@property (nonatomic, copy) NSString *cardNumber;

@property (nonatomic, assign) NSInteger cardType;

@property (nonatomic, assign) NSInteger extCardType;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *identifyName;

@property (nonatomic, copy) NSString *identityCard;

@property (nonatomic, copy) NSString *expDate;

@property (nonatomic, copy) NSString *bandDate;

@property (nonatomic, copy) NSString *isPicConfirm;

@property (nonatomic, assign) NSInteger auditStatus;

@end
