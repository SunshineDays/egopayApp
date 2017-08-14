//
//  WPPersonalCenterCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPersonalCenterCell.h"

@implementation WPPersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
