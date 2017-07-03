//
//  WPAreaPickerView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPAreaPickerView;

@protocol WPAreaPickerViewDelegate <NSObject>

@optional

- (void)wp_selectedResultWithProvince:(NSString *)province
                                 city:(NSString *)city
                                 area:(NSString *)area;

@end

@interface WPAreaPickerView : UIView

@property (nonatomic, weak) id<WPAreaPickerViewDelegate> areaPickerViewDelegate;

- (instancetype)initAreaPickerView;

@end
