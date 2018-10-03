//
//  XYAddClassifyController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/22.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"
#import "XYGoodsClassifyModel.h"

@interface XYAddClassifyController : XYBasicViewController

@property (nonatomic, weak)XYGoodsClassifyModel *model;

@property (nonatomic, copy)void(^addClassifyFinished)(XYGoodsClassifyModel *model);

@end
