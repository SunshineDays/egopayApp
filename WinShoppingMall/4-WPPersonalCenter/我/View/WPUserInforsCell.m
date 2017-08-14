//
//  WPUserInforsCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserInforsCell.h"

@implementation WPUserInforsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.avaterImageView.layer.cornerRadius = 6;
    self.avaterImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
