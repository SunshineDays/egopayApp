//
//  WPHomePageController.m
//  WinShoppingMall
//  主页
//  Created by 易购付 on 2017/3/20.
//  Copyright © 2017年 易购付. All rights reserved.
//
#import "WPTabBarController.h"
#import "WPHomePageController.h"
#import "WPMessagesController.h"
#import "WPPersonalCenterController.h"
#import "WPAgencyController.h"
#import "WPUserInfor.h"
#import "WPNavigationController.h"
#import "WPSubAccountPersonalController.h"
#import "WPJudgeTool.h"

@interface WPTabBarController () <UITabBarDelegate>

@end

@implementation WPTabBarController {
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSArray *_ctrlsArray;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - init

- (void)createViewControllers
{
    if ([WPJudgeTool isSubAccount])
    {
        _titleArray = @[@"消息", @"我"];
        _imageArray = @[@"icon_xiaoxi_tab", @"icon_daili_tab"];
        _ctrlsArray = @[[[WPMessagesController alloc] init], [[WPSubAccountPersonalController alloc] init]];
    }
    else
    {
        _titleArray = @[@"主页", @"消息", @"代理", @"我"];
        _imageArray = @[@"icon_shouye_tab", @"icon_xiaoxi_tab", @"icon_me_tab", @"icon_daili_tab"];
        _ctrlsArray = @[[[WPHomePageController alloc] init], [[WPMessagesController alloc] init],[[WPAgencyController alloc] init], [[WPPersonalCenterController alloc] init]];
    }
    for (NSInteger i = 0 ; i < _titleArray.count; i++)
    {
        [self setupOneChildVc:[[WPNavigationController alloc] initWithRootViewController:_ctrlsArray[i]] image:[NSString stringWithFormat:@"%@_n",_imageArray[i]] selectedImage:[NSString stringWithFormat:@"%@_s",_imageArray[i]] title:_titleArray[i]];
    }
}

- (void)setupOneChildVc:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    childVc.tabBarItem.title = title;
    if (image.length) childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (selectedImage.length) childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:childVc];
}

@end
