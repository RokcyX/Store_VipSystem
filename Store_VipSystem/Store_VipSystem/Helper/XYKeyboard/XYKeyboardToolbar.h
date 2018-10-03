//
//  SLToolbar.h
//  WashCircle
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYKeyboardToolbar : UIToolbar

+ (XYKeyboardToolbar *)defaultToolbar;

@property(nonatomic, copy)void(^finished)(BOOL success);

@end
