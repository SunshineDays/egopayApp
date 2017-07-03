//
//  WPNavigationController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNavigationController.h"
#import "UIColor+WPColor.h"
#import "UIBarButtonItem+WPExtention.h"
#import "UIImage+WPExtension.h"
#import "UIColor+WPExtension.h"

@interface WPNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation WPNavigationController

+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageToColor:[UIColor colorWithRGBString:@"#1B82E3" alpha:1]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:19 weight:2];
    [navigationBar setTitleTextAttributes:dictM];
    navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
