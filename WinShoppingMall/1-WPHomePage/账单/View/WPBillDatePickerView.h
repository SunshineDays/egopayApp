//
//  WPBillDatePickerView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/30.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPBillDatePickerView;
@protocol WPBillDatePickerViewDelegate <NSObject>

@optional

- (void)wp_selecteBillDataWithYear:(NSString *)year
                             month:(NSString *)month;

@end

@interface WPBillDatePickerView : UIView

@property (nonatomic, weak) id<WPBillDatePickerViewDelegate> pickerViewDelegate;

- (instancetype)initPickerView;

@end
