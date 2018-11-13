//
//  XYCountingPaymentController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYMemberManageModel.h"

@interface XYCountingPaymentController : XYBasicViewController

@property (nonatomic, strong)XYMemberManageModel *vipModel;

@property (nonatomic, strong)NSArray *countingModels;

@property (nonatomic,copy)void(^confirmBlock)();

@end
