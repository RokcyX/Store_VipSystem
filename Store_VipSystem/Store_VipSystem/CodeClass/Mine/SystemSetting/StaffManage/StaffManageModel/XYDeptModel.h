//
//  XYDeptModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYDeptModel : NSObject

@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * dM_Name;
@property (nonatomic , copy) NSString              * dM_UpdateTime;
@property (nonatomic , copy) NSString              * dM_Remark;
@property (nonatomic , copy) NSString              * dM_Creator;

@property (nonatomic , assign) BOOL             isSelected;

@property (nonatomic, strong)NSMutableArray *staffList;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

@end
