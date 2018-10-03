//
//  XYShoppingCartView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/24.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCommodityModel.h"
@interface XYShoppingCartView : UIViewController

- (instancetype)initWithDataList:(NSArray *)datalist emptyFinished:(void (^)(void))emptyFinished;

@end
