//
//  XYReceivablesFootView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/18.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYReceivablesFootView : UIView

@property (nonatomic, assign)BOOL hiddenPrice;

@property (nonatomic, strong)NSString *priceString;

@property (nonatomic, copy)void(^receivablesPrice)(BOOL msg, BOOL print);

@end
