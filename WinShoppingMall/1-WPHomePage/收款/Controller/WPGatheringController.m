//
//  WPGatheringController.m
//  WinShoppingMall
//  收款
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPGatheringController.h"

#import "Header.h"

#import "WPGatheringCodeController.h"
#import "WPBillController.h"


@interface WPGatheringController ()

@property (nonatomic, strong) UILabel *todayMoneyLabel;

@property (nonatomic, strong) UIImageView *todayIncomeImageView;

@property (nonatomic, strong) UIView *accountCheckingView;

@property (nonatomic, strong) UIImageView *bottomImageView;

@end

@implementation WPGatheringController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收款";
    
    [self createTodayIncomeImageView];
    [self createAccountCheckingView];
    [self createBottomImageView];
    [self getTodayGatheringData];
}

#pragma mark - Init

- (void)createTodayIncomeImageView {
    self.todayIncomeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, 150)];
    self.todayIncomeImageView.backgroundColor = [UIColor themeColor];
    self.todayIncomeImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.todayIncomeImageView];
    
    UILabel *todayIncomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, 10, 120, 30)];
    todayIncomeLabel.text = @"今日收入(元)";
    todayIncomeLabel.textColor = [UIColor whiteColor];
    todayIncomeLabel.font = [UIFont systemFontOfSize:13];
    todayIncomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.todayIncomeImageView addSubview:todayIncomeLabel];
    
    self.todayMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, CGRectGetMaxY(todayIncomeLabel.frame) + 10, 120, 30)];
    self.todayMoneyLabel.text = @"0.00";
    self.todayMoneyLabel.textColor = [UIColor whiteColor];
    self.todayMoneyLabel.font = [UIFont systemFontOfSize:20];
    self.todayMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.todayIncomeImageView addSubview:self.todayMoneyLabel];
    
    UIButton *collectMoneyButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, CGRectGetMaxY(self.todayMoneyLabel.frame) + 10, 100, 30)];
    [collectMoneyButton setTitle:@"马上收钱" forState:UIControlStateNormal];
    [collectMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    collectMoneyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    collectMoneyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    collectMoneyButton.layer.borderWidth = 0.5f;
    collectMoneyButton.layer.cornerRadius = 10;
    [collectMoneyButton addTarget:self action:@selector(collectionMoneyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.todayIncomeImageView addSubview:collectMoneyButton];
}

- (void)createAccountCheckingView {
    
    self.accountCheckingView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.todayIncomeImageView.frame), kScreenWidth, 120)];
    self.accountCheckingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.accountCheckingView];
    
    NSArray *imageArray = @[@"icon_duizhang_content_n", @"icon_shoukuanma_content_n"];
    NSArray *titleArray = @[@"对账",@"收款码"];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4 - 25 + kScreenWidth / 2 * i, 15, 50, 50)];
        [imageButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.accountCheckingView addSubview:imageButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4 - 30 + kScreenWidth / 2 * i, CGRectGetMaxY(imageButton.frame) + 10, 60, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.accountCheckingView addSubview:titleLabel];
    }
}

- (void)createBottomImageView
{
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.accountCheckingView.frame) + ((kScreenHeight - CGRectGetMaxY(self.accountCheckingView.frame) - 20) / 2 + 20) * i, kScreenWidth, (kScreenHeight - CGRectGetMaxY(self.accountCheckingView.frame) - 20) / 2)];
        label.text = @"资金很安全";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:30 weight:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor themeColor];
        [self.view addSubview:label];
    }
}


#pragma mark - Action

- (void)collectionMoneyButtonAction:(UIButton *)button {

}

- (void)imageButtonAction:(UIButton *)button {
    switch (button.tag) {
            //  对账
        case 0: {
            WPBillController *vc = [[WPBillController alloc] init];
            vc.isCheck = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //  收款码
        case 1: {
            WPGatheringCodeController *vc = [[WPGatheringCodeController alloc] init];
            vc.codeType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Data 

- (void)getTodayGatheringData {
    __weakSelf
    [WPHelpTool getWithURL:WPTodayQrIncome parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.todayMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [result[@"todayQrIncome"] floatValue]];
        }
        
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
