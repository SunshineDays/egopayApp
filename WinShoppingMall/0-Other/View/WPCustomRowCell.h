//
//  WPCustomRowCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCustomRowCell : UITableViewCell

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
- (void)rowCellTitle:(NSString *)title contentTitle:(NSString *)contentTitle rectMake:(CGRect)rect;

/**
 *  标题 输入框
 *  label - textField
 */
- (void)rowCellTitle:(NSString *)title placeholder:(NSString *)placeholder rectMake:(CGRect)rect;

/**
 *  标题 按钮
 *  label - button
 */
- (void)rowCellTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rectMake:(CGRect)rect;

/**
 *  标题 图片
 *  label - imageView
 */
- (void)rowCellTitle:(NSString *)title imageArray:(NSArray *)imageArray rectMake:(CGRect)rect;

/**
 *  标题 开关
 *  label - switch
 */
- (void)rowCellTitle:(NSString *)title rectMake:(CGRect)rect;
@end
