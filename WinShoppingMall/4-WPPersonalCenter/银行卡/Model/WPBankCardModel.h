//
//  WPBankCardModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/18.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPBankCardModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger merId;

@property (nonatomic, copy) NSString *cardNumber;

@property (nonatomic, assign) int cardType;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, copy) NSString *bankZone;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *identityCard;

@property (nonatomic, copy) NSString *expDate;

@property (nonatomic, copy) NSString *bandDate;

@property (nonatomic, assign) int isPicConfirm;

@property (nonatomic, assign) int extCardType;

@property (nonatomic, assign) int auditStatus;


@end
