//
//  WPSexPickerView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSexPickerView.h"
#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"

@interface WPSexPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isSelected;


@end

#define wp_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define wp_ScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation WPSexPickerView

- (instancetype)initSexPickerView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, wp_ScreenWidth, wp_ScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)]];
        [self.dataArray addObjectsFromArray:@[@"男", @"女"]];
        [self addSubview:self.pickerView];
        [UIView animateWithDuration:0.2f animations:^{
            self.pickerView.frame = CGRectMake(0, wp_ScreenHeight * 2 / 3, wp_ScreenWidth, wp_ScreenHeight / 3);
        }];
    }
    return self;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, wp_ScreenHeight, wp_ScreenWidth, wp_ScreenHeight / 3);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (!_isSelected) {
        if (self.sexPickerViewDelegate && [self.sexPickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithSex:)]) {
            [self.sexPickerViewDelegate wp_selectedResultWithSex:self.dataArray[0]];
        }
    }
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.sexPickerViewDelegate && [self.sexPickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithSex:)]) {
        [self.sexPickerViewDelegate wp_selectedResultWithSex:self.dataArray[row]];
    }
}


- (void)cancelPickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.pickerView setFrame:CGRectMake(0, wp_ScreenHeight, wp_ScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
