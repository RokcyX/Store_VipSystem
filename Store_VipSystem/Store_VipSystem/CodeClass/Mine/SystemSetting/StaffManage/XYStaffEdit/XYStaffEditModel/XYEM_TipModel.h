//
//  XYEM_TipModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYEmplModel.h"

@interface XYEM_TipModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *updateKey;
@property (nonatomic, assign)BOOL isSelected;

+ (NSArray *)eM_TipModelWithEmplModel:(XYEmplModel *)empl;

@end
