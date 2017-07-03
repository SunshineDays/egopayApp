//
//  WPCardTableViewCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPCardTableViewCell.h"
#import "WPAppConst.h"
#import "UIColor+WPColor.h"


@implementation WPCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)tableViewCellImage:(UIImage *)image content:(NSString *)content rectMake:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin, (rect.size.height - 40) / 2, 40, 40)];
    _cardImageView.image = image;
    _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_cardImageView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cardImageView.frame) + 17.5, 0, rect.size.width - (CGRectGetMaxX(_cardImageView.frame) + 15) - WPLeftMargin, rect.size.height)];
    _contentLabel.text = content;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.font = [UIFont systemFontOfSize:17];
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self addSubview:_backgroundButton];
}


- (void)tableViewCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [UIColor whiteColor];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 0, 80, self.frame.size.height - WPLineHeight)];
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, rect.size.width - 75 - WPLeftMargin, rect.size.height - WPLineHeight)];
    
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = placeholder;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
//    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:dict];
//    [_textField setAttributedPlaceholder:attribute];
    [self addSubview:_textField];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
