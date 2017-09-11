//
//  WPBillMonthController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/9/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillMonthController.h"
#import "Masonry.h"
#import "WinShoppingMall-Bridging-Header.h"
//#import "BarChartData.swift"
//#import "BarChartDataEntry.swift"

#define BgColor [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1]

@interface WPBillMonthController ()

@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) PieChartData *data;

@end

@implementation WPBillMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    [self initInterface];
}

- (void)initInterface
{
    UILabel *title_label = [[UILabel alloc] init];
    title_label.text = @"title_label";
    title_label.textColor = [UIColor brownColor];
    title_label.font = [UIFont systemFontOfSize:45];
    title_label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260, 50));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-200);
    }];

    UIButton * display_button = [[UIButton alloc] init];
    [display_button setTitle:@"display_button" forState:UIControlStateNormal];
    [display_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:display_button];
    [display_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(240);
    }];
    [display_button addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];

    self.pieChartView = [[PieChartView alloc] init];
    self.pieChartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pieChartView];

    [self.pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.center.mas_equalTo(self.view);
    }];

    [self.pieChartView setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];
    self.pieChartView.usePercentValuesEnabled = YES;
    self.pieChartView.dragDecelerationFrictionCoef = YES;
    self.pieChartView.drawSliceTextEnabled = YES;

    self.pieChartView.drawHoleEnabled = YES;
    self.pieChartView.holeRadiusPercent = 0.5;
    self.pieChartView.holeColor = [UIColor clearColor];
    self.pieChartView.transparentCircleRadiusPercent = 0.52;
    self.pieChartView.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];




}

- (void)updateData
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
