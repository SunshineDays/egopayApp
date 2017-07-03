//
//  WPCardTableViewCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cardImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *backgroundButton;

- (void)tableViewCellImage:(UIImage *)image content:(NSString *)content rectMake:(CGRect)rect;

- (void)tableViewCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect;

@end
