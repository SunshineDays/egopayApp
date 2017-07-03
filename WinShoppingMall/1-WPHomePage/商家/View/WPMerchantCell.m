//
//  WPMerchantCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/26.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantCell.h"
//#import "Header.h"

@implementation WPMerchantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(WPMerchantModel *)model {
//    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRefreshCached];
    self.shopImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover_url]]];
    
    self.shopNameLabel.text = model.shopName;
    self.shopDescpLabel.text = model.descp;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
