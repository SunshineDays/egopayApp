//
//  WPCustomRowCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPCustomRowCell.h"
#import "WPAppConst.h"
#import "UIColor+WPColor.h"

@interface WPCustomRowCell ()

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;

@end

@implementation WPCustomRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        float width;
        if (self.titleStr.length == 0) {
            width = 0;
        }
        else if (self.titleStr.length > 5) {
            width = 80 + (self.titleStr.length - 5) * WPFontDefaultSize;
        }
        else {
            width = 80;
        }
        [_titleLabel setFrame:CGRectMake(WPLeftMargin, 0, width, self.frame.size.height - WPLineHeight)];
        _titleLabel.text = self.titleStr;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - WPLineHeight, self.frame.size.width, WPLineHeight)];
        _lineView.backgroundColor = [UIColor lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, self.frame.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, self.frame.size.height - WPLineHeight)];
        _contentLabel.text = self.contentStr;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, self.frame.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, self.frame.size.height - WPLineHeight)];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _textField.placeholder = self.contentStr;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, self.frame.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, self.frame.size.height - WPLineHeight)];
        [_button setTitle:self.contentStr forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor placeholderColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_button];
    }
    return _button;
}

- (void)rowCellTitle:(NSString *)title contentTitle:(NSString *)contentTitle rectMake:(CGRect)rect
{
    self.frame = rect;
    
    self.titleStr = title;
    
    self.contentStr = contentTitle;
    [self contentLabel];
    
    [self lineView];
}

- (void)rowCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect
{
    self.frame = rect;
    
    self.titleStr = title;
    
    self.contentStr = placeholder;
    [self textField];
    
    [self lineView];
}


- (void)rowCellTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rectMake:(CGRect)rect
{
    self.frame = rect;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.titleStr = title;
   
    self.contentStr = buttonTitle;
    [self button];
    
    [self lineView];
}

- (void)rowCellTitle:(NSString *)title imageArray:(NSArray *)imageArray rectMake:(CGRect)rect
{
    self.frame = rect;
    
    self.titleStr = title;
    
    for (int i = 0; i < imageArray.count; i++) {
        _imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10 + rect.size.height * i, 10, rect.size.height - 10, rect.size.height - 20)];
        _imageViews.contentMode = UIViewContentModeScaleAspectFit;
        _imageViews.image = [UIImage imageNamed:imageArray[i]];
        [self addSubview:_imageViews];
    }
    
    [self lineView];
}

- (void)rowCellTitle:(NSString *)title rectMake:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleStr = title;
    [self titleLabel];
        
    self.switchs = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - WPLeftMargin - 40, (self.frame.size.height - 30) / 2, 40, 30)];
    [self addSubview:_switchs];
    
    [self lineView];
}
@end
