//
//  XYKeyboardView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYKeyboardToolbar.h"
typedef enum : NSUInteger {
    KeyboardTypeDatePicker,
    KeyboardTypeStringPicker,
    KeyboardTypeDaysNumber,
    KeyboardTypetime,
} KeyboardType;

@interface XYKeyboardView : UIView

@property (nonatomic, assign)KeyboardType keyboardType;

+ (XYKeyboardView *)keyBoardWithType:(KeyboardType)keyboardType;

+ (XYKeyboardView *)keyBoardWithCount:(NSInteger)count;

@property (nonatomic, copy)NSString *string;
@property (nonatomic, copy)NSString *seletedNum;


@property (nonatomic, assign)NSInteger count;
@property (nonatomic, copy)NSString *(^titleForRow)(NSInteger row);
@end
