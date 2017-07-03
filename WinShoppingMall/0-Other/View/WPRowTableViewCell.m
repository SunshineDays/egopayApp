//
//  WPRowTableViewCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/26.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRowTableViewCell.h"
#import "WPAppConst.h"
#import "UIColor+WPColor.h"


@implementation WPRowTableViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)initTitleLabel:(NSString *)title
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, 80, self.frame.size.height - WPLineHeight)];
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - WPLineHeight, self.frame.size.width, WPLineHeight)];
        _lineView.backgroundColor = [UIColor lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (void)tableViewCellTitle:(NSString *)title contentTitle:(NSString *)contentTitle rectMake:(CGRect)rect
{
    self.frame = rect;
    
    [self initTitleLabel:title];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, rect.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, rect.size.height - WPLineHeight)];
    _contentLabel.text = contentTitle;
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_contentLabel];
    
    [self lineView];
}

- (void)tableViewCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect
{
    self.frame = rect;
    if (title) {
        [self initTitleLabel:title];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, rect.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, rect.size.height - WPLineHeight)];
    }
    else {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, rect.size.width - 2 * WPLeftMargin, rect.size.height - WPLineHeight)];
    }
    
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = placeholder;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:dict];
    [_textField setAttributedPlaceholder:attribute];
    [self addSubview:_textField];
    
    [self lineView];
}


- (void)tableViewCellTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rectMake:(CGRect)rect
{
    self.frame = rect;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [self initTitleLabel:title];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, rect.size.width - (CGRectGetMaxX(self.titleLabel.frame) + 10) - WPLeftMargin, rect.size.height - WPLineHeight)];
    [_button setTitle:buttonTitle forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor placeholderColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_button];
    
    [self lineView];
}

- (void)tableViewCellTitle:(NSString *)title imageArray:(NSArray *)imageArray rectMake:(CGRect)rect
{
    self.frame = rect;
    
    [self initTitleLabel:title];
    
    for (int i = 0; i < imageArray.count; i++) {
        _imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10 + rect.size.height * i, 10, rect.size.height - 10, rect.size.height - 20)];
        _imageViews.contentMode = UIViewContentModeScaleAspectFit;
        _imageViews.image = [UIImage imageNamed:imageArray[i]];
        [self addSubview:_imageViews];
    }
    
    [self lineView];
}

- (void)tableViewCellTitle:(NSString *)title rectMake:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [UIColor whiteColor];
    
    [self initTitleLabel:title];
    
    _switchs = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - WPLeftMargin - 40, (self.frame.size.height - 30) / 2, 40, 30)];
    [self addSubview:_switchs];
    
    [self lineView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
