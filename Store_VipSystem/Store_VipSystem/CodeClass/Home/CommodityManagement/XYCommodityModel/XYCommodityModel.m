//
//  XYCommodityModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCommodityModel.h"

@implementation XYCommodityModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist alldataList:(NSMutableArray *)datalist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        BOOL isAdd = false;
        for (XYCommodityModel *obj in datalist) {
            if ([obj.gID isEqualToString:dic[@"GID"]]) {
                [array addObject:obj];
                isAdd = YES;
            }
        }
        if (!isAdd) {
            XYCommodityModel *model = [self modelConfigureDic:dic];
            [datalist addObject:model];
            [array addObject:model];
        }
    }
    return array;
}

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        XYCommodityModel *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.pM_Repertory = model.stock_Number;
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
