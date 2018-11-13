//
//  XYVipBasicInfoModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAddGoodsModel.h"

@implementation XYAddGoodsModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist commodityModel:(XYCommodityModel *)commodityModel {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic commodityModel:commodityModel]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic commodityModel:(XYCommodityModel *)commodityModel {
    
    if ([dic count] > 0) {
        XYAddGoodsModel *model = [[XYAddGoodsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if (commodityModel) {
            if (model.updateKey.length && ![model.updateKey isEqualToString:@"EM_GIDList"]) {
                id value = [commodityModel valueForKey:model.updateKey.lowerHeadCaseString];
                if (value) {
                    model.updateValue = [NSString stringWithFormat:@"%@", value];
                }
            }
            id detail = [commodityModel valueForKey:model.modelKey.lowerHeadCaseString];
            if ([model.title isEqualToString:@"特价折扣"] || [model.title isEqualToString:@"最低折扣"]) {
                model.isWritable = commodityModel.pM_IsDiscount;
            }
            if ([model.title isEqualToString:@"固定积分"] && commodityModel.pM_IsPoint == 2) {
                model.isWritable = 1;
            }
            if ([model.title isEqualToString:@"商品库存"]) {
                model.isWritable = 0;
            }
            
            if (detail) {
                model.detail = [NSString stringWithFormat:@"%@", detail];
                if ([model.modelKey isEqualToString:@"PM_MemPrice"]) {
                    if ([detail floatValue]==0) {
                        model.detail=@"";
                    }
                }
                if ([model.modelKey isEqualToString:@"PM_IsDiscount"]) {
                    model.detail = @"";
                }
                if (model.selectList.count) {
                    model.detail = @"";
                    if ([model.modelKey isEqualToString:@"PM_IsPoint"] && commodityModel.pM_IsPoint) {
                        
                        model.detail = model.selectList[model.updateValue.integerValue-1];
                    }
                    
                    if ([model.modelKey isEqualToString:@"PM_SynType"]) {
                        model.isWritable = 0;
                        model.detail = model.selectList[model.updateValue.integerValue];
                    }
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
    for (NSArray *array in dataList) {
        for (XYAddGoodsModel *model in array) {
            if ([model.modelKey isEqualToString:@"PM_IsPoint"]&&([model.detail length]<1||[model.updateValue length]<1)) {
                [XYProgressHUD showMessage:@"请选择商品积分"];
                return nil;
            }
            if (!model.detail.length && !model.updateValue.length) {
                if (model.updateKey) {
                    [parameters setValue:@"" forKey:model.updateKey];
                } else {
                    [parameters setValue:@"" forKey:model.modelKey];
                }
                if (model.isRequired) {
                    [XYProgressHUD showMessage:@"带 ＊ 为必填"];
                    return nil;
                }
            } else {
                if (model.updateKey) {
                    [parameters setValue:model.updateValue forKey:model.updateKey];
                } else {
                    [parameters setValue:model.detail forKey:model.modelKey];
                }
            }
        }
    }
    return parameters;
}

@end
