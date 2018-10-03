//
//  XYVipGradeModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/18.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings :NSObject
@property (nonatomic , copy) NSString              * pT_Type;
@property (nonatomic , copy) NSString              * vG_GID;
@property (nonatomic , copy) NSString              * sM_GID;
@property (nonatomic , copy) NSString              * pT_Name;
@property (nonatomic , assign) CGFloat              vS_Number;
@property (nonatomic , copy) NSString              * pT_SynType;
@property (nonatomic , copy) NSString              * vG_Name;
@property (nonatomic , assign) NSInteger              pD_Discount;
@property (nonatomic , copy) NSString              * pT_Parent;
@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , copy) NSString              * pT_GID;
@property (nonatomic , assign) CGFloat              vS_CMoney;

@end

@interface InitServiceList :NSObject
@property (nonatomic , copy) NSString              * vG_GID;
@property (nonatomic , assign) NSInteger              sR_Number;
@property (nonatomic , copy) NSString              * sG_Name;
@property (nonatomic , assign) NSInteger              sR_Timer;
@property (nonatomic , copy) NSString              * sR_UpdateTime;
@property (nonatomic , assign) NSInteger              sR_TimeUnit;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * sC_GD;

@end

@interface XYVipGradeModel : NSObject

@property (nonatomic , assign) NSInteger              vG_DiscountRuleType;
@property (nonatomic , copy) NSString              * vG_IsTimeUnit;
@property (nonatomic , copy) NSArray<Settings *>              * settings;
@property (nonatomic , assign) CGFloat              rS_Value;
@property (nonatomic , assign) CGFloat              vS_CMoney;
@property (nonatomic , assign) CGFloat              dS_Value;
@property (nonatomic , assign) NSInteger              vG_IsTimeTimes;
@property (nonatomic , assign) NSInteger              vG_IsDiscount;
@property (nonatomic , assign) CGFloat              vS_Value;
@property (nonatomic , assign) NSInteger              vG_IsIntegral;
@property (nonatomic , assign) NSInteger              vG_IsTimeNum;
@property (nonatomic , copy) NSString              * vG_Code;
@property (nonatomic , assign) NSInteger              vG_IntegralRuleType;
@property (nonatomic , assign) NSInteger              uS_Value;
@property (nonatomic , assign) CGFloat              vG_InitialIntegral;
@property (nonatomic , assign) NSInteger              vG_IsLock;
@property (nonatomic , assign) NSInteger              vG_IsAccount;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * vG_Name;
@property (nonatomic , assign) NSInteger              vG_IsCount;
@property (nonatomic , copy) NSString              * vG_Remark;
@property (nonatomic , assign) CGFloat              rS_CMoney;
@property (nonatomic , assign) CGFloat              vG_InitialAmount;
@property (nonatomic , copy) NSArray<InitServiceList *>              * InitServiceList;
@property (nonatomic , assign) NSInteger              vG_IsDownLock;
@property (nonatomic , assign) NSInteger              vG_IsTime;
@property (nonatomic , assign) NSInteger              vG_DiscountUniformRuleValue;
@property (nonatomic , copy) NSString              * uS_Code;
@property (nonatomic , assign) CGFloat              vG_IntegralUniformRuleValue;
@property (nonatomic , assign) CGFloat              vG_CardAmount;
@property (nonatomic , copy) NSString              * uS_Name;

@property (nonatomic , assign) BOOL             isSelected;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

@end
