//
//  SLAlertController.h
//  washsystem
//
//  Created by Wcaulpl on 2017/6/7.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDeptModel.h"

typedef void(^AlertResult)(void);

@interface XYDeptEditController : UIViewController

@property (nonatomic, strong) XYDeptModel *model;

@property (nonatomic, copy) AlertResult alertFinish;
@property (nonatomic, copy) AlertResult alertDelete;

- (instancetype)initWithModel:(XYDeptModel *)model defaultActin:(AlertResult)defaultActin deleteActin:(AlertResult)deleteActin;




@end
