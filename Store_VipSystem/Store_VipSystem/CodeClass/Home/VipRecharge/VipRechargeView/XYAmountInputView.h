//
//  XYAmountInputView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAmountInputView : UIView

@property (nonatomic, copy)void(^inputString)(NSString *result, BOOL isFinished);

@property (nonatomic, copy)NSString *resultString;

@end
