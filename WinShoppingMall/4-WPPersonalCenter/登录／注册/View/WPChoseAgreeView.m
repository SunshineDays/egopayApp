//
//  WPChoseAgreeView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPChoseAgreeView.h"
#import "Header.h"

@implementation WPChoseAgreeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self protocolButton];
    }
    return self;
}

- (UIButton *)imageButton
{
    if (!_imageButton) {
            _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin + 10, 15, 20, 20)];
            [_imageButton setBackgroundImage:[UIImage imageNamed:@"icon_sel_content_s"] forState:UIControlStateNormal];
            [self addSubview:_imageButton];
    }
    return _imageButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageButton.frame) + 15, 0, 100, WPRowHeight)];
        _titleLabel.text = @"已经阅读并同意";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)protocolButton
{
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 120, WPRowHeight)];
            _protocolButton.titleLabel.font = [UIFont systemFontOfSize:13];
            _protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_protocolButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [self addSubview:_protocolButton];
    }
    return _protocolButton;
}

@end
