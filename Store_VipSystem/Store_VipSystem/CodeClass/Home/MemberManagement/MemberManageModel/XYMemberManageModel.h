//
//  XYMemberManageModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/7.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMemberManageModel : NSObject

@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , copy) NSString              * vIP_ICCard;
@property (nonatomic , assign) CGFloat              mA_AggregateAmount;
@property (nonatomic , assign) BOOL              vG_IsIntegral;
@property (nonatomic , copy) NSString              * vIP_Creator;
@property (nonatomic , copy) NSString              * vIP_Label;
@property (nonatomic , assign) NSInteger              vIP_IsForver;
@property (nonatomic , copy) NSString              * vIP_Remark;
@property (nonatomic , copy) NSString              * vIP_FaceNumber;
@property (nonatomic , copy) NSString              * mA_UpdateTime;
@property (nonatomic , copy) NSString              * vIP_OpenID;
@property (nonatomic , assign) NSInteger              vCH_Fee;
@property (nonatomic , copy) NSString              * eM_Name;
@property (nonatomic , assign) NSInteger              mCA_HowMany;
@property (nonatomic , assign) NSInteger              vIP_IsLunarCalendar;
@property (nonatomic , copy) NSString              * vIP_Birthday;
@property (nonatomic , assign) BOOL              vG_IsDiscount;
@property (nonatomic , copy) NSString              * messageVIP;
@property (nonatomic , copy) NSString              * vIP_HeadImg;
@property (nonatomic , assign) CGFloat              vS_Value;
@property (nonatomic , copy) NSString              * vCH_CreateTime;
@property (nonatomic , copy) NSString              * sM_GID;
@property (nonatomic , copy) NSString              * vG_Name;
@property (nonatomic , assign) BOOL              vG_IsAccount;
@property (nonatomic , assign) CGFloat              rS_Value;
@property (nonatomic , assign) CGFloat              mA_AggregateStoredValue;
@property (nonatomic , copy) NSString              * vIP_Overdue;
@property (nonatomic , copy) NSString              * eM_ID;
@property (nonatomic , copy) NSString              * vG_GID;
@property (nonatomic , copy) NSString              * vIP_Addr;
@property (nonatomic , assign) BOOL              vG_IsTime;
@property (nonatomic , assign) CGFloat              mA_AvailableIntegral;
@property (nonatomic , assign) NSInteger              vIP_RegSource;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * vIP_Name;
@property (nonatomic , assign) NSInteger              vIP_Sex;
@property (nonatomic , copy) NSString              * vGInfo;
@property (nonatomic , copy) NSString              * couponsList;
@property (nonatomic , copy) NSString              * vIP_CellPhone;
@property (nonatomic , copy) NSString              * vIP_Email;
@property (nonatomic , assign) CGFloat              mA_AvailableBalance;
@property (nonatomic , copy) NSString              * vCH_Card;
@property (nonatomic , copy) NSArray              * customeFieldList;
@property (nonatomic , copy) NSString              * vIP_FixedPhone;
@property (nonatomic , assign) BOOL              vG_IsCount;
@property (nonatomic , assign) NSInteger              mCA_TotalCharge;
@property (nonatomic , assign) CGFloat              dS_Value;
@property (nonatomic , assign) NSInteger              vIP_State;
@property (nonatomic , copy) NSString              * vIP_Referee;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, assign)BOOL isHaveVG;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist datalist:(NSArray *)datalist isSelected:(BOOL)isSelected;

@end
