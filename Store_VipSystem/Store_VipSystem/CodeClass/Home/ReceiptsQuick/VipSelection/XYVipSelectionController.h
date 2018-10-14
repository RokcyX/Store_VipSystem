//
//  XYVipSelectionController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/17.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYMemberManageModel.h"

@interface XYVipSelectionController : XYBasicViewController

@property (nonatomic, copy)void(^selectModel)(XYMemberManageModel *model);

- (void)searchFromLastPageWithCode:(NSString *)code;

@end
