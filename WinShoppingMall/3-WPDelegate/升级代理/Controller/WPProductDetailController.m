//
//  WPProductDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProductDetailController.h"
#import "Header.h"
#import "WPProductSubmitController.h"

@interface WPProductDetailController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) WPButton *submitButton;

@property (nonatomic, strong) WPUpGradeProductModel *delegateModel;

@property (nonatomic, strong) WPMerchantGradeProuctModel *merModel;

@property (nonatomic, strong) UIImage *titleImage;

//  判断VIP等级判断是否可以点击
@property (nonatomic, assign) BOOL isVip;

// YES：代理升级 NO：商户升级
@property (nonatomic, assign) BOOL isDelegate;


@end

@implementation WPProductDetailController

- (void)initWithTitle:(NSString *)title titleImage:(UIImage *)image model:(id)model isAgency:(BOOL)isAgency isUpgrade:(BOOL)isUpgrade
{
    self.navigationItem.title = title;
    self.titleImage = image;
    self.isDelegate = isAgency;
    if (isAgency) {
        self.delegateModel = model;
    }
    else {
        self.merModel = model;
    }
    self.isVip = isUpgrade;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isVip ? [self submitButton] : [self descriptionLabel];
}


#pragma mark - Init

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 20, 100, 100)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = self.titleImage;
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth - 2 * WPLeftMargin, 20)];
        _titleLabel.text = self.isDelegate ? self.delegateModel.gradeName : self.merModel.lvname;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth - 2 * WPLeftMargin, 30)];
        _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", self.isDelegate ? self.delegateModel.price : self.merModel.price];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:17];
        [self.scrollView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        float height = [WPPublicTool textHeightFromTextString:self.isDelegate ? self.delegateModel.adesp : self.merModel.mdesp width:kScreenWidth - 2 * WPLeftMargin miniHeight:WPRowHeight fontSize:15];
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.priceLabel.frame), kScreenWidth - 2 * WPLeftMargin, height)];
        _descriptionLabel.text = self.isDelegate ? self.delegateModel.adesp : self.merModel.mdesp;
        _descriptionLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _descriptionLabel.numberOfLines = 0;
        [self.scrollView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (WPButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.descriptionLabel.frame) + 20, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_submitButton setTitle:@"升级" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_submitButton userInteractionEnabled:YES];
        [_submitButton addTarget:self action:@selector(submitOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_submitButton];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_submitButton.frame) + 10);
    }
    return _submitButton;
}

#pragma mark - Action 

- (void)submitOrderButtonClick:(UIButton *)button {
    
    WPProductSubmitController *vc = [[WPProductSubmitController alloc] init];
    
    vc.navigationItem.title = self.isDelegate ? @"代理升级" : @"商户升级";
    vc.isDelegate = self.isDelegate;
    vc.userLv = self.isDelegate ? [NSString stringWithFormat:@"%ld", (long)self.delegateModel.id] : [NSString stringWithFormat:@"%ld", (long)self.merModel.id];
    vc.gradeMoney = self.isDelegate ? [NSString stringWithFormat:@"%.2f", self.delegateModel.price] : [NSString stringWithFormat:@"%.2f", self.merModel.price];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
