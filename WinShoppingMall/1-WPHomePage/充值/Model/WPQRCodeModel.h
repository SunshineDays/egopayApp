//
//  WPQRCodeModel.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPQRCodeModel : NSObject

@property (nonatomic, copy) NSString *CodeUrl;

@property (nonatomic, copy) NSString *ImgUrl;

@property (nonatomic, assign) NSInteger method;

@property (nonatomic, copy) NSString *msg;

@end
