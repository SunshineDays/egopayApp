//
//  WPPopupTitleView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/30.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPopupTitleView.h"
#import "UIColor+WPColor.h"
#import "WPAppConst.h"


@interface WPPopupTitleView ()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation WPPopupTitleView

- (instancetype)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 7 / 24 + 60.5)];
        [self cancelButton];
        [self imageButton];
        [self titleLabel];
        [self lineView];
    }
    return self;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 7 / 24)];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cancelButton.frame), kScreenWidth, 60)];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.userInteractionEnabled = YES;
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 0, 200, 60)];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_imageButton setImage:[UIImage imageNamed:@"btn_x_content_n"] forState:UIControlStateNormal];
        [self.titleView addSubview:_imageButton];
    }
    return _imageButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kScreenWidth, 0.5f)];
        _lineView.backgroundColor = [UIColor placeholderColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
