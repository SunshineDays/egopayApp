//
//  WPNotificationMessageModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNotificationMessageModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger msg_type;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *title;

@end
