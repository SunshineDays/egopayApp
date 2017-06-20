//
//  WPRowTableViewCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/26.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPRowTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *imageViews;

@property (nonatomic, strong) UISwitch *switchs;

@property (nonatomic, strong) UIView *lineView;

/**
 *  标题 内容
 *  label - label
 */
- (void)tableViewCellTitle:(NSString *)title contentTitle:(NSString *)contentTitle rectMake:(CGRect)rect;

/**
 *  标题 输入框
 *  label - textField
 */
- (void)tableViewCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect;

/**
 *  标题 按钮
 *  label - button
 */
- (void)tableViewCellTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rectMake:(CGRect)rect;

/**
 *  标题 图片
 *  label - imageView
 */
- (void)tableViewCellTitle:(NSString *)title imageArray:(NSArray *)imageArray rectMake:(CGRect)rect;

/**
 *  标题 图片
 *  label - switch
 */
- (void)tableViewCellTitle:(NSString *)title rectMake:(CGRect)rect;


@end
