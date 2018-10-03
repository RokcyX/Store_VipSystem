//
//  XYVipRechargeModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYVipRechargeModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic , copy)NSString *placeholder;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *updateValue;
@property (nonatomic, copy)NSString *textColor;
@property (nonatomic, assign)NSInteger systemAllow;
@property (nonatomic, assign)BOOL rightMode;
@property (nonatomic, assign)BOOL isWritable;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;
@end
