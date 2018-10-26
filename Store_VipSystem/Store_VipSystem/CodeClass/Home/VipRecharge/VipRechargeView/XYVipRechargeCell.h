//
//  XYVipRechargeCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYVipRechargeModel.h"
#import "XYRechargeModel.h"

@interface XYVipRechargeCell : UITableViewCell

@property (nonatomic, weak)XYVipRechargeModel *model;

- (void)setModel:(XYVipRechargeModel *)model schemelist:(NSArray *)schemelist;

@property (nonatomic, copy)BOOL(^amoutInput)(NSString *result, XYRechargeModel *recharge);
@property (nonatomic, weak)UITextField *textField;
@end
