//
//  XYJointPaymentController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"

@interface XYJointPaymentController : XYBasicViewController

@property (nonatomic, copy)NSString *priceString;

@property (nonatomic, strong)NSMutableDictionary *parameters; // 支付订单参数

@property (nonatomic, copy)NSString *payUrl; // 支付Url

@property (nonatomic, assign) CGFloat balance;


@end
