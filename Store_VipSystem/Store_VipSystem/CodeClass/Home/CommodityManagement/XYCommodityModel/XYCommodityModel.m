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

// 设置 折扣金额
- (void)setOfferValue:(CGFloat)offerValue {
    self.discountStr = [NSString stringWithFormat:@"%.1f折", offerValue*10];
    self.discountPrice = self.pM_UnitPrice * offerValue;
    self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];
}

- (void)hasSpecialOfferValue {
    // 有特价折扣
    if (self.pM_MinDisCountValue && self.pM_MinDisCountValue < 1) {
        // 有最低折扣
        [self hasMinDisCountValueCompWithValue:self.pM_SpecialOfferValue];
    } else {
        self.offerValue = self.pM_SpecialOfferValue;
    }
    
}

- (void)hasMinDisCountValueCompWithValue:(CGFloat)value {
    // 有最低折扣
    if (value > self.pM_MinDisCountValue) { // 特价大于最低
        self.offerValue = value;
    } else { // 特价小于最低
        self.offerValue = self.pM_MinDisCountValue;
    }
}

- (void)discountWithOutMembership {
    if (self.pM_IsDiscount) { // 商品折扣开启
        if (self.pM_SpecialOfferValue && self.pM_SpecialOfferValue < 1) {
            // 有特价折扣
            [self hasSpecialOfferValue];
        } else {
            // 无特价折扣
            self.discountStr = @"不打折";
            self.discountPrice = self.pM_UnitPrice;
            self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];
        }
    } else {
        // 商品折扣关闭
        self.discountStr = @"不打折";
        self.discountPrice = self.pM_UnitPrice;
        self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];
    }
}

- (void)discountMembershipWithLevel:(CGFloat)level {
    if (self.pM_IsDiscount) { // 商品折扣开启
        if (self.pM_SpecialOfferValue && self.pM_SpecialOfferValue < 1) {
            // 有特价折扣
            [self hasSpecialOfferValue];
        } else { // 无特价折扣
            if (self.pM_MemPrice >= 0) { // 有会员价
                self.discountStr = @"会员折扣";
                self.discountPrice = self.pM_MemPrice;
                self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];
            } else {
                // 无会员价
                if (level && level < 1) {
                    // 等级折扣
                    if (self.pM_MinDisCountValue && self.pM_MinDisCountValue < 1) {
                        // 有最低折扣
                        [self hasMinDisCountValueCompWithValue:level];
                    } else {
                        // 无最低折扣
                        self.offerValue = level;
                    }
                } else {
                    // 无等级折扣 原价
                    self.discountStr = @"不打折";
                    self.discountPrice = self.pM_UnitPrice;
                    self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];

                }
            }
        }
    } else {
        // 商品折扣关闭
        if (self.pM_MemPrice >= 0) { // 有会员价
            self.discountStr = @"会员折扣";
            self.discountPrice = self.pM_MemPrice;
            self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];
        } else {
            self.discountStr = @"不打折";
            self.discountPrice = self.pM_UnitPrice;
            self.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.discountPrice*self.count];

        }
    
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
