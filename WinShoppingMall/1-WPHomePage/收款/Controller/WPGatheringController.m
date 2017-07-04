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

@property (nonatomic, strong) UIView *titleBgView;

@property (nonatomic, strong) UILabel *todayLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIButton *nowButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation WPGatheringController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"收款";
    
    [self nowButton];
    [self initContentButtons];
    [self initBottomView];
}

#pragma mark - Init

- (UIView *)titleBgView
{
    if (!_titleBgView) {
        _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, 150)];
        _titleBgView.backgroundColor = [UIColor themeColor];
        _titleBgView.userInteractionEnabled = YES;
        [self.view addSubview:_titleBgView];
    }
    return _titleBgView;
}

- (UILabel *)todayLabel
{
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _todayLabel.text = @"今日收入(元)";
        _todayLabel.textColor = [UIColor whiteColor];
        _todayLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleBgView addSubview:_todayLabel];
    }
    return _todayLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.todayLabel.frame), kScreenWidth, 40)];
        _moneyLabel.text = @"0.00";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.font = [UIFont systemFontOfSize:20];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleBgView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UIButton *)nowButton
{
    if (!_nowButton) {
        _nowButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, CGRectGetMaxY(self.moneyLabel.frame) + 10, 100, 30)];
        [_nowButton setTitle:@"马上收钱" forState:UIControlStateNormal];
        [_nowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nowButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _nowButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _nowButton.layer.borderWidth = WPLineHeight;
        _nowButton.layer.cornerRadius = 10;
        [_nowButton addTarget:self action:@selector(nowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBgView addSubview:_nowButton];
    }
    return _nowButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleBgView.frame), kScreenWidth, 110)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)initContentButtons
{
    NSArray *imageArray = @[@"icon_duizhang_content_n", @"icon_shoukuanma_content_n"];
    NSArray *titleArray = @[@"对账",@"收款码"];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4 - 25 + kScreenWidth / 2 * i, 15, 50, 50)];
        [imageButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:imageButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4 - 30 + kScreenWidth / 2 * i, CGRectGetMaxY(imageButton.frame) + 10, 60, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
    }
}

- (void)initBottomView
{
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentView.frame) + ((kScreenHeight - CGRectGetMaxY(self.contentView.frame) - 20) / 2 + 20) * i, kScreenWidth, (kScreenHeight - CGRectGetMaxY(self.contentView.frame) - 20) / 2)];
        label.text = @"资金很安全";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:30 weight:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor themeColor];
        [self.view addSubview:label];
    }
}


#pragma mark - Action

- (void)nowButtonAction:(UIButton *)button {

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
    [WPHelpTool getWithURL:WPTodayQrIncomeURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [result[@"todayQrIncome"] floatValue]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
