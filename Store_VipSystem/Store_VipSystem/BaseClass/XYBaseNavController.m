//
//  FABaseNavController.m
//  friendAssist
//
//  Created by lala on 2018/2/11.
//  Copyright © 2018年 bill-jc.com. All rights reserved.
//

#import "XYBaseNavController.h"

@interface XYBaseNavController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,weak) UIViewController *currentShowVC;
@end

@implementation XYBaseNavController


-(id)initWithRootViewController:(UIViewController *)rootViewController {
    XYBaseNavController *nav = [super initWithRootViewController:rootViewController]; nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1){
        self.currentShowVC = nil;
        
    } else{
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowVC == self.topViewController) {
            return YES;
        }
        return NO;
    }
    return YES;
}

 - (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer { UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil; if (self.view.gestureRecognizers.count > 0) { for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) { if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) { screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer; break; } } } return screenEdgePanGestureRecognizer;
     
 }

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count > 0)
    {
        UIImage * backImage = [UIImage imageNamed:@"back_navi"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [btn setImage:backImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = item;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    // navi背景图片主题管理
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"backImage_navi"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    
//    [self setBackgroundColor];

    // Do any additional setup after loading the view.
}

- (void)setBackgroundColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBColor(253, 143, 38).CGColor, (__bridge id)RGBColor(252, 113, 34).CGColor, (__bridge id)RGBColor(252, 83, 32).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, -20, CGRectGetMaxX(self.navigationBar.frame), CGRectGetMaxY(self.navigationBar.frame) + 20);
//    [self.navigationBar.layer addSublayer:gradientLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
