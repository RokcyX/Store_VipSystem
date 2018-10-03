//
//  XYEM_TipModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYEM_TipModel.h"

@implementation XYEM_TipModel



+ (NSArray *)eM_TipModelWithEmplModel:(XYEmplModel *)empl {
    NSArray *diclist = @[
                          @{@"EM_TipCard":@"售卡提成"},
                          @{@"EM_TipRecharge":@"充值提成"},
                          @{@"EM_TipChargeTime":@"充次提成"},
                          @{@"EM_TipGoodsConsume":@"商品消费提成"},
                          @{@"EM_TipFastConsume":@"快速消费提成"},
                          @{@"EM_TipTimesConsume":@"签到提成"} ,
                          @{@"EM_TipComboConsume":@"套餐消费提成"}
                          ];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in diclist) {
        XYEM_TipModel *model = [[XYEM_TipModel alloc] init];
        model.title = dic[dic.allKeys.firstObject];
        model.updateKey = dic.allKeys.firstObject;
        model.isSelected = [[empl valueForKey:[dic.allKeys.firstObject lowerHeadCaseString]] boolValue];
        [array addObject:model];
    }
    
    return array;
}

@end
