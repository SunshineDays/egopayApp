//
//  WPPickerView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/15.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPickerView.h"
#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"

@interface WPPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

//  判断是否滑动了
@property (nonatomic, assign) BOOL isSelected;


@end

#define wp_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define wp_ScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation WPPickerView

- (instancetype)initPickerView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, wp_ScreenWidth, wp_ScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)]];
        [self initDateData];
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


- (void)initDateData
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy"];
    NSInteger year = [[formatter stringFromDate:date] integerValue];
    self.year = [NSString stringWithFormat:@"%ld", year];
    [formatter setDateFormat:@"MM"];
    NSInteger month = [[formatter stringFromDate:date] integerValue];
    self.month = month < 10 ? [NSString stringWithFormat:@"0%ld", month] : [NSString stringWithFormat:@"%ld", month];
    
    NSMutableArray *yearArrM = [[NSMutableArray alloc] init];
    NSMutableArray *monthArrM = [[NSMutableArray alloc] init];

    for (int i = 0; i < 10; i++) {
        [yearArrM addObject:[NSString stringWithFormat:@"%ld", (long)year]];
        year ++;
    }

    for (int i = 0; i < 12; i++) {
        if (month > 12) {
            month = month - 12;
        }
        NSString *monthString = month < 10 ? [NSString stringWithFormat:@"0%ld", month] : [NSString stringWithFormat:@"%ld", month];

        [monthArrM addObject:monthString];
        month ++;
    }
    NSDictionary *yearDic = [NSDictionary dictionaryWithObject:yearArrM forKey:@"year"];
    NSDictionary *monthDic = [NSDictionary dictionaryWithObject:monthArrM forKey:@"month"];
    [self.dataArray addObjectsFromArray:@[yearDic, monthDic]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.dataArray[0][@"year"] count];
            break;
            
        case 1:
            return [self.dataArray[1][@"month"] count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (!self.isSelected) {
        if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithYear:month:day:)]) {
            [self.pickerViewDelegate wp_selectedResultWithYear:self.dataArray[0][@"year"][0] month:self.dataArray[1][@"month"][0] day:nil];
        }
    }

    switch (component)
    {
        case 0:
            return self.dataArray[0][@"year"][row];
            break;
            
        case 1:
            return self.dataArray[1][@"month"][row];
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.isSelected = YES;
    switch (component) {
        case 0:
            self.year = self.dataArray[0][@"year"][row];
            break;
        case 1:
            self.month = self.dataArray[1][@"month"][row];
            break;
            
        default:
            break;
    }
    if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithYear:month:day:)]) {
        [self.pickerViewDelegate wp_selectedResultWithYear:self.year month:self.month day:nil];
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
