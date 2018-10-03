//
//  XYInvoicingViewController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYPaymentView.h"
#import "XYVipCheckControl.h"

@interface XYInvoicingViewController : XYBasicViewController

@property (nonatomic, strong)NSArray *goodslist;

@property (nonatomic, assign)BOOL isConsume; // 是否商品消费

@end
