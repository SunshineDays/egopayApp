//
//  WPShareView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPShareView.h"
#import "Header.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocialQQHandler.h"
#import "WXApi.h"

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

@end

@implementation WPShareView

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
        if ([WXApi isWXAppInstalled]) {
            [_titleArray addObjectsFromArray:@[@"微信好友", @"微信朋友圈"]];
            [_imageArray addObjectsFromArray:@[@"share_wechat", @"share_weixin"]];
        }
        if ([TencentOAuth iphoneQQInstalled]) {
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
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + (i % 5) * (self.iconWidth + 15), 15 + i / 5 * (self.iconWidth + 30), self.iconWidth, self.iconWidth)];
        [iconButton setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        iconButton.layer.borderColor = [UIColor lineColor].CGColor;
        iconButton.layer.borderWidth = WPLineHeight;
        iconButton.layer.cornerRadius = WPCornerRadius;
        iconButton.contentMode = UIViewContentModeScaleAspectFit;
        iconButton.tag = i;
        [iconButton addTarget:self action:@selector(shareToApp:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:iconButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconButton.frame) - 10, CGRectGetMaxY(iconButton.frame), self.iconWidth + 20, 20)];
        titleLabel.text = self.titleArray[i];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.shareView addSubview:titleLabel];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
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
    if (self.shareBlock) {
        self.shareBlock(self.titleArray[sender.tag]);
    }
}

- (void)cancelShare
{
    [UIView animateWithDuration:0.3f animations:^{
        [_shareView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
