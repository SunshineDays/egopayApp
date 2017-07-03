//
//  WPShareTool.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPShareTool : NSObject

@property (nonatomic, copy) void(^shareCodeBlock)(NSString *shareUrl);

- (void)shareWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description appType:(NSString *)appType;

@end
