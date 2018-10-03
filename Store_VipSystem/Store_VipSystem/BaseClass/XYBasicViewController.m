//
//  FABasicViewController.m
//  friendAssist
//
//  Created by Lyric Don on 2018/2/6.
//  Copyright © 2018年 bill-jc.com. All rights reserved.
//

#import "XYBasicViewController.h"

@interface XYBasicViewController ()

@end

@implementation XYBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        self.tabBarController.tabBar.hidden =YES;
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.tabBarController.tabBar.hidden == YES)
    {
        self.tabBarController.tabBar.hidden =NO;
    }
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)placeOrderWithMsg:(BOOL)msg print:(BOOL)print {
    [XYPrinterMaker destroy];
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
