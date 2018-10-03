//
//  LoginModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "LoginModel.h"


@implementation MenuInfo

+ (NSArray *)modelConfigureArray:(NSArray *)array {
    NSMutableArray *menuInfoList = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MenuInfo *model = [[MenuInfo alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [menuInfoList addObject:model];
    }
    
    return menuInfoList;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation ShopModel

+ (NSArray *)modelConfigureArray:(NSArray *)array {
    NSMutableArray *shopModelList = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        ShopModel *model = [[ShopModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [shopModelList addObject:model];
    }
    
    return shopModelList;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation LoginModel

+ (LoginModel *)shareLoginModel {
    static LoginModel *loginModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModel = [[LoginModel alloc] init];
    });
    
    return loginModel;
}

+ (void)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        [[self shareLoginModel] setValuesForKeysWithDictionary:dic];
        [[self shareLoginModel] loadPreloadedData];
        [[self shareLoginModel] loadShopInfo];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"MenuInfoList"]) {
        self.menuInfos = [MenuInfo modelConfigureArray:value];
    }
    if ([key isEqualToString:@"ShopList"]) {
        self.shopModels = [ShopModel modelConfigureArray:value];
        
    }
}

+ (BOOL)judgeAuthorityWithString:(NSString *)string {
    if ([LoginModel shareLoginModel].uM_IsAmin) {
        return YES;
    }
    for (MenuInfo *menuInfo in [LoginModel shareLoginModel].menuInfos) {
        if ([menuInfo.mM_Name isEqualToString:string]) {
            return YES;
        }
    }
    [XYProgressHUD showMessage:@"当前用户无此炒作权限"];
    return NO;
}

- (void)loadPreloadedData {
    //    api/Report/PreloadingData
    NSArray *array = Get_UserDefaults(ParameterSets);
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Report/PreloadingData" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.printSetModel = [XYPrintSetModel modelConfigureDic:dic[@"data"][@"PrintSet"]];
            weakSelf.parameterSets = [XYParameterSetModel modelConfigureWithArray:dic[@"data"][@"GetSysSwitchList"]];
            Set_UserDefaults([XYParameterSetModel parametersWithDataList:weakSelf.parameterSets], ParameterSets);
            // 暂时关闭 防止 刚添加的 活动 在可用的 界面没显示
//            weakSelf.rechargeValidList = [XYRechargeModel modelConfigureWithArray:dic[@"data"][@"Active"] type:1];
//            weakSelf.reducedValidList = [XYRechargeModel modelConfigureWithArray:dic[@"data"][@"Active"] type:2];
        } else {
            weakSelf.parameterSets = [XYParameterSetModel modelConfigureWithArray:array];
        }
        
    } failure:^(NSError *error) {
        weakSelf.parameterSets = [XYParameterSetModel modelConfigureWithArray:array];
    } showMsg:NO];
}

- (void)loadShopInfo  {
//    api/Shops/GetShopInfo
    WeakSelf;
    for (ShopModel *shopModel in self.shopModels) {
        if ([shopModel.gID isEqualToString:self.shopID]) {
            self.shopModel = shopModel;
        }
    }
    [AFNetworkManager postNetworkWithUrl:@"api/Shops/GetShopInfo" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            if (!weakSelf.shopModel) {
                weakSelf.shopModel = [[ShopModel alloc] init];
            }
            [weakSelf.shopModel setValuesForKeysWithDictionary:dic[@"data"]];
        }
        
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}


@end
