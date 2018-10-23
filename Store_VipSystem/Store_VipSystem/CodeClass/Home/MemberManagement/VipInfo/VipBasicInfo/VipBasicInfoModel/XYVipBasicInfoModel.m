//
//  XYVipBasicInfoModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipBasicInfoModel.h"

@implementation XYVipBasicInfoModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist memberModel:(XYMemberManageModel *)memberModel {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic memberModel:memberModel]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic  memberModel:(XYMemberManageModel *)memberModel {
    
    if ([dic count] > 0) {
        XYVipBasicInfoModel *model = [[XYVipBasicInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if (memberModel) {
            if (model.rightViewType == 5) {
                model.rightViewType = 0;
            }
            if (model.updateKey.length && ![model.updateKey isEqualToString:@"EM_GIDList"]) {
                id value = [memberModel valueForKey:model.updateKey.lowerHeadCaseString];
                if (value) {
                    model.updateValue = [NSString stringWithFormat:@"%@", value];
                }
            }
            id detail = [memberModel valueForKey:model.modelKey.lowerHeadCaseString];
            if (detail) {
                model.detail = [NSString stringWithFormat:@"%@", detail];;
                if ([model.modelKey isEqualToString:@"VIP_Sex"]) {
                    model.detail = [detail integerValue] == 0 ? @"男" : [detail integerValue] == 1 ? @"女" : @"保密";
                }
            }
            if ([model.modelKey isEqualToString:@"VIP_Overdue"] && !model.detail.length) {
                model.detail = @"永久有效";
            }
        }
        
        if ([model.title isEqualToString:@"会员手机"]) {
            for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets[1][@"models"]) {
                if (obj.sS_Code.integerValue == 211) {
                    model.isRequired = obj.sS_State;
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
        for (XYVipBasicInfoModel *model in array) {
            if (model.vCH_Fee_PayTypeText.length) {
                [parameters setValue:model.vCH_Fee_PayTypeText.codeWithString forKey:@"VCH_Fee_PayType"];
                [parameters setValue:model.vCH_Fee_PayTypeText forKey:@"VCH_Fee_PayTypeText"];
            }
            if ([model.modelKey isEqualToString:@"VCH_Fee"]) {
                
                if (model.detail.floatValue && !model.vCH_Fee_PayTypeText.length) {
                    [XYProgressHUD showMessage:@"请选择支付方式"];
                    return nil;
                }
            }
            if ([model.modelKey isEqualToString:@"VIP_Overdue"]) {
                NSString *value = model.detail.integerValue ? @"0":@"1";
                [parameters setValue:value forKey:@"VIP_IsForver"];
            }
            
            if ([model.modelKey isEqualToString:@"VIP_CellPhone"]) {
                [parameters setValue:@"" forKey:@"VIP_CellPhone"];

                if (!model.detail.trimming && model.isRequired) {
                    [XYProgressHUD showMessage:@"手机号格式不对"];
                    return nil;
                }
            }
//            NSString *key = model.modelKey;
//            if (model.updateKey.length) {
//                key = model.updateKey;
//            }
//            [parameters setValue:@"" forKey:key];
            
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
    }
    
    return parameters;
}

@end



/*
 "updateKey":"VIP_Remark",
 "updateValue":"",
 
 VIP_Addr        会员地址    String        是    0-100
 VG_GID        等级GID    String        否    0-100
 VIP_Name        会员姓名    String        否    0-50
 VIP_CellPhone        手机号    String        否    0-11
 VIP_Birthday        生日    DateTime?        是    0-20
 VIP_Email        电子邮箱    String        是    0-50
 EM_GIDList        提成员工    List<string>        是    0-1000
 VIP_Overdue        过期时间    DateTime?        是    0-50
 VIP_IsForver        是否永久    Int        是    1-1        永久有效0否1是
 VIP_Sex        会员性别    Int        是    1-1        0男，1女，2保密
 VIP_Referee        推荐人卡号    String        是    0-50
 VIP_FaceNumber        卡面卡号    String        是    0-50
 VCH_Card        会员卡号    String        否    0-50
 VIP_Remark        备注    String        是    0-200
 VCH_Fee        会员卡费    Int        是    0-10
 
 VIP_HeadImg        会员照片    String        是    0-100
 VIP_Label        会员标签    String        是    0-500
 GID        会员GID    String        否    0-100
 
 
 VCH_Pwd        密码    String        是    0-20
 IS_Sms        是否发送短信    Bool        是    0-500
 VIP_FixedPhone        固定电话    String        是    0-10
 VT_Code        会员类型ID    String        是    0-100
 VIP_Percent        提成比例    Int32        是    0-100
 FildsId        自定义属性ID    String[]        是    0-200
 FildsValue        自定义属性值    String[]        是    0-200
 VIP_State        会员状态    Int        是    0-100
 VIP_IsLunarCalendar        是否农历    Int        是    1-1        是否农历：0:否,1:是
 */
