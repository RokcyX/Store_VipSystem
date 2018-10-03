//
//  XYMemberManageModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/7.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMemberManageModel.h"

@implementation XYMemberManageModel


+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist isSelected:(BOOL)isSelected {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic isSelected:isSelected]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic isSelected:(BOOL)isSelected {
    if ([dic count] > 0) {
        XYMemberManageModel *model = [[XYMemberManageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.isSelected = isSelected;
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
