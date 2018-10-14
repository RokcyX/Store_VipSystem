//
//  XYParameterSetModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYParameterSetModel.h"

@implementation XYParameterSetModel

+ (NSArray *)modelArray {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ParameterSet" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    return parseDic[@"data"];
}

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *modelList = self.modelArray;
    for (NSDictionary *titleDic in modelList) {
        NSMutableDictionary *parDic = @{@"title":titleDic[@"title"]}.mutableCopy;
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in titleDic[@"parameters"]) {
            XYParameterSetModel *model = [self modelConfigureDic:dic];
            for (NSDictionary *setDic in diclist) {
                if (model.sS_Code.integerValue == [setDic[@"SS_Code"] integerValue]) {
                    [model setValuesForKeysWithDictionary:setDic];
                    if (model.sS_Code.integerValue ==202 && !model.sS_Value.length) {
                        model.sS_Value = @"123456";
                    }
                }
            }
            [models addObject:model];
        }
        [parDic setValue:models forKey:@"models"];
        [array addObject:parDic];
    }
//    for (NSDictionary *dic in diclist) {
//        [array addObject:[self modelConfigureDic:dic]];;
//    }
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

+ (NSArray *)parametersWithSaveList:(NSArray *)dataList {
    return [self parametersWithList:dataList isSave:YES];
}

+ (NSArray *)parametersWithDataList:(NSArray *)dataList {
    return [self parametersWithList:dataList isSave:NO];
}

+ (NSArray *)parametersWithList:(NSArray *)dataList isSave:(BOOL)isSave {
    NSMutableArray *parameters = [NSMutableArray array];
    for (NSDictionary *parDic in dataList) {
        for (XYParameterSetModel *model in parDic[@"models"]) {
            model.sS_Name = model.title;
            model.sS_Update = [LoginModel shareLoginModel].uM_Acount;
            model.sS_UpdateTime = [[NSDate date] stringWithFormatter:@" yyyy-MM-dd HH:mm:ss"];
            if (model.hasValue && model.sS_State && !model.sS_Value.length) {
                if (!isSave) {
                    [XYProgressHUD showMessage:[@"请输入" stringByAppendingString:model.sS_Name]];
                    return nil;
                }
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            unsigned int count;
            objc_property_t *propertyList = class_copyPropertyList(self, &count);
            for (int i = 0; i < count; i++) {
                objc_property_t property = propertyList[i];
                const char *cName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:cName];
                id value = [model valueForKey:name];
                if ([name isEqualToString:@"title"] || [name isEqualToString:@"placeholder"] || [name isEqualToString:@"hasValue"] || [name isEqualToString:@"rightMode"] || [name isEqualToString:@"keyboardType"] || [name isEqualToString:@"enabled"] ) {
                    
                } else {
                    NSString *key = name.upperHeadCaseString;
                    if (!value) {
                        value = @"";
                    }
                    [dic setValue:value forKey:key];
                }
            }
            [parameters addObject:dic];
        }
    }
    return parameters;
}


@end
