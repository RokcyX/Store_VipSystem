//
//  LoginModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYParameterSetModel.h"
#import "XYPrintSetModel.h"
#import "XYRechargeModel.h"
@interface MenuInfo :NSObject
@property (nonatomic , copy) NSString              * mM_LinkUrl;
@property (nonatomic , copy) NSString              * mM_Creator;
@property (nonatomic , assign) NSInteger              mM_Sort;
@property (nonatomic , copy) NSString              * mM_Name;
@property (nonatomic , copy) NSString              * mM_ParentID;
@property (nonatomic , copy) NSString              * mM_Icon;
@property (nonatomic , copy) NSString              * mM_PictureAddr;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * mM_Remark;
@property (nonatomic , copy) NSString              * mM_CreateTime;

@end

@interface ShopModel :NSObject
@property (nonatomic , assign) NSInteger              sM_State;
@property (nonatomic , copy) NSString              * sM_Addr;
@property (nonatomic , copy) NSString              * sM_XLong;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * sM_Phone;
@property (nonatomic , copy) NSString              * sM_Province;
@property (nonatomic , assign) NSInteger              sM_Type;
@property (nonatomic , assign) NSInteger              proNumber;
@property (nonatomic , copy) NSString              * sM_YLat;
@property (nonatomic , copy) NSString              * sM_Contacter;
@property (nonatomic , copy) NSString              * sM_Picture;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * sM_Creator;
@property (nonatomic , copy) NSString              * sM_Country;
@property (nonatomic , copy) NSString              * sM_MapAddr;
@property (nonatomic , copy) NSString              * sM_DetailAddr;
@property (nonatomic , copy) NSString              * sM_Range;
@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , assign) NSInteger              sM_AcountNum;
@property (nonatomic , copy) NSString              * sM_EndTime;
@property (nonatomic , copy) NSString              * sM_UpdateTime;
@property (nonatomic , copy) NSString              * sM_Remark;
@property (nonatomic , copy) NSString              * sM_Industry;
@property (nonatomic , copy) NSString              * sM_CreateTime;
@property (nonatomic , assign) NSInteger              vipNumber;
@property (nonatomic , assign) NSInteger              sM_UpdateState;
@property (nonatomic , copy) NSString              * sM_DefaultCode;
@property (nonatomic , copy) NSString              * sM_City;
@property (nonatomic , copy) NSString              * sM_Disctrict;


@property (nonatomic , copy) NSString              *ShopImg;
@property (nonatomic , copy) NSString              *ShopName;
@property (nonatomic , copy) NSString              *ShopContact;
@property (nonatomic , copy) NSString              *ShopTel;
@property (nonatomic , copy) NSString              *ShopType;
@property (nonatomic , copy) NSString              *ShopMbers;
@property (nonatomic , copy) NSString              *ShopGoods;
@property (nonatomic , copy) NSString              *ShopUsers;
@property (nonatomic , copy) NSString              *ShopOverTime;
@property (nonatomic , copy) NSString              *ShopCreateTime;

+ (NSArray *)modelConfigureArray:(NSArray *)array;

@end

@interface ComSmsStock : NSObject
@property (nonatomic , assign) NSInteger UStorage;
@end

@interface LoginModel : NSObject

@property (nonatomic , copy) NSString              * uM_Creator;
@property (nonatomic , copy) NSString              * uM_ThirdPartyOpenID;
@property (nonatomic , copy) NSString              * aG_GID;
@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , copy) NSString              * menuResourceList;
@property (nonatomic , strong) NSArray<MenuInfo *>              * menuInfos;
@property (nonatomic , copy) NSString              * uM_RegSource;
@property (nonatomic , copy) NSString              * uM_UpdateState;
@property (nonatomic , copy) NSString              * eM_Name;
@property (nonatomic , copy) NSString              * uM_Name;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * merchant_No;
@property (nonatomic , copy) NSString              * uM_Acount;
@property (nonatomic , copy) NSString              * uM_RegSourceParam;
@property (nonatomic , copy) NSString              * termina_Token;
@property (nonatomic , assign) NSInteger              uM_IsLock;
@property (nonatomic , copy) NSString              * uM_CreateTime;
@property (nonatomic , copy) NSString              * uM_Unionid;
@property (nonatomic , copy) NSString              * shopID;
@property (nonatomic , copy) NSString              * uM_Remark;
@property (nonatomic , copy) NSString              * uM_Pwd;
@property (nonatomic , copy) NSString              * uM_Right;
@property (nonatomic , assign) NSInteger              uM_IsAmin;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * uM_RegIP;
@property (nonatomic , copy) NSString              * uM_IP;
@property (nonatomic , copy) NSString              * roleName;
@property (nonatomic , copy) NSString              * uM_Contact;
@property (nonatomic , copy) NSString              * eM_GID;
@property (nonatomic , strong) ShopModel *shopModel;
@property (nonatomic , strong) NSArray<ShopModel *>              * shopModels;
@property (nonatomic , copy) NSString              * uM_OpenID;
@property (nonatomic , copy) NSString              * termina_ID;
@property (nonatomic , copy) NSString              * uM_UpdateTime;
@property (nonatomic , copy) NSString              * uM_LoginTime;
@property (nonatomic , copy) NSString              * roleID;
@property (nonatomic , copy) NSString              * rM_Name;

@property (nonatomic, strong)ComSmsStock *smsStock;
@property (nonatomic, strong)XYPrintSetModel *printSetModel;
@property (nonatomic, strong)NSArray<NSDictionary *> *parameterSets;

@property (nonatomic, strong)NSArray *rechargeValidList;//可用充值
@property (nonatomic, strong)NSArray *reducedValidList;// 可用优惠



+ (LoginModel *)shareLoginModel;
+ (void)modelConfigureDic:(NSDictionary *)dic;

+ (BOOL)judgeAuthorityWithString:(NSString *)string;

@end

