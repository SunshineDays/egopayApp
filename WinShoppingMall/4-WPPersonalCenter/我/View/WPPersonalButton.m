//
//  WPPersonalButton.h.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPersonalButton.h"
#import "Header.h"

@interface WPPersonalButton ()

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *vip;


@end

@implementation WPPersonalButton

- (instancetype)initWithFrame:(CGRect)frame avaterUrl:(NSString *)url phone:(NSString *)phone vip:(NSString *)vip
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor themeColor];
        self.url = url;
        self.phone = phone;
        self.vip = vip;
        [self vipLabel];
        [self arrowImageView];
    }
    return self;
}

- (UIImageView *)avaterImageView
{
    if (!_avaterImageView) {
        _avaterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin, 10, 70, 70)];
        [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRefreshCached];
        _avaterImageView.layer.cornerRadius = WPCornerRadius;
        _avaterImageView.layer.borderWidth = WPLineHeight;
        _avaterImageView.layer.borderColor = [UIColor lineColor].CGColor;
        _avaterImageView.layer.masksToBounds = YES;
        [self addSubview:_avaterImageView];
    }
    return _avaterImageView;
}


- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avaterImageView.frame) + 10, 10, 150, 35)];
        _phoneLabel.text = self.phone;
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_phoneLabel];
    }
    return _phoneLabel;
}


- (UILabel *)vipLabel
{
    if (!_vipLabel) {
        _vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avaterImageView.frame) + 10, CGRectGetMaxY(self.phoneLabel.frame), 150, 35)];
        _vipLabel.text = self.vip;
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_vipLabel];
    }
    return _vipLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 - 10, 10 + 35 - 7.5, 10, 15)];
        _arrowImageView.image = [UIImage imageNamed:@"icon_fanhui_n"];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}


@end
