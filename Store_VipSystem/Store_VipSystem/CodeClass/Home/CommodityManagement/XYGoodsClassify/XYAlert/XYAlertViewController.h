//
//  SLAlertController.h
//  washsystem
//
//  Created by Wcaulpl on 2017/6/7.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYGoodsClassifyModel.h"
typedef void(^AlertResult)(void);

@interface XYAlertViewController : UIViewController

@property (nonatomic, strong) XYGoodsClassifyModel *model;

@property (nonatomic, copy) AlertResult alertFinish;
@property (nonatomic, copy) AlertResult alertDelete;

- (instancetype)initWithModel:(XYGoodsClassifyModel *)model defaultActin:(AlertResult)defaultActin deleteActin:(AlertResult)deleteActin;




@end
