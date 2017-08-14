//
//  WPPickerView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/15.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPDatePickerView;
@protocol WPDatePickerViewDelegate <NSObject>

@optional

- (void)wp_selectedResultWithYear:(NSString *)year
                            month:(NSString *)month
                              day:(NSString *)day;

@end

@interface WPDatePickerView : UIView

@property (nonatomic, weak) id<WPDatePickerViewDelegate> pickerViewDelegate;

- (instancetype)initPickerView;

@end
