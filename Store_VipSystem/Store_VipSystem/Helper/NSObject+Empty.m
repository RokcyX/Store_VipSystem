//
//  NSObject+Empty.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/24.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "NSObject+Empty.h"

@implementation NSObject (Empty)

//在需要判断空值的类目中添加
- (BOOL)isEmpty {
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([self isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (self == nil){
        return YES;
    }
    return NO;
}

@end
