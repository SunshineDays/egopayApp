//
//  WPRedPacketController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/4.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRedPacketController.h"
#import "Header.h"

@interface WPRedPacketController ()

@end

@implementation WPRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getRedPacketData];
}




- (void)getRedPacketData
{
    [WPHelpTool getWithURL:WPRedPacketURL parameters:nil success:^(id success) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
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
