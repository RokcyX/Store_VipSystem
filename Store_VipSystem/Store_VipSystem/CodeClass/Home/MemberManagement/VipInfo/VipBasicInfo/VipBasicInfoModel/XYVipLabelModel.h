//
//  XYVipLabelModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYVipLabelModel : NSObject

@property (nonatomic , copy) NSString              * mL_GID;
@property (nonatomic , copy) NSString              * mL_StoreID;
@property (nonatomic , copy) NSString              * mL_ColorValue;
@property (nonatomic , copy) NSString              * mL_CreateUser;
@property (nonatomic , copy) NSString              * mL_Remark;
@property (nonatomic , assign) NSInteger              mL_Type;
@property (nonatomic , copy) NSString              * lable_ID;
@property (nonatomic , copy) NSString              * mL_Name;
@property (nonatomic , copy) NSString              * mL_CYGID;
@property (nonatomic , copy) NSString              * mL_CreateTime;

@property (nonatomic, assign)BOOL isSelected;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist vIP_Label:(NSString *)vIP_Label;
- (void)defaultVIP_Label:(NSString *)vIP_Label;
@end
