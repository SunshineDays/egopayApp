//
//  WPShareView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPShareView.h"
#import "Header.h"

#import "UIView+WPExtension.h"
#import "OpenShare+QQ.h"
#import "OpenShare+Weixin.h"

@interface WPShareView ()

@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) UILabel *iconLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, assign) float iconWidth;

@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation WPShareView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shareButton.imageView.xc_centerX = self.frame.size.width / 2;
    self.shareButton.imageView.xc_y = 0;
    
    self.shareButton.titleLabel.xc_x = 0;
    self.shareButton.titleLabel.xc_y = self.shareButton.frame.size.height - 15;
    self.shareButton.titleLabel.xc_width = self.shareButton.frame.size.width;
}

- (instancetype)initShareToApp
{
    if (self = [super init]) {
        self.iconWidth = (kScreenWidth - 15 * 6) / 5;
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.4f];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShare)]];
        
        _titleArray = [[NSMutableArray alloc] init];
        _imageArray = [[NSMutableArray alloc] init];
        if ([OpenShare isWeixinInstalled])
        {
            [_titleArray addObjectsFromArray:@[@"微信好友", @"微信朋友圈"]];
            [_imageArray addObjectsFromArray:@[@"share_wechat", @"share_weixin"]];
        }
        if ([OpenShare isQQInstalled])
        {
            [_titleArray addObjectsFromArray:@[@"QQ好友", @"QQ空间"]];
            [_imageArray addObjectsFromArray:@[@"share_qq", @"share_qqzone"]];
            
        }
        [_titleArray addObjectsFromArray:@[@"Safari中打开", @"复制链接", @"二维码"]];
        [_imageArray addObjectsFromArray:@[@"share_safari", @"share_copyurl", @"share_appCode"]];
        
        [self initShareView];
    }
    return self;
}

- (void)initShareView
{
    [self addSubview:self.shareView];
    [self.shareView addSubview:self.iconView];
    [self.shareView addSubview:self.lineView];
    [self.shareView addSubview:self.cancelButton];
    
    for (int i = 0; i < self.titleArray.count; i++)
    {
        WPShareIconButton *iconButton = [WPShareIconButton buttonWithType:UIButtonTypeCustom];
        [iconButton setFrame:CGRectMake(15 + (i % 5) * (self.iconWidth + 15), 15 + i / 5 * (self.iconWidth + 30), self.iconWidth, self.iconWidth + 20)];
        [iconButton setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        
        iconButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [iconButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        iconButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [iconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        iconButton.contentMode = UIViewContentModeScaleAspectFit;
        iconButton.tag = i;
        [iconButton addTarget:self action:@selector(shareToApp:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:iconButton];
        
    }
    
    [UIView animateWithDuration:0.2f animations:^
    {
        self.shareView.frame = CGRectMake(0, kScreenHeight - CGRectGetHeight(self.shareView.frame), kScreenWidth, CGRectGetHeight(self.shareView.frame));
    }];
    
}

- (UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
    
        //根据图标个数计算行
        NSInteger iconIndex = self.titleArray.count % 5 == 0 ? self.titleArray.count / 5 : self.titleArray.count / 5 + 1;
        _shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 15 * 5 + self.iconWidth * iconIndex + 50);
    }
    return _shareView;
}

- (UIView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame) - 50)];
        _iconView.backgroundColor = [UIColor whiteColor];
    }
    return _iconView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.cancelButton.frame) - 1, CGRectGetWidth(self.shareView.frame), 1)];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.shareView.frame) - 49, CGRectGetWidth(self.shareView.frame), 49)];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)shareToApp:(UIButton *)sender
{
    [self cancelShare];
    if (self.shareBlock)
    {
        self.shareBlock(self.titleArray[sender.tag]);
    }
}

- (void)cancelShare
{
    [UIView animateWithDuration:0.3f animations:^
    {
        [_shareView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}

@end
