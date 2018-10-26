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
        [model setDictionary:dic];
        return model;
    }
    return nil;
}

- (void)setDictionary:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    self.printTimesList = [PrintTimes modelConfigureWithArray:self.printTimesList];
    self.parameters = @{ @"PS_IsEnabled":@(self.pS_IsEnabled),
                         @"PS_IsPreview":@(self.pS_IsPreview),
                         @"PS_PaperType":@(self.pS_PaperType),
                         @"PS_PrinterName":self.pS_PrinterName,
                         @"PS_StylusPrintingName":self.pS_StylusPrintingName,
                         @"PrintTimesList":self.pS_PrintTimes
                         }.mutableCopy;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
