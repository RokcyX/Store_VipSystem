//
//  XYConfirmPayModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYConfirmPayModel.h"

@implementation XYConfirmPayModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist priceString:(NSString *)priceString {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic priceString:priceString]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic priceString:(NSString *)priceString {
    if ([dic count] > 0) {
        XYConfirmPayModel *model = [[XYConfirmPayModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.title isEqualToString:@"订单编号："]) {
            model.updateValue = model.detail = @"KS".orderCode;
        }
        
        if ([model.title isEqualToString:@"订单日期："]) {
            model.updateValue = model.detail = [[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"];
            
        }
        
        if ([model.title isEqualToString:@"订单金额："]) {
            model.detail = priceString;
            model.updateValue = priceString;
        }
        
        if ([model.title isEqualToString:@"折后金额："]) {
            model.detail = priceString;
            model.updateValue = priceString;
            model.isWritable = NO;
            for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets[2][@"models"]) {
                if ([obj.title isEqualToString:@"折后金额修改"]) {
                    model.isWritable = obj.sS_State;
                }
            }
        }
        
        if ([model.title isEqualToString:@"员工提成"]) {
            for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets[2][@"models"]) {
                if ([obj.title isEqualToString:@"员工提成"]) {
                    model.enabled = obj.sS_State;
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
