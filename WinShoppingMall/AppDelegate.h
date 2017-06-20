//
//  AppDelegate.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQShareDelegate <NSObject>

-(void)shareSuccssWithQQCode:(NSInteger)code;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak  , nonatomic) id<QQShareDelegate> qqDelegate;


@end

