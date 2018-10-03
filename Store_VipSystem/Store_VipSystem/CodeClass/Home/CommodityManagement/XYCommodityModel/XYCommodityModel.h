//
//  XYCommodityModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCommodityModel : NSObject

@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , strong) NSArray              * customFields;
@property (nonatomic , copy) NSString              * pM_Description;
@property (nonatomic , copy) NSString              * fildsValue;
@property (nonatomic , assign) CGFloat              pM_StockPoliceValue;
@property (nonatomic , assign) NSInteger              pM_IsPoint;
@property (nonatomic , copy) NSString              * pT_ID;
@property (nonatomic , assign) CGFloat              pM_UnitPrice;
@property (nonatomic , assign) NSInteger              pM_IsService;
@property (nonatomic , copy) NSString              * pM_Modle;
@property (nonatomic , copy) NSString              * pM_IsServiceName;
@property (nonatomic , assign) CGFloat              stock_Number;
@property (nonatomic , copy) NSString              * pM_Code;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * pM_MemPrice;
@property (nonatomic , copy) NSString              * pT_Name;
@property (nonatomic , copy) NSString              * pM_SimpleCode;
@property (nonatomic , copy) NSString              * pM_BigImg;
@property (nonatomic , copy) NSString              * sP_Message;
@property (nonatomic , copy) NSString              * pM_Brand;
@property (nonatomic , assign) NSInteger              pM_DeleteSign;
@property (nonatomic , copy) NSString              * pM_UpdateTime;
@property (nonatomic , copy) NSString              * pM_SmallImg;
@property (nonatomic , copy) NSString              * sM_ID;
@property (nonatomic , assign) CGFloat              pM_PurchasePrice;
@property (nonatomic , copy) NSString              * pM_Creator;
@property (nonatomic , assign) CGFloat              pM_FixedIntegralValue;
@property (nonatomic , copy) NSString              * pM_Remark;
@property (nonatomic , copy) NSString              * pM_Name;
@property (nonatomic , assign) NSInteger              pM_SynType;
@property (nonatomic , copy) NSString              * fildsId;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , assign) CGFloat              pM_SpecialOfferValue;
@property (nonatomic , copy) NSString              * pM_Detail;
@property (nonatomic , copy) NSString              * pM_Metering;
@property (nonatomic , assign) CGFloat              pM_MinDisCountValue;
@property (nonatomic , assign) CGFloat              pM_Repertory;
@property (nonatomic , copy) NSString              * sP_GID;
@property (nonatomic , assign) NSInteger              pM_IsDiscount;

@property (nonatomic, assign)NSInteger count;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist alldataList:(NSMutableArray *)datalist;
@end
