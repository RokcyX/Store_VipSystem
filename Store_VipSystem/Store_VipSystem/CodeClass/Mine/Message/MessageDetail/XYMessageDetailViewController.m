//
//  XYMessageDetailViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMessageDetailViewController.h"

@interface XYMessageDetailViewController ()

@end

@implementation XYMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    /*         *            *          ************
     *       *****       ********      *    *     *
     *         *         *      *      ************
     *     *********     ********      *    *     *
     *       * * *      **********     ************
     *      *  *  *    * *       *    *     *     *
     *     *   *   *  *  *********   *      *    **
     */
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *content = [[UILabel alloc] init];
    content.numberOfLines = 0;
    NSString *str1 = [NSString htmlEntityDecode:self.content];
    //2.将HTML字符串转换为attributeString
    NSAttributedString * attributeStr = [str1 htmlStringToAttributedString];
    //3.使用label加载html字符串
    content.attributedText = attributeStr;
    self.view = content;
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
