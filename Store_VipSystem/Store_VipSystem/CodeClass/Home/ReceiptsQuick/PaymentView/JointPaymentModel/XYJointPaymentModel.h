//
//  XYJointPaymentModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/23.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJointPaymentModel : NSObject

@property (nonatomic, copy)NSString *iconImage;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, assign)NSInteger selectEnable;
@property (nonatomic, assign)BOOL readonly;
+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist priceString:(NSString *)priceString;

@end
