//
//   WPBarButton.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBarButton.h"
#import "UIView+WPExtension.h"
 

@implementation  WPBarButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self sizeToFit];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)barButtonWithTarget:(id)target action:(SEL)action title:(NSString *)title {
    return [[self alloc]initWithTarget:target action:action title:title];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    switch (self.barButtonType) {
        case WPBarButtonTypeDefault:
        {
            self.imageView.xc_x = 0;
            self.imageView.xc_y = (self.xc_height - self.imageView.xc_height) / 2;
            self.titleLabel.xc_x = (self.xc_width + CGRectGetMaxX(self.imageView.frame) - self.titleLabel.xc_width) / 2;
            self.titleLabel.xc_y = (self.xc_height - self.titleLabel.xc_height) / 2;
        }
            break;
            
            
        case WPBarButtonTypeImageLeft:
        {
            self.imageView.xc_y = 0;
            self.imageView.xc_x = (self.xc_width - self.imageView.xc_width) / 2;
            self.titleLabel.xc_y = (self.xc_height + CGRectGetMaxY(self.titleLabel.frame) - self.imageView.xc_height) / 2;
            self.titleLabel.xc_x = (self.xc_width - self.imageView.xc_width) / 2;
        }
            break;
        case WPBarButtonTypeImageRight:
        {
            self.titleLabel.xc_x = 0;
            self.titleLabel.xc_y = (self.xc_height - self.titleLabel.xc_height) / 2;
            self.imageView.xc_x = (self.xc_width + CGRectGetMaxX(self.titleLabel.frame) - self.imageView.xc_width) / 2;
            self.imageView.xc_y = (self.xc_height - self.imageView.xc_height) / 2;
        }
            break;
        case WPBarButtonTypeImageUp:
        {
            self.imageView.xc_x = 0;
            self.imageView.xc_y = (self.xc_height - self.imageView.xc_height) / 2;
            self.titleLabel.xc_x = (self.xc_width + CGRectGetMaxX(self.imageView.frame) - self.titleLabel.xc_width) / 2;
            self.titleLabel.xc_y = (self.xc_height - self.titleLabel.xc_height) /2;
        }
            break;
        case WPBarButtonTypeImageDown:
        {
            self.titleLabel.xc_y = 0;
            self.titleLabel.xc_x = (self.xc_width - self.titleLabel.xc_width) / 2;
            self.imageView.xc_y = (self.xc_height + CGRectGetMaxX(self.imageView.frame) - self.titleLabel.xc_height) / 2;
            self.imageView.xc_x = (self.xc_width - self.imageView.xc_width) / 2;
        }
            break;
        default:
            break;
    }
}


@end
