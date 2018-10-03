//
//  NSDate+String.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

- (BOOL)dateBetweenDate:(NSDate*)beginDate endDate:(NSDate*)endDate;

- (NSString *)stringWithFormatter:(NSString *)formatter;

@end
