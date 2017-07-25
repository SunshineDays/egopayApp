//
//  WPShareTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPShareModel.h"

@interface WPShareTool : NSObject

@property (nonatomic, copy) void(^shareCodeBlock)(NSString *shareUrl);

/**
 *  分享
 */
+ (void)shareWithModel:(WPShareModel *)model appType:(NSString *)appType;

@end
