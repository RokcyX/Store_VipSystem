//
//  XYPrintSetModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYPrintSetModel.h"

@implementation PrintTimes

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

- (void)printTimesWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *locDic in @[@{@"pT_Code":@"HYCZ",@"pT_Times":@1},@{@"pT_Code":@"HYCC",@"pT_Times":@1},@{@"pT_Code":@"SPXF",@"pT_Times":@1},@{@"pT_Code":@"KSXF",@"pT_Times":@1},@{@"pT_Code":@"JCXF",@"pT_Times":@1},@{@"pT_Code":@"JFDH",@"pT_Times":@1},@{@"pT_Code":@"TCXF",@"pT_Times":@1}]) {
        PrintTimes *model = [PrintTimes modelConfigureDic:locDic];
        model.title = [model.pT_Code stringWithCode];
        [array addObject:model];
    }
    NSMutableArray *paramPrintTimes = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *dic in diclist) {
        PrintTimes *model = [PrintTimes modelConfigureDic:dic];
        BOOL isAdd = false;
        for (PrintTimes *times in array) {
            if ([times.pT_Code isEqualToString:model.pT_Code]) {
                times.pT_Times = model.pT_Times;
                isAdd = YES;
            }
        }
        if (!isAdd && model.pT_Code.length) {
            [paramPrintTimes addObject:model];
        }
    }
    self.printTimesList = array;
    self.paramPrintTimes = paramPrintTimes;
}

- (void)setDictionary:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    [self printTimesWithArray:self.printTimesList];
//    self.printTimesList = [PrintTimes modelConfigureWithArray:self.printTimesList];
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
