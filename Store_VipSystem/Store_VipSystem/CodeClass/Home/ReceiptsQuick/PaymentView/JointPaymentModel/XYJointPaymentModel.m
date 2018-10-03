//
//  XYJointPaymentModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/23.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYJointPaymentModel.h"

@implementation XYJointPaymentModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist priceString:(NSString *)priceString {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic priceString:priceString]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic priceString:(NSString *)priceString {
    if ([dic count] > 0) {
        XYJointPaymentModel *model = [[XYJointPaymentModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if (!model.iconImage.length) {
            model.detail = priceString;
        }
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
