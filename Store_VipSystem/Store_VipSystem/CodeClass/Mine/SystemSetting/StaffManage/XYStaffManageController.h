//
//  XYStaffManageController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYStaffEditController.h"

@interface XYStaffManageController : XYBasicViewController

@property (nonatomic, copy)void(^selectViewModel)(NSArray *models);

@property (nonatomic, copy)NSString *key;

@end
