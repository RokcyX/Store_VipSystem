//
//  XYMessageViewController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYMessageViewCell.h"

@interface XYMessageViewController : XYBasicViewController

@property (nonatomic, assign)NSInteger pageTotal;
@property (nonatomic, strong)NSMutableArray *datalist;

@property (nonatomic, copy)dispatch_block_t loadDataFinish;

@end
