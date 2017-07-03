//
//   WPBarButton.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,  WPBarButtonType) {
    // 默认
         WPBarButtonTypeDefault = 0,
    //图左文右
         WPBarButtonTypeImageLeft = 1,
    // 图右文左
         WPBarButtonTypeImageRight = 2,
    // 图上文下
         WPBarButtonTypeImageUp = 3,
    // 图下文上
         WPBarButtonTypeImageDown = 4
};

@interface  WPBarButton : UIButton

//  按钮类型
@property (nonatomic, assign)  WPBarButtonType barButtonType;

- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title;

+ (instancetype)barButtonWithTarget:(id)target action:(SEL)action title:(NSString *)title;


@end
