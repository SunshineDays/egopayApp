//
//  WPHomePageView.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "Header.h"


@interface WPHomePageView : UIView

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIView *classView;

@property (nonatomic, strong) WPHomePageCreditButton *creditButton;

@end
