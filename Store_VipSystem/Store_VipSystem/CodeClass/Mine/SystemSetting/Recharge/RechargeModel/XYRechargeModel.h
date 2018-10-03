//
//  XYRechargeModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRechargeModel : NSObject

@property (nonatomic , copy) NSString              * rP_ValidEndTime;
@property (nonatomic , assign) CGFloat              rP_RechargeMoney;
@property (nonatomic , copy) NSString              * rP_CreateTime;
@property (nonatomic , copy) NSString              * rP_ValidWeekMonth;
@property (nonatomic , copy) NSString              * rP_Remark;
@property (nonatomic , assign) NSInteger              rP_IsOpen;
@property (nonatomic , assign) NSInteger              rP_Type;
@property (nonatomic , assign) NSInteger              rP_ValidType;
@property (nonatomic , assign) CGFloat              rP_GiveMoney;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , assign) CGFloat              rP_Discount;
@property (nonatomic , copy) NSString              * rP_Name;
@property (nonatomic , assign) NSInteger              rP_GivePoint;
@property (nonatomic , assign) NSInteger              rP_ISDouble;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * rP_ValidStartTime;
@property (nonatomic , assign) CGFloat              rP_ReduceMoney;
@property (nonatomic , copy) NSString              * rP_Creator;
@property (nonatomic , assign) BOOL selected;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist type:(NSInteger)type ;


@end
