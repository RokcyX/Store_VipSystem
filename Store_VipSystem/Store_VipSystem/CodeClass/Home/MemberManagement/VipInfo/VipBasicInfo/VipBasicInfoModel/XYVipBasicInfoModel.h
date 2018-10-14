//
//  XYVipBasicInfoModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMemberManageModel.h"
typedef enum : NSUInteger {
    RightViewTypeNull = 0,
    RightViewTypeSpace,
    RightViewTypeScan,
    RightViewTypeIndicator,
    RightViewTypeCalendar,
    RightViewTypeTextField,
} RightViewType;

@interface XYVipBasicInfoModel : NSObject
// 50
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *updateKey;
@property (nonatomic, copy)NSString *updateValue;
@property (nonatomic, assign)NSInteger keyboardType;
@property (nonatomic, assign)BOOL isRequired;
@property (nonatomic, assign)BOOL isWritable;
@property (nonatomic, assign)RightViewType rightViewType;


@property (nonatomic, copy)NSString *vCH_Fee_PayTypeText;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist memberModel:(XYMemberManageModel *)memberModel;
+ (NSMutableDictionary *)parametersWithDataList:(NSArray *)dataList;
@end
