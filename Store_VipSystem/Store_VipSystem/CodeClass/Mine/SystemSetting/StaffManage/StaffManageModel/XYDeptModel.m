//
//  XYDeptModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYDeptModel.h"

@implementation XYDeptModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
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
