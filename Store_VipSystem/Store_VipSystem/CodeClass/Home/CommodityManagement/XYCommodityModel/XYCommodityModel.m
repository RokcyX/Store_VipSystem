//
//  XYCommodityModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCommodityModel.h"

@implementation XYCommodityModel

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist alldataList:(NSMutableArray *)datalist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        BOOL isAdd = false;
        for (XYCommodityModel *obj in datalist) {
            if ([obj.gID isEqualToString:dic[@"GID"]]) {
                [array addObject:obj];
                isAdd = YES;
            }
        }
        if (!isAdd) {
            XYCommodityModel *model = [self modelConfigureDic:dic];
            [datalist addObject:model];
            [array addObject:model];
        }
    }
    return array;
}

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in diclist) {
        [array addObject:[self modelConfigureDic:dic]];;
    }
    return array;
}

+ (instancetype)modelConfigureDic:(NSDictionary *)dic {
    if ([dic count] > 0) {
        XYCommodityModel *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.pM_Repertory = model.stock_Number;
        [model discountWithOutMembership];
        //        obj.pM_IsDiscount          商品折扣开关  1开 0关
        //        obj.pM_SpecialOfferValue   特价折扣开关的值
        //        obj.pM_MinDisCountValue    最低折扣开关的值
        //        obj.pM_MemPrice            会员价格
        return model;
    }
    return nil;
}

- (void)discountWithOutMembership {
    if (self.pM_IsDiscount) {
        if (self.pM_SpecialOfferValue && self.pM_SpecialOfferValue < 1) {// 有特价折扣
            if (self.pM_MinDisCountValue && self.pM_MinDisCountValue < 1) {// 有最低折扣
                if (self.pM_SpecialOfferValue > self.pM_MinDisCountValue) { // 特价大于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_SpecialOfferValue*10];
                    self.discountPrice = self.pM_UnitPrice * self.pM_SpecialOfferValue;
                } else { // 特价小于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_MinDisCountValue*10];
                    self.discountPrice = self.pM_UnitPrice * self.pM_MinDisCountValue;
                }
            } else { // 无最低折扣
                self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_SpecialOfferValue*10];
                self.discountPrice = self.pM_UnitPrice * self.pM_SpecialOfferValue;
            }
        } else {
            self.discountStr = @"不打折";
            self.discountPrice = self.pM_UnitPrice;
        }
    } else {
        self.discountStr = @"不打折";
        self.discountPrice = self.pM_UnitPrice;
    }
}

- (void)discountMembershipWithLevel:(CGFloat)level {
    if (self.pM_IsDiscount) {
        if (self.pM_SpecialOfferValue && self.pM_SpecialOfferValue < 1) {// 有特价折扣
            if (self.pM_MinDisCountValue && self.pM_MinDisCountValue < 1) {// 有最低折扣
                if (self.pM_SpecialOfferValue > self.pM_MinDisCountValue) { // 特价大于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_SpecialOfferValue*10];
                    self.discountPrice = self.pM_UnitPrice * self.pM_SpecialOfferValue;
                } else { // 特价小于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_MinDisCountValue*10];
                    self.discountPrice = self.pM_UnitPrice * self.pM_MinDisCountValue;
                }
            } else { // 无最低折扣
                self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_SpecialOfferValue*10];
                self.discountPrice = self.pM_UnitPrice * self.pM_SpecialOfferValue;
            }
        } else if (self.pM_MemPrice && self.pM_MemPrice < 1) {
            self.discountStr = @"会员折扣";
            self.discountPrice = self.pM_UnitPrice;
        } else if (level && level < 1) {
            if (self.pM_MinDisCountValue && self.pM_MinDisCountValue < 1) {// 有最低折扣
                if (level > self.pM_MinDisCountValue) { // 特价大于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", level*10];
                    self.discountPrice = self.pM_UnitPrice * level;
                } else { // 特价小于最低
                    self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_MinDisCountValue*10];
                    self.discountPrice = self.pM_UnitPrice * self.pM_MinDisCountValue;
                }
            } else { // 无最低折扣
                self.discountStr = [NSString stringWithFormat:@"%.1f折", self.pM_SpecialOfferValue*10];
                self.discountPrice = self.pM_UnitPrice * self.pM_SpecialOfferValue;
           
            }
            
        } else {
            self.discountStr = @"不打折";
            self.discountPrice = self.pM_UnitPrice;
        }
    } else {
        self.discountStr = @"不打折";
        self.discountPrice = self.pM_UnitPrice;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
