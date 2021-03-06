//
//  XYRechargeEditCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRechargeEditModel.h"
@interface XYRechargeEditCell : UITableViewCell

@property (nonatomic, weak)XYValidTimeModel *model;

@property (nonatomic, copy)void(^selectModel)(XYValidTimeModel *model);

@end
