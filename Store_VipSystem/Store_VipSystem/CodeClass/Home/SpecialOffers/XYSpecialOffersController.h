//
//  XYSpecialOffersController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYSpecialOffersDetailController.h"

@interface XYSpecialOffersController : XYBasicViewController

@property (nonatomic, copy)void(^selectViewModel)(XYRechargeModel *model);

@end
