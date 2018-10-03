//
//  FABasicViewController.h
//  friendAssist
//
//  Created by Lyric Don on 2018/2/6.
//  Copyright © 2018年 bill-jc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// 默认隐藏Tabbar
@interface XYBasicViewController : UIViewController

@property (nonatomic, copy)void(^dataOverload)(void);

- (void)placeOrderWithMsg:(BOOL)msg print:(BOOL)print;

@end
