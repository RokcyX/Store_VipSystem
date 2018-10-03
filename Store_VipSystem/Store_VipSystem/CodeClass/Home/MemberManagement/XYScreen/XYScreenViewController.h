//
//  XYScreenViewController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/18.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"

@interface XYScreenViewController : XYBasicViewController

@property (nonatomic, copy)void(^screenWithData)(NSDictionary *dic);

@end
