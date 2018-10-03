//
//  XYGoodsClassifyController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYAddClassifyController.h"

@interface XYGoodsClassifyController : XYBasicViewController

@property (nonatomic, copy)void(^finishedSelected)(XYGoodsClassifyModel *model);
@property (nonatomic , copy) NSString              * pT_Name;

@end
