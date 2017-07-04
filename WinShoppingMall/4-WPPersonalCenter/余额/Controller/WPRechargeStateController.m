//
//  WPRechargeStateController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRechargeStateController.h"
#import "Header.h"

@interface WPRechargeStateController ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation WPRechargeStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"限额说明";
    [self stateLabel];

}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        NSString *rechargeStateStr = [NSString stringWithFormat:@"充值说明：\n1、微信支付：每次最多充值500元\n2、支付宝支付：每次最多充值1000元\n3、银行卡支付：需要先绑定用户的银行卡\n如果超过上述金额，需要上传身份证照片进行认证。"];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth - 2 * WPLeftMargin, 140)];
        _stateLabel.numberOfLines = 0;
        _stateLabel.text = rechargeStateStr;
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
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
