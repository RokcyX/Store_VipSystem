//
//  XYRechargeModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRechargeModel.h"

@implementation XYRechargeModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist type:(NSInteger)type {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        if ([dic[@"RP_Type"] integerValue] == type) {
            [array addObject:[self modelConfigureDic:dic]];;
        }
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        id model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
