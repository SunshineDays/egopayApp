//
//  WPMessagesCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/25.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMessagesCell.h"
#import "Header.h"

@implementation WPMessagesCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setModel:(WPMessagesModel *)model
{
    self.titleLabel.text = model.title;
    
    NSString *dateString = [WPPublicTool stringToDateString:model.create_time];
    self.dataLabel.text = [WPPublicTool dateStringWith:dateString];
}

- (void)setInvitingModel:(WPInvitingPeopleModel *)invitingModel
{
    self.titleLabel.text = [WPPublicTool stringStarWithString:[NSString stringWithFormat:@"%@", invitingModel.phone] headerIndex:3 footerIndex:4];
    
    NSString *dateString = [WPPublicTool stringToDateString:invitingModel.registerDate];
    self.dataLabel.text = [WPPublicTool dateStringWith:dateString];
}


- (void)setSubAccountModel:(WPSubAccountListModel *)subAccountModel
{
    self.titleLabel.text = subAccountModel.clerkName;
    
    self.dataLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
