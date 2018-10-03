//
//  XYMemberManageCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/6.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMemberManageModel.h"
@interface XYMemberManageCell : UITableViewCell

@property (nonatomic, weak)XYMemberManageModel *model;


@property (nonatomic, copy) dispatch_block_t checkBoxAction;

@end
