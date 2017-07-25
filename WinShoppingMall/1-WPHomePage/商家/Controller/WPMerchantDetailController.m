//
//  WPMerchantDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantDetailController.h"
#import "Header.h"
#import "WPMerchantDetailModel.h"
#import "UIView+WPExtension.h"

@interface WPMerchantDetailController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) WPRowTableViewCell *telCell;

@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) UIButton *telButton;

@property (nonatomic, strong) UILabel *descripLabel;

@property (nonatomic, strong) UIImageView *descripImageView;

@property (nonatomic, strong) WPMerchantDetailModel *model;

@end

@implementation WPMerchantDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getMerchantDetailData];
}

#pragma mark - Init

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin, 10, 80, 80)];
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover_url] placeholderImage:[UIImage imageNamed:@"123"] options:SDWebImageRefreshCached];
        [self.scrollView addSubview:_titleImageView];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        NSArray *array = @[self.model.shopName, self.model.detailAddr];
        for (int i = 0; i < array.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame) + 10, 10 + 40 * i, kScreenWidth - (CGRectGetMaxX(self.titleImageView.frame) + 10) - WPLeftMargin, 40)];
            titleLabel.text = array[i];
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.numberOfLines = 0;
            titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
            [self.scrollView addSubview:titleLabel];
        }
    }
    return _titleLabel;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.titleImageView.frame), kScreenWidth - 2 * WPLeftMargin, 30)];
        _shopNameLabel.text = [NSString stringWithFormat:@"联系人:    %@", self.model.linkMan];
        _shopNameLabel.numberOfLines = 0;
        _shopNameLabel.textColor = [UIColor darkGrayColor];
        _shopNameLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.scrollView addSubview:_shopNameLabel];
    }
    return _shopNameLabel;
}

- (UIButton *)telButton
{
    if (!_telButton) {
        _telButton = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.shopNameLabel.frame), kScreenWidth - 2 * WPLeftMargin, 30)];
        [_telButton setTitle:[NSString stringWithFormat:@"联系电话:%@", self.model.telephone] forState:UIControlStateNormal];
        [_telButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _telButton.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _telButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_telButton addTarget:self action:@selector(telButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_telButton];
    }
    return _telButton;
}


- (UILabel *)descripLabel
{
    if (!_descripLabel) {
        NSString *labelText = [NSString stringWithFormat:@"商户描述:\n        %@", self.model.descp];
        _descripLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.telButton.frame), kScreenWidth - 2 * WPLeftMargin, [WPPublicTool textHeightFromTextString:labelText width:kScreenWidth - 2 * WPLeftMargin miniHeight:30 fontSize:15])];
        _descripLabel.text = labelText;
        _descripLabel.numberOfLines = 0;
        _descripLabel.textColor = [UIColor darkGrayColor];
        _descripLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.scrollView addSubview:_descripLabel];
    }
    return _descripLabel;
}

- (UIImageView *)descripImageView
{
    if (!_descripImageView) {
        float imageWidth = (kScreenWidth - 3 * WPLeftMargin) / 2;
        NSArray *array = @[@"123"];
        for (int i = 0; i < array.count; i++)
        {
            _descripImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin + (imageWidth + WPLeftMargin) * (i % 2), CGRectGetMaxY(self.descripLabel.frame) + 10 + (imageWidth + 10) * (i / 2), imageWidth, imageWidth)];
            [_descripImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover_url] placeholderImage:[UIImage imageNamed:@"123"] options:SDWebImageRefreshCached];
            
            [self.scrollView addSubview:_descripImageView];
            self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_descripImageView.frame) + 10);
        }
    }
    return _descripImageView;
}

#pragma mark - Action

- (void)telButtonClick:(UIButton *)button
{
    [self.view callToNum:self.model.telephone];
}

#pragma mark - Data

- (void)getMerchantDetailData
{
    NSDictionary *parameters = @{
                                 @"shop_id" : self.merID
                                 };
    __weakSelf
    [WPHelpTool getWithURL:WPMerShopDetailURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.model = [WPMerchantDetailModel mj_objectWithKeyValues:result];
            [weakSelf titleLabel];
            [weakSelf descripImageView];
        }
    } failure:^(NSError *error)
    {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
