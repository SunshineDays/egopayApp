//
//  WPPickerView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/15.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPPickerView;
@protocol WPPickerViewDelegate <NSObject>

@optional

- (void)wp_selectedResultWithYear:(NSString *)year
                            month:(NSString *)month
                              day:(NSString *)day;

@end

@interface WPPickerView : UIView

@property (nonatomic, weak) id<WPPickerViewDelegate> pickerViewDelegate;

- (instancetype)initPickerView;

@end
