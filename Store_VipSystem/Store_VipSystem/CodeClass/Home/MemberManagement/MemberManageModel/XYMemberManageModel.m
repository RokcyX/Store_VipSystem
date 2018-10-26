//
//  XYMemberManageModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/7.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMemberManageModel.h"

@implementation XYMemberManageModel


+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist datalist:(NSArray *)datalist isSelected:(BOOL)isSelected {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic datalist:datalist isSelected:isSelected]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic datalist:(NSArray *)datalist isSelected:(BOOL)isSelected {
    if ([dic count] > 0) {
        XYMemberManageModel *model;
        for (XYMemberManageModel *obj in datalist) {
            if ([obj.gID isEqualToString:dic[@"GID"]]) {
                model = obj;
            }
        }
        if (!model) {
           model = [[XYMemberManageModel alloc] init];
        }
        [model setValuesForKeysWithDictionary:dic];
        if (isSelected) {
            model.isSelected = isSelected;
        }
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
