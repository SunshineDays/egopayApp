//
//  WPSexPickerView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPSexPickerView;
@protocol WPSexPickerViewDelegate <NSObject>

@optional

- (void)wp_selectedResultWithSex:(NSString *)sex;

@end

@interface WPSexPickerView : UIView

@property (nonatomic, weak) id<WPSexPickerViewDelegate> sexPickerViewDelegate;

- (instancetype)initSexPickerView;

@end
