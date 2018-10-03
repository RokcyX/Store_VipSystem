//
//  XYGoodsClassifyModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYGoodsClassifyModel.h"

@implementation XYGoodsClassifyModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        if (![dic[@"PT_Parent"] length]) {
            XYGoodsClassifyModel *model = [self modelConfigureDic:dic];
            [array addObject:model];
            model.subList = [model configSubListWithArray:diclist];
        }
    }
    return array;
}

- (NSMutableArray *)configSubListWithArray:(NSArray *)list {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        if ([dic[@"PT_Parent"] isEqualToString:self.gID]) {
            XYGoodsClassifyModel *model = [XYGoodsClassifyModel modelConfigureDic:dic];
            [array addObject:model];
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
