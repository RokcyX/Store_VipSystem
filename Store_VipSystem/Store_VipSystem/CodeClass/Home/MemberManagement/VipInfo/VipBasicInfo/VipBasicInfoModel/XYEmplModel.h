//
//  XYEmplModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYEmplModel : NSObject

@property (nonatomic , copy) NSString              * eM_Name;
@property (nonatomic , copy) NSString              * eM_Birthday;
@property (nonatomic , assign) NSInteger             eM_TipGoodsConsume;
@property (nonatomic , copy) NSString              * eM_Remark;
@property (nonatomic , copy) NSString              * sM_GID;
@property (nonatomic , copy) NSString              * dM_Name;
@property (nonatomic , assign) NSInteger            eM_Sex;
@property (nonatomic , copy) NSString              * eM_Phone;
@property (nonatomic , assign) NSInteger             eM_TipComboConsume;
@property (nonatomic , copy) NSString              * eM_Addr;
@property (nonatomic , copy) NSString              * eM_UpdateTime;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , assign) NSInteger             eM_TipChargeTime;
@property (nonatomic , assign) NSInteger             eM_TipFastConsume;
@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , assign) NSInteger            eM_TipCard;
@property (nonatomic , copy) NSString              * eM_Creator;
@property (nonatomic , copy) NSString              * dM_GID;
@property (nonatomic , assign) NSInteger             eM_TipRecharge;
@property (nonatomic , assign) NSInteger             eM_TipTimesConsume;
@property (nonatomic , copy) NSString              * eM_Code;

@property (nonatomic , copy) NSString              * cY_GID;

@property (nonatomic , assign) BOOL             isSelected;
+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;
@end
