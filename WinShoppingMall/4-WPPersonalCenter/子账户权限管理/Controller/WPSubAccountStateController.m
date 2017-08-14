//
//  WPSubAccountStateController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/25.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSubAccountStateController.h"
#import "WPAppConst.h"

@interface WPSubAccountStateController ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation WPSubAccountStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"子账户说明";
    [self stateLabel];
}


- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopY, kScreenWidth - 2 * WPLeftMargin, 150)];
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.numberOfLines = 0;
        _stateLabel.text = @"子账户说明：\n1、添加子账户后，您可以在多个设备上收款，更加方便、快捷\n2、主账户可以随时更改子账户密码、权限信息，以及删除子账户\n3、子账户只有查看的权限，没有修改的权限";
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
