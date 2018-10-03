//
//  XYPrintSetModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYPrintSetModel.h"

@implementation PrintTimes

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        PrintTimes *model = [self modelConfigureDic:dic];
        model.title = [model.pT_Code stringWithCode];
        if (model.title.length) {
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

@implementation XYPrintSetModel

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        XYPrintSetModel *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.printTimesList = [PrintTimes modelConfigureWithArray:model.printTimesList];
        model.parameters = @{@"PS_IsEnabled":@(model.pS_IsEnabled),
                             @"PS_IsPreview":@(model.pS_IsPreview),
                             @"PS_PaperType":@(model.pS_PaperType),
                             @"PS_PrinterName":model.pS_PrinterName,
                             @"PS_StylusPrintingName":model.pS_StylusPrintingName,
                             @"PrintTimesList":model.pS_PrintTimes
                                       }.mutableCopy;

        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
