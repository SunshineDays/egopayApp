//
//  WPStateController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPStateController.h"
#import "Header.h"

@interface WPStateController ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation WPStateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"认证状态";
    
    [self stateLabel];
}


-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _stateLabel.numberOfLines = 0;
        _stateLabel.text = [self.status isEqualToString:@"1"] ? @"认证成功" : @"认证中";
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:20];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
