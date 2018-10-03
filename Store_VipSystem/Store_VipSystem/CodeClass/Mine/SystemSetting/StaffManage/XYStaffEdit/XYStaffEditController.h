//
//  XYStaffEditController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYEmplModel.h"
@interface XYStaffEditController : XYBasicViewController

@property (nonatomic, weak)XYEmplModel *model;
@property (nonatomic, weak)NSMutableArray *deptList;
@property (nonatomic, assign)BOOL readOnly;

@end
