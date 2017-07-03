//
//  WPBillTitleView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/8.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillTitleView.h"
#import "Header.h"

@implementation WPBillTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self titleButton];
        [self imageButton];
    }
    return self;
}


- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, kScreenWidth * 2 / 3, 50)];
        _titleButton.titleLabel.numberOfLines = 0;
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

- (UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60 - WPLeftMargin, 5, 60 + WPLeftMargin, 40)];
        [_imageButton setImage:[UIImage imageNamed:@"ixon_zhangdan_content_n"] forState:UIControlStateNormal];
        [self addSubview:_imageButton];
    }
    return _imageButton;
}


@end
