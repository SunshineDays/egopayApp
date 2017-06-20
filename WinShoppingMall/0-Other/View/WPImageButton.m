//
//  WPImageButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/14.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPImageButton.h"
#import "UIColor+WPColor.h"

@implementation WPImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cellColor];
        self.layer.borderColor = [UIColor lineColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        [self setImage:[UIImage imageNamed:@"icon-jiahao_content_n"] forState:UIControlStateNormal];
        
        [self label];
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15)];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}


@end
