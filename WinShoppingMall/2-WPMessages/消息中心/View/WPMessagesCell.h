//
//  WPMessagesCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/25.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPMessagesModel.h"

@interface WPMessagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@property (nonatomic, strong) WPMessagesModel *model;


@end
