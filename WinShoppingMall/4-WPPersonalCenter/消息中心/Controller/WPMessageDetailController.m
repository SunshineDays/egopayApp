//
//  WPMessageDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/25.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMessageDetailController.h"
#import "Header.h"

@interface WPMessageDetailController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation WPMessageDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";
    
    [self titleLabel];
    [self contentLabel];
    [self dateLabel];
}

#pragma mark - Init

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, WPRowHeight)];
        _titleLabel.text = self.model.title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        [self.scrollView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        
        NSString * contentString = self.model.content;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth - 2 * WPLeftMargin, [WPPublicTool textHeightFromTextString:contentString width:kScreenWidth - 2 * WPLeftMargin miniHeight:WPRowHeight fontSize:15])];
        _contentLabel.text = contentString;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _contentLabel.numberOfLines = 0;
        [self.scrollView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.contentLabel.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _dateLabel.text = [WPPublicTool stringToDateString:self.model.create_time];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.scrollView addSubview:_dateLabel];
        
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(_dateLabel.frame) + 10);
    }
    return _dateLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
