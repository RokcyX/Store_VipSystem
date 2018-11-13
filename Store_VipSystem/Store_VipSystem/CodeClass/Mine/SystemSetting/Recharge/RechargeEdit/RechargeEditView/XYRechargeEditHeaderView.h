//
//  XYRechargeEditHeaderView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRechargeEditModel.h"

typedef void(^ValueDidChanged) (void);

@interface XYRechargeEditHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak)XYRechargeEditModel *model;

@property (nonatomic,copy) ValueDidChanged valueDidChangedBlock;

@end
