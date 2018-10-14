//
//  XYJointPaymentCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/23.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYJointPaymentModel.h"

@interface XYJointPaymentCell : UITableViewCell

@property (nonatomic, weak)XYJointPaymentModel *model;
@property (nonatomic, copy)void(^selectCoupons)(XYJointPaymentModel *obj);

@property (nonatomic, copy) dispatch_block_t priceChanged;

@property (nonatomic, assign) CGFloat balance;

@end
