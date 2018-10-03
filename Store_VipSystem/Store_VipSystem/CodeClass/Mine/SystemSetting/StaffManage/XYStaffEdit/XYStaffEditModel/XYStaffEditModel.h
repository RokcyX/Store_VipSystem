//
//  XYStaffEditModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYEmplModel.h"
typedef enum : NSUInteger {
    RightViewTypeNull = 0,
    RightViewTypeIndicator,
    RightViewTypeCalendar
} RightViewType;

@interface XYStaffEditModel : NSObject

// 50
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *updateKey;
@property (nonatomic, copy)NSString *updateValue;
@property (nonatomic, assign)NSInteger keyboardType;
@property (nonatomic, strong)NSArray *selectList;
@property (nonatomic, assign)BOOL isRequired;
@property (nonatomic, assign)BOOL isWritable;
@property (nonatomic, assign)RightViewType rightViewType;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist emplModel:(XYEmplModel *)emplModel;
+ (NSMutableDictionary *)parametersWithDataList:(NSArray *)dataList;

@end
