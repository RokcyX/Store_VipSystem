//
//  HomeIndexModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/5.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "HomeIndexModel.h"
@implementation DataList

+ (NSArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        DataList *model = [[DataList alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation NoticeList
+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        NoticeList *model = [[NoticeList alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.dataList = [DataList modelConfigureWithArray:dic[@"DataList"]];
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation GridData

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        GridData *model = [[GridData alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation GetPast12Sales

+ (NSArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        GetPast12Sales *model = [[GetPast12Sales alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation WelcomData

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        WelcomData *model = [[WelcomData alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation HomeIndexModel

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        HomeIndexModel *model = [[HomeIndexModel alloc] init];
        model.getPast12Sales = [GetPast12Sales modelConfigureWithArray:dic[@"GetPast12Sales"]];
        model.gridData = [GridData modelConfigureDic:dic[@"GridData"]];
        model.getPast12VIP =dic[@"GetPast12VIP"];
        model.noticeList = [NoticeList modelConfigureDic:dic[@"NoticeList"]];
        model.welcomData = [WelcomData modelConfigureDic:dic[@"WelcomData"]];
        return model;
    }
    return nil;
}

@end
