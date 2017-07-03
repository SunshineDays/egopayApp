//
//  WPAreaPickerView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAreaPickerView.h"
#import "UIColor+WPColor.h"
#import "UIColor+WPExtension.h"

@interface WPAreaPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger provinceRow;

@property (nonatomic, assign) NSInteger cityRow;

@property (nonatomic, assign) NSInteger areaRow;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *cancelButton;;

@end

#define wp_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define wp_ScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation WPAreaPickerView

- (instancetype)initAreaPickerView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, wp_ScreenWidth, wp_ScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)]];
        [self initAreaData];
        [self addSubview:self.pickerView];
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.confirmButton];
        [self.titleView addSubview:self.cancelButton];
        [UIView animateWithDuration:0.2f animations:^{
            self.pickerView.frame = CGRectMake(0, wp_ScreenHeight * 2 / 3 + 40, wp_ScreenWidth, wp_ScreenHeight / 3 - 40);
            self.titleView.frame = CGRectMake(0, wp_ScreenHeight * 2 / 3, wp_ScreenWidth, 40);
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

- (void)initAreaData
{
    self.provinceRow = 0;
    self.cityRow = 0;
    self.areaRow = 0 ;
    NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"areaArray" ofType:@"plist"];
    [self.dataArray addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:plistStr]];
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, wp_ScreenHeight, CGRectGetWidth(self.pickerView.frame), 40)];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.userInteractionEnabled = YES;
    }
    return _titleView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
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
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, wp_ScreenHeight, wp_ScreenWidth, wp_ScreenHeight / 3 - 40);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.dataArray.count;
            break;
         
        case 1:
            return [[[self.dataArray objectAtIndex:self.provinceRow] objectForKey:@"citylist"] count];
            break;
            
        case 2:
            return [[[[[self.dataArray objectAtIndex:self.provinceRow] objectForKey:@"citylist"] objectAtIndex:self.cityRow] objectForKey:@"arealist"] count];
            break;
            
        default:
            return self.dataArray.count;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *provinceDic = [self.dataArray objectAtIndex:self.provinceRow];
    NSArray *cityArray = [provinceDic objectForKey:@"citylist"];

    switch (component) {
        case 0:
            return [self.dataArray[row] objectForKey:@"provinceName"];
            break;
            
        case 1: {
            return [[cityArray objectAtIndex:row] objectForKey:@"cityName"];
        }
            break;
            
        case 2: {
            return [[[cityArray objectAtIndex:self.cityRow] objectForKey:@"arealist"][row] objectForKey:@"areaName"];
        }
            break;
            
        default:
            return [self.dataArray[row] objectForKey:@"provinceName"];
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.isSelected = YES;
    switch (component) {
        case 0: {
            self.provinceRow = row;
            self.cityRow = 0;
            self.areaRow = 0;
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
          
        case 1: {
            self.cityRow = row;
            self.areaRow = 0;
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
            
        case 2: {
            self.areaRow = row;
        }
            break;
            
        default:
            self.provinceRow = row;
            break;
    }
    [pickerView reloadAllComponents];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)confirmButtonAction
{
    if (self.areaPickerViewDelegate && [self.areaPickerViewDelegate respondsToSelector:@selector(wp_selectedResultWithProvince:city:area:)]) {
        [self.areaPickerViewDelegate wp_selectedResultWithProvince:[self pickerView:self.pickerView titleForRow:self.provinceRow forComponent:0]
                                                              city:[self pickerView:self.pickerView titleForRow:self.cityRow forComponent:1]
                                                              area:[self pickerView:self.pickerView titleForRow:self.areaRow forComponent:2]
         ];
    }
    [self cancelPickerView];
}

- (void)cancelPickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        [self.titleView setFrame:CGRectMake(0, wp_ScreenHeight, wp_ScreenWidth, 0)];
        [self.pickerView setFrame:CGRectMake(0, wp_ScreenHeight, wp_ScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
