//
//  WPNoticifationApproveModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNoticifationApproveModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger merId;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, copy) NSString *identityCard;

@property (nonatomic, assign) NSInteger isPass;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, copy) NSString *operator;

@property (nonatomic, copy) NSString *auditMsg;

@property (nonatomic, copy) NSString *applyTime;

@property (nonatomic, copy) NSString *auditTime;


@end
