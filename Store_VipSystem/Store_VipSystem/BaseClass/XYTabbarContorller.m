//
//  FATabbarContorller.m
//  friendAssist
//
//  Created by Lyric Don on 2018/1/31.
//  Copyright © 2018年 bill-jc.com. All rights reserved.
//

#import "XYTabbarContorller.h"
#import "XYBaseNavController.h"
#import "XYHomeViewController.h"
#import "XYStatisticsViewController.h"
#import "XYMineViewController.h"

@interface XYTabbarContorller () <UITabBarControllerDelegate>

@end

@implementation XYTabbarContorller

+ (instancetype)merchantsTabbar
{
    XYTabbarContorller *tab = [[XYTabbarContorller alloc] initWithMerchantsControllers];
    return tab;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.tintColor = RGBColor(249, 104, 62);
}

- (instancetype)initWithMerchantsControllers
{
    if (self = [super init])
    {
        [self addChildViewController:[[XYHomeViewController alloc] init] image:@"tabbar_home_normal" seletedImage:@"tabbar_home_selected" title:@"首页"];
//        [self addChildViewController:[[XYStatisticsViewController alloc] init] image:@"tabbar_stat_normal"  seletedImage:@"tabbar_stat_selected"  title:@"统计"];
        [self addChildViewController:[[XYMineViewController alloc] init] image:@"tabbar_mine_normal"  seletedImage:@"tabbar_mine_selected"  title:@"我的"];
    }
    return self;
}


- (void)addChildViewController:(UIViewController *)childController image:(NSString *)image seletedImage:(NSString *)selectedImage title:(NSString *)title
{
    childController.title = title;
    [childController.tabBarItem setImage:[self scaleImage:image]];
    [childController.tabBarItem setSelectedImage:[self scaleImage:selectedImage]];
    [childController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    

    // 包装导航条
//    FANaviController *nav = [[FANaviController alloc] initWithRootViewController:childController];
    XYBaseNavController *nav = [[XYBaseNavController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}

//- (void)viewWillLayoutSubviews
//{
//    CGFloat height = 57.2;
////    if (Is5P5Inch)
////    {
////        height = 63.25;
////    }
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.size.height = height;
//    tabFrame.origin.y = UIScreenHeight - height;
//    self.tabBar.frame = tabFrame;
//}

- (UIImage *)scaleImage:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    
    CGFloat width = 23.6;
//    if (Is5P5Inch)
//    {
//        width = 26;
//    }
    
    CGSize origin = img.size;
    origin.height = width / origin.width * origin.height;
    origin.width = width;
    
    UIGraphicsBeginImageContextWithOptions(origin, NO, [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, origin.width, origin.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navi = (UINavigationController *)viewController;
        UIViewController *con = navi.viewControllers.lastObject;
        if ([con isKindOfClass:[XYHomeViewController class]] ||[con isKindOfClass:[XYMineViewController class]] || [con isKindOfClass:[XYStatisticsViewController class]])
        {
            if (navi.navigationBar.hidden == NO)
            {
                [navi setNavigationBarHidden:YES animated:NO];
            }
        }
        else
        {
            if (navi.navigationBar.hidden == YES)
            {
                [navi setNavigationBarHidden:NO animated:NO];
            }
        }
    }
    
    return YES;
}

@end
