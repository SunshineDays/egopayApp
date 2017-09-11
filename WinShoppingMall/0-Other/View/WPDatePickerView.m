//
//  WPPickerView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/15.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPDatePickerView.h"
#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"
#import "WPAppConst.h"

@interface WPDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

//  判断是否滑动了
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation WPDatePickerView

- (instancetype)initPickerView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)]];
        [self initDateData];
        [self addSubview:self.pickerView];
        [UIView animateWithDuration:0.2f animations:^
        {
            self.pickerView.frame = CGRectMake(0, kScreenHeight * 5 / 8, kScreenWidth, kScreenHeight * 3 / 8);
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
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight / 3);
        _pickerView.backgroundColor = [UIColor tableViewColor];
        _pickerView.alpha = 1.0f;
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
    self.year = [NSString stringWithFormat:@"%ld", (long)year];
    [formatter setDateFormat:@"MM"];
    NSInteger month = [[formatter stringFromDate:date] integerValue];
    self.month = month < 10 ? [NSString stringWithFormat:@"0%ld", (long)month] : [NSString stringWithFormat:@"%ld", (long)month];
    
    NSMutableArray *yearArrM = [[NSMutableArray alloc] init];
    NSMutableArray *monthArrM = [[NSMutableArray alloc] init];

    for (int i = 0; i <= 5; i++)
    {
        [yearArrM addObject:[NSString stringWithFormat:@"%ld年", (long)year]];
        year ++;
    }

    for (int i = 0; i < 12; i++)
    {
        if (month > 12)
        {
            month = month - 12;
        }
        NSString *monthString = [NSString stringWithFormat:@"%ld月", (long)month];

        [monthArrM addObject:monthString];
        month ++;
    }
    [self.dataArray addObjectsFromArray:@[yearArrM, monthArrM]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataArray[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (!self.isSelected)
    {
        if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithYear:month:day:)])
        {
            
            [self.pickerViewDelegate wp_selectedResultWithYear:[self.dataArray[0][0] stringByReplacingOccurrencesOfString:@"年" withString:@""] month:[self.dataArray[1][0] stringByReplacingOccurrencesOfString:@"月" withString:@""] day:nil];
        }
    }
    
    return self.dataArray[component][row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for (UIView *linView in pickerView.subviews)
    {
        if (linView.frame.size.height < 1)
        {
            linView.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.isSelected = YES;
    switch (component)
    {
        case 0:
            self.year = self.dataArray[0][row];
            break;
        case 1:
            self.month = self.dataArray[1][row];
            break;
            
        default:
            break;
    }
    
    if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithYear:month:day:)])
    {
        NSString *year = [[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *month = [[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        
        [self.pickerViewDelegate wp_selectedResultWithYear:year month:month day:nil];
    }
}



- (void)cancelPickerView
{
    [UIView animateWithDuration:0.2f animations:^
    {
        [self.pickerView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}

@end
