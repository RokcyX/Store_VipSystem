//
//  XYParameterSetModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYParameterSetModel : NSObject

@property (nonatomic , copy) NSString              * sS_Update;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * sS_Name;
@property (nonatomic , copy) NSString              * sS_Remark;
@property (nonatomic , assign) NSInteger              sS_State;
@property (nonatomic , copy) NSString              * sS_Code;
@property (nonatomic , copy) NSString              * sS_UpdateTime;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , assign) NSInteger              sS_Sort;
@property (nonatomic , copy) NSString              * sS_Value;


@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *placeholder;
@property (nonatomic , assign) BOOL hasValue;
@property (nonatomic , assign) NSInteger rightMode;
@property (nonatomic, assign)NSInteger keyboardType;
@property (nonatomic , assign) BOOL enabled;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

+ (NSArray *)parametersWithDataList:(NSArray *)dataList;

@end
