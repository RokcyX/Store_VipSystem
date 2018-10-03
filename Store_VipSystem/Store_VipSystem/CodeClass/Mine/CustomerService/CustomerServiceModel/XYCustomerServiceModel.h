//
//  XYCustomerServiceModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCustomerServiceModel : NSObject

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;

+ (NSArray *)modelConfigureDic:(NSDictionary *)dic;

@end
