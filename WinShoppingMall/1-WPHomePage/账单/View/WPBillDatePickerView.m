//
//  WPBillDatePickerView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/30.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillDatePickerView.h"
#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"
#import "WPAppConst.h"

@interface WPBillDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *cancelButton;;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, assign) NSInteger yearRow;

@end

@implementation WPBillDatePickerView

- (instancetype)initPickerView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)]];
        
        [self initDateData];
        [self addSubview:self.pickerView];
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.confirmButton];
        [self.titleView addSubview:self.cancelButton];
        
        [UIView animateWithDuration:0.2f animations:^
         {
             self.pickerView.frame = CGRectMake(0, kScreenHeight * 5 / 8 + 40, kScreenWidth, kScreenHeight * 3 / 8 - 40);
             self.titleView.frame = CGRectMake(0, kScreenHeight * 5 / 8, kScreenWidth, 40);
         }];
        //选定最后一行
        [self.pickerView selectRow:self.yearArray.count - 1 inComponent:0 animated:YES];
        [self.pickerView selectRow:[[self.monthArray lastObject] count] - 1 inComponent:1 animated:YES];
    }
    return self;
}

- (NSMutableArray *)yearArray
{
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray
{
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (void)initDateData
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger nowYear = [[formatter stringFromDate:date] integerValue];
    
    [formatter setDateFormat:@"MM"];
    NSInteger nowMonth = [[formatter stringFromDate:date] integerValue];
    
    NSMutableArray *yearArrM = [NSMutableArray array];
    NSMutableArray *monthArrM = [NSMutableArray array];
    
    NSInteger firstYear = 2015;
    NSInteger firstMonth = 4;
    
    //获取年份数组
    for (NSInteger i = firstYear; i <= nowYear; i++)
    {
        [yearArrM addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    self.yearArray = yearArrM;
    
    //获取每一个年份对应月份的数组
    NSMutableArray *firstArray = [NSMutableArray array];
    for (NSInteger i = firstMonth; i <= 12; i++)
    {
        [firstArray addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    NSMutableArray *centreArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 12; i++)
    {
        [centreArray addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    NSMutableArray *lastArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= nowMonth; i++)
    {
        [lastArray addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    //根据年份添加数组
    if (nowYear == firstYear)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = firstMonth; i <= nowMonth; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        [monthArrM addObject:array];
    }
    if (nowYear - firstYear == 1)
    {
        [monthArrM addObjectsFromArray:@[firstArray, lastArray]];
    }
    if (nowYear - firstYear > 1)
    {
        [monthArrM addObject:firstArray];
        for (int i = 1; i < nowYear - firstYear; i++) {
            [monthArrM addObject:centreArray];
        }
        [monthArrM addObject:lastArray];
    }
    
    self.monthArray = monthArrM;
    
    self.yearRow = self.yearArray.count - 1;

}


- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, CGRectGetWidth(self.pickerView.frame), 40)];
        _titleView.backgroundColor = [UIColor tableViewColor];
        _titleView.userInteractionEnabled = YES;
        _titleView.layer.borderColor = [UIColor lineColor].CGColor;
        _titleView.layer.borderWidth = WPLineHeight;
    }
    return _titleView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton addTarget:self action:@selector(cancelPickerView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.pickerView.frame) - 100, 0, 100, 40)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight / 3 - 40);
        _pickerView.backgroundColor = [UIColor tableViewColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component)
    {
        case 0:
        {
            return self.yearArray.count;
            break;
        }
         
        case 1:
        {
            return [self.monthArray[self.yearRow] count];
            break;
        }
            
        default:
            return 1;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            return [NSString stringWithFormat:@"%@年", self.yearArray[row]];
            break;
        }
            
        case 1:
        {
            return [NSString stringWithFormat:@"%@月", self.monthArray[self.yearRow][row]];
            break;
        }
            
        default:
            return @"";
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.yearRow = row;
//            self.monthRow = 0;
//            [pickerView selectRow:0 inComponent:1 animated:NO];
            break;
        }
            
        case 1:
        {
//            self.monthRow = row;

            break;
        }
            
        default:
            break;
    }
    [pickerView reloadAllComponents];
    
    
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

- (void)confirmButtonAction
{
    if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(wp_selecteBillDataWithYear:month:)]) {
        
        NSString *year = [[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *month = [[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        if ([month integerValue] < 10) {
            month = [NSString stringWithFormat:@"0%@", month];
        }
        
        [self.pickerViewDelegate wp_selecteBillDataWithYear:year
                                                      month:month];
    }
    [self cancelPickerView];
}

- (void)cancelPickerView
{
    
    [UIView animateWithDuration:0.2f animations:^
     {
         [self.titleView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
         [self.pickerView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
         self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

@end
