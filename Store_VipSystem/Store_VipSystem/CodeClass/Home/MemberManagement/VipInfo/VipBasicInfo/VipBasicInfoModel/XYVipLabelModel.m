//
//  XYVipLabelModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipLabelModel.h"

@implementation XYVipLabelModel


+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist vIP_Label:(NSString *)vIP_Label {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic vIP_Label:vIP_Label]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic vIP_Label:(NSString *)vIP_Label {
    if ([dic count] > 0) {
        XYVipLabelModel *model = [[XYVipLabelModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [model defaultVIP_Label:vIP_Label];
        return model;
    }
    return nil;
}

- (void)defaultVIP_Label:(NSString *)vIP_Label {
    if (vIP_Label) {
        NSData *JSONData = [vIP_Label dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in responseJSON) {
            if ([self.mL_GID isEqualToString:dic[@"ItemGID"]]) {
                if ([dic.allKeys containsObject:@"isChecked"]) {
                    self.isSelected = [dic[@"isChecked"] boolValue];
                } else {
                    self.isSelected = YES;
                }
            }
        }
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
