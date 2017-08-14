//
//  WPMerchantPhotoView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"


@interface WPMerchantPhotoView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WPCustomRowCell *busilicenceCell;

@property (nonatomic, strong) WPCustomRowCell *classifyCell;

@property (nonatomic, strong) UITextView *shopDescripTextView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIView *picView;

@property (nonatomic, strong) WPButton *postButton;




@end
