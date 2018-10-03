//
//  XYStaffEditCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYStaffEditModel.h"
#import "XYDeptModel.h"
@interface XYStaffEditCell : UITableViewCell

@property (nonatomic, weak)XYStaffEditModel *model;

- (void)setModel:(XYStaffEditModel *)model readOnly:(BOOL)readOnly;

@end
