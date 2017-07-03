//
//  WPShareView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPShareView : UIView

@property (nonatomic, copy) void(^shareBlock)(NSString *appType);

- (instancetype)initShareToApp;

@end
