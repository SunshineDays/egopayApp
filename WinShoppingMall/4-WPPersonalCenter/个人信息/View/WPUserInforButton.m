//
//  WPUserInforView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserInforButton.h"
#import "Header.h"

@interface WPUserInforButton ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rateLabel;

@end

@implementation WPUserInforButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor lineColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        [self userImageView];
    }
    return self;
}

- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin, 15, 70, 70)];
        _userImageView.image = [UIImage imageNamed:@"titlePlaceholderImage"];
        _userImageView.layer.cornerRadius = 35;
        _userImageView.layer.borderWidth = WPLineHeight;
        _userImageView.layer.borderColor = [UIColor lineColor].CGColor;
        _userImageView.layer.masksToBounds = YES;
        [self addSubview:_userImageView];
    }
    return _userImageView;
}

- (void)userInforWithName:(NSString *)name vip:(NSString *)vip rate:(NSString *)rate
{
    float height = 30;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 20, 0, kScreenWidth - 110, height)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.text = name;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 20, height, kScreenWidth - 110, height)];
    _vipLabel.textColor = [UIColor blackColor];
    _vipLabel.text = vip;
    _vipLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_vipLabel];
    
    _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 20, height * 2, kScreenWidth - 110, height)];
    _rateLabel.textColor = [UIColor blackColor];
    _rateLabel.text = rate;
    _rateLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_rateLabel];
    

}


@end
