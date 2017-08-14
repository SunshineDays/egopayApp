//
//  WPMerchantPhotoView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantPhotoView.h"

@interface WPMerchantPhotoView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *picTitleLabel;

@property (nonatomic, assign) float picW;

@property (nonatomic, assign) float space;

@end

@implementation WPMerchantPhotoView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.space = 20;
        self.picW = (kScreenWidth - 3 * self.space) / 2;
        [self initPicImageButtons];
        [self postButton];
    }
    return self;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (WPCustomRowCell *)busilicenceCell
{
    if (!_busilicenceCell) {
        _busilicenceCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, 10, kScreenWidth, WPRowHeight);
        [_busilicenceCell rowCellTitle:@"营业执照编号" placeholder:@"请输入营业执照编号" rectMake:rect];
        [_busilicenceCell.textField setFrame:CGRectMake(CGRectGetMaxX(_busilicenceCell.titleLabel.frame) + 10, 0, kScreenWidth - CGRectGetMaxX(_busilicenceCell.titleLabel.frame) - WPLeftMargin, WPRowHeight)];
        [_busilicenceCell.textField becomeFirstResponder];
        [self.scrollView addSubview:_busilicenceCell];
    }
    return _busilicenceCell;
}

- (WPCustomRowCell *)classifyCell {
    if (!_classifyCell) {
        _classifyCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.busilicenceCell.frame), kScreenWidth, WPRowHeight);
        [_classifyCell rowCellTitle:@"店铺分类" buttonTitle:@"请选择店铺分类" rectMake:rect];
        [self.scrollView addSubview:_classifyCell];
    }
    return _classifyCell;
}

- (UITextView *)shopDescripTextView
{
    if (!_shopDescripTextView) {
        _shopDescripTextView = [[UITextView alloc] initWithFrame:CGRectMake(WPLeftMarginField, CGRectGetMaxY(self.classifyCell.frame) + 5, kScreenWidth - WPLeftMarginField - WPLeftMargin, 100)];
        _shopDescripTextView.backgroundColor = [UIColor whiteColor];
        _shopDescripTextView.layer.masksToBounds = YES;
        _shopDescripTextView.layer.borderColor = [UIColor lineColor].CGColor;
        _shopDescripTextView.layer.borderWidth = 1.0f;
        _shopDescripTextView.layer.cornerRadius = WPCornerRadius;
        _shopDescripTextView.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _shopDescripTextView.text = @"请输入店铺描述(不少于20字儿)";
        _shopDescripTextView.textColor = [UIColor placeholderColor];
        
        _shopDescripTextView.scrollEnabled = YES;
        [self.scrollView addSubview:_shopDescripTextView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.classifyCell.frame), 80, WPRowHeight)];
        titleLabel.text = @"店铺描述";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.scrollView addSubview:titleLabel];
        [self numberLabel];
    }
    return _shopDescripTextView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - WPLeftMargin - 100, CGRectGetMaxY(self.shopDescripTextView.frame), 100, 20)];
        _numberLabel.text = @"0/200";
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.scrollView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (UILabel *)picTitleLabel
{
    if (!_picTitleLabel) {
        _picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.shopDescripTextView.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _picTitleLabel.text = @"请选择照片:";
        [self.scrollView addSubview:_picTitleLabel];
    }
    return _picTitleLabel;
}

- (UIView *)picView
{
    if (!_picView) {
        _picView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.picTitleLabel.frame), kScreenWidth, (self.space + self.picW) * 3)];
        _picView.userInteractionEnabled = YES;
        [self.scrollView addSubview:_picView];
    }
    return _picView;
}

- (void)initPicImageButtons
{
    NSArray *picTitleArray = @[@"营业执照照片", @"许可证照片(可选)", @"店铺门面照", @"店铺照片1", @"店铺照片2"];
    for (int i = 0; i < 5; i++) {
        WPSelectImageButton *imageButton = [WPSelectImageButton buttonWithType:UIButtonTypeCustom];
        [imageButton setFrame:CGRectMake(self.space + (self.picW + self.space) * (i % 2), 0 + (self.picW + self.space) * (i / 2), self.picW, self.picW)];
        [imageButton setImage:[UIImage imageNamed:@"icon-jiahao_content_n"] forState:UIControlStateNormal];
        [imageButton setTitle:picTitleArray[i] forState:UIControlStateNormal];
        [self.picView addSubview:imageButton];
    }
}

- (WPButton *)postButton
{
    if (!_postButton) {
        _postButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.picView.frame) + 30, kScreenWidth - WPLeftMargin * 2, WPButtonHeight)];
        [_postButton setTitle:@"提交认证" forState:UIControlStateNormal];
        [self.scrollView addSubview:_postButton];
        
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.postButton.frame) + 10);
    }
    return _postButton;
}


@end
