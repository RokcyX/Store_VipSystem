//
//  XYRechargeEditModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRechargeEditModel.h"

@implementation XYValidTimeModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist rechargeModel:(XYRechargeModel *)rechargeModel {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic rechargeModel:rechargeModel]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic rechargeModel:(XYRechargeModel *)rechargeModel {
    if ([dic count] > 0) {
        XYValidTimeModel *model = [[XYValidTimeModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if (rechargeModel) {
            model.isSelected = NO;
            if (model.rP_ValidType == rechargeModel.rP_ValidType) {
                model.isSelected = YES;
                if (model.modelKey.length) {
                    model.detail = [rechargeModel valueForKey:model.modelKey.lowerHeadCaseString];
                }
                if (model.endModelKey.length) {
                    model.endDetail = [rechargeModel valueForKey:model.endModelKey.lowerHeadCaseString];
                }
            }
        }
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation XYRechargeEditModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist rechargeModel:(XYRechargeModel *)rechargeModel {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic rechargeModel:rechargeModel]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic rechargeModel:(XYRechargeModel *)rechargeModel {
    
    if ([dic count] > 0) {
        XYRechargeEditModel *model = [[XYRechargeEditModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.selectList = [XYValidTimeModel modelConfigureWithArray:model.selectList rechargeModel:rechargeModel];
        if (rechargeModel) {
            id detail = [rechargeModel valueForKey:model.modelKey.lowerHeadCaseString];
            if (detail) {
                model.detail = [NSString stringWithFormat:@"%@", detail];
                if ([model.modelKey isEqualToString:@"RP_ValidType"]) {
                    switch (rechargeModel.rP_ValidType) {
                        case 0:
                            model.detail = @"永久有效";
                            break;
                        case 1:
                            model.detail = [rechargeModel.rP_ValidStartTime stringByAppendingFormat:@" 至 %@", rechargeModel.rP_ValidEndTime];
                            break;
                        case 2:
                            model.detail = [@"每周" stringByAppendingString:rechargeModel.rP_ValidWeekMonth];
                            break;
                        case 3:
                            model.detail = [@"每月" stringByAppendingString:rechargeModel.rP_ValidWeekMonth];
                            break;
                        case 4:
                            model.detail = @"会员生日当天有效";
                            break;
                        default:
                            break;
                    }
                }
                if ([model.updateKey isEqualToString:@"RP_ISDouble"]) {
                    model.updateValue = [rechargeModel valueForKey:model.updateKey.lowerHeadCaseString];
                    model.detail = [model.updateValue boolValue] ? @"翻倍":@"不翻倍";
                }
            }
        } else {

        }
        
        model.seletDatas = [XYRechargeEditModel modelConfigureWithArray:model.seletDatas rechargeModel:nil];
        if (model.seletTitle) {
            for (XYRechargeEditModel *obj in model.seletDatas) {
                NSString *detail = [NSString stringWithFormat:@"%@", [rechargeModel valueForKey:obj.modelKey.lowerHeadCaseString]];
                if (detail.floatValue > 0) {
                    model.modelKey = obj.modelKey;
                    model.seletTitle = obj.title;
                    model.placeholder = obj.placeholder;
                    model.detail = detail;
                }
            }
        }
        
        return model;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSMutableDictionary *)parametersWithDataList:(NSArray *)dataList {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    RP_Discount：优惠折扣、RP_GiveMoney：赠送金额、RP_ReduceMoney：减少金额
    [parameters setValue:@(-1) forKey:@"RP_Discount"];
    [parameters setValue:@(-1) forKey:@"RP_GiveMoney"];
    [parameters setValue:@(-1) forKey:@"RP_ReduceMoney"];

    for (XYRechargeEditModel *model in dataList) {
        if (!model.detail.length && ![model.modelKey isEqualToString:@"RP_ValidType"]) {
            if (model.isRequired) {
                [XYProgressHUD showMessage: @"带 ＊ 为必填"];
                return nil;
            }
        } else {
            if (![model.modelKey isEqualToString:@"RP_ValidType"]) {
                [parameters setValue:model.detail forKey:model.modelKey];
                if (model.updateKey.length) {
                    [parameters setValue:model.updateValue forKey:model.updateKey];
                }
            }
            for (XYValidTimeModel *validTime in model.selectList) {
                if (validTime.isSelected) {
                    [parameters setValue:@(validTime.rP_ValidType) forKey:model.modelKey];
                    NSString *showString;
                    switch (validTime.rP_ValidType) {
                        case 1:
                            if (validTime.endDetail.length && validTime.detail.length) {
                                [parameters setValue:validTime.endDetail forKey:validTime.endModelKey];
                                
                                [parameters setValue:validTime.detail forKey:validTime.modelKey];
                            } else {
                                if (!validTime.detail.length) {
                                    showString = @"请选择开始时间";
                                } else {
                                    showString = @"请选择结束时间";
                                }
                                    
                            }
                            break;
                        case 2:
                            if (validTime.detail.length) {
                                [parameters setValue:validTime.detail forKey:validTime.modelKey];
                            } else {
                                showString = @"请选择星期";
                            }
                            break;
                        case 3:
                            if (validTime.detail.length) {
                                [parameters setValue:validTime.detail forKey:validTime.modelKey];
                            } else {
                                showString = @"请选择天";
                            }
                            break;
                            
                        default:
                            break;
                    }
                    if (showString) {
                        [XYProgressHUD showMessage: showString];
                        return nil;
                    }
                }
            }
        }
    }
    
    return parameters;
}


@end
/*
 RP_Name    主键名称        string        否    0-100
 RP_IsOpen    是否启用        int        是    0-100
 RP_Type    类型        int        否    0-100        1快捷充值，2优惠活动
 RP_RechargeMoney    充值金额/消费金额        decimal        否    0-100
 RP_GiveMoney    赠送金额        decimal        否    0-10
 RP_Discount    优惠折扣        decimal        否    0-10
 RP_ReduceMoney    扣减金额        decimal        否    0-10
 RP_GivePoint    赠送积分        int        是    0-100
 RP_ValidType    期限类型        int        否    0-100        1固定时间段2按每周3按每月4会员生日当天
 RP_ValidWeekMonth    按周或月时的具体天数        string        是    0-100
 RP_ValidStartTime    有效期开始时间        DateTime?        是    0-100
 RP_ValidEndTime    有效期结束时间        DateTime?        是    0-100
 RP_ISDouble    是否翻倍        int        是    0-11        0不翻倍，1翻倍
 RP_Remark    备注        string        是    0-100
 */
