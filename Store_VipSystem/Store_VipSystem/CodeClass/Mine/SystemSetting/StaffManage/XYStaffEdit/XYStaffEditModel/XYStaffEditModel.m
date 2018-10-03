//
//  XYStaffEditModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYStaffEditModel.h"

@implementation XYStaffEditModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist emplModel:(XYEmplModel *)emplModel {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic emplModel:emplModel]];;
    }
    
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic emplModel:(XYEmplModel *)emplModel {
    
    if ([dic count] > 0) {
        XYStaffEditModel *model = [[XYStaffEditModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if (emplModel) {
            if (model.updateKey.length) {
                id value = [emplModel valueForKey:model.updateKey.lowerHeadCaseString];
                if (value) {
                    model.updateValue = [NSString stringWithFormat:@"%@", value];
                }
            }
            id detail = [emplModel valueForKey:model.modelKey.lowerHeadCaseString];
            if (detail) {
                model.detail = [NSString stringWithFormat:@"%@", detail];;
                if ([model.modelKey isEqualToString:@"EM_Sex"]) {
                    model.detail = [detail integerValue] == 0 ? @"男" : @"女";
                }
            }
        } else {
            if ([model.title isEqualToString:@"所属店铺"]) {
                model.updateValue = [LoginModel shareLoginModel].shopModel.gID;
                model.detail = [LoginModel shareLoginModel].shopModel.sM_Name;
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
    for (XYStaffEditModel *model in dataList) {
        if (!model.detail.length && !model.updateValue.length) {
            if (model.isRequired) {
                [XYProgressHUD showMessage:@"带 ＊ 为必填"];
                return nil;
            }
        } else {
            if (model.updateKey) {
                if (model.updateKey.length > 0 && model.updateValue.length > 0) {
                    [parameters setValue:model.updateValue forKey:model.updateKey];
                }
            } else {
                [parameters setValue:model.detail forKey:model.modelKey];
            }
        }
    }
    return parameters;
}

@end

/*
 
 add 参数Code
 SM_GID    店铺GID    string    是    0-100
 DM_GID    部门GID    string    是    0-100
 EM_Code    员工编号    string    是    0-100
 EM_Name    员工姓名    string    否    0-100
 EM_Sex    员工性别    Int16    否    0-2
 EM_Phone    电话号码    string    是    0-11
 EM_Addr    员工地址    string    是    0-100
 EM_Remark    备注    string    是    0-500
 EM_Birthday    员工生日    DateTime?    是    0-20
 
 EM_TipCard    售卡提成    int    否    0-2
 EM_TipRecharge    充值提成    int    否    0-2
 EM_TipChargeTime    充次提成    int    否    0-2
 EM_TipGoodsConsume    商品消费提成    int    否    0-2
 EM_TipFastConsume    快速消费提成    int    否    0-2
 EM_TipTimesConsume    签到提成    int    否    0-2
 EM_TipComboConsume    套餐消费提成    int    否    0-2
 ["不归属任何店铺", "高级店铺", "默认店铺", "其他店铺"]

 */
