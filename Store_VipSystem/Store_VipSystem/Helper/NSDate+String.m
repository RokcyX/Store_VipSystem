//
//  NSDate+String.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

- (NSString *)stringWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:self];
}

- (BOOL)dateBetweenDate:(NSDate*)beginDate endDate:(NSDate*)endDate
{
    if ([self compare:beginDate] ==NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] ==NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
