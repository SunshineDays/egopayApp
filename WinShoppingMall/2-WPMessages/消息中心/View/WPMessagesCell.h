//
//  WPMessagesCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/25.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPMessagesModel.h"
#import "WPInvitingPeopleModel.h"
#import "WPSubAccountListModel.h"

@interface WPMessagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

/**  系统消息 */
@property (nonatomic, strong) WPMessagesModel *model;

/**  邀请的人 */
@property (nonatomic, strong) WPInvitingPeopleModel *invitingModel;

/**  子账户 */
@property (nonatomic, strong) WPSubAccountListModel *subAccountModel;


@end
