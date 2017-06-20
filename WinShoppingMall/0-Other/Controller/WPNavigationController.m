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

@interface WPNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation WPNavigationController

+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageToColor:[UIColor themeColor]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:19 weight:2];
    [navigationBar setTitleTextAttributes:dictM];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:@selector(pop) image:[UIImage imageNamed:@"icon_fanhui_nav_n"] highImage:nil];
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)pop
{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //    NSLog(@"%@",self.childViewControllers);
    return [super popViewControllerAnimated:animated];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
