//
//  XYRechargeEditModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYRechargeModel.h"
@interface XYValidTimeModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *endModelKey;
@property (nonatomic, copy)NSString *endDetail;
@property (nonatomic , assign)NSInteger rP_ValidType;
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, assign)NSInteger rightType;

@end

@interface XYRechargeEditModel : NSObject

// 50
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *updateKey;
@property (nonatomic, copy)NSString *updateValue;
@property (nonatomic, assign)NSInteger keyboardType;
@property (nonatomic, strong)NSArray *selectList;

@property (nonatomic, copy)NSString *seletTitle;
@property (nonatomic, strong)NSArray *seletDatas;

@property (nonatomic, assign)BOOL isRequired;
@property (nonatomic, assign)BOOL isWritable;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist rechargeModel:(XYRechargeModel *)rechargeModel;

+ (NSMutableDictionary *)parametersWithDataList:(NSArray *)dataList;

+ (instancetype)modelConfigureDic:(NSDictionary *)dic rechargeModel:(XYRechargeModel *)rechargeModel;

@end
