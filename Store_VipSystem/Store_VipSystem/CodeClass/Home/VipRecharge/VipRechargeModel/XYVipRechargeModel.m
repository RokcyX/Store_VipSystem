//
//  XYVipRechargeModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipRechargeModel.h"

@implementation XYVipRechargeModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        XYVipRechargeModel *model = [[XYVipRechargeModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.title isEqualToString:@"提成员工"] || [model.title isEqualToString:@"员工提成"]) {
            for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets[2][@"models"]) {
                if ([obj.title isEqualToString:@"员工提成"]) {
                    model.systemAllow = obj.sS_State;
                }
            }
        }
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
