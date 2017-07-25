//
//  WPTodayProfitController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPTodayProfitController.h"
#import "Header.h"


@interface WPTodayProfitController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WPTodayProfitController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"今日分润";
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
