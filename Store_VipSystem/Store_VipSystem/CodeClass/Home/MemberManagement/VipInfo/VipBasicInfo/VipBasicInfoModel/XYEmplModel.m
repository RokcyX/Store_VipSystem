//
//  XYEmplModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYEmplModel.h"

@implementation XYEmplModel

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
