//
//  XYPrinterMaker.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/28.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYPrintHeader : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *order;

@end

@interface XYPrinterMaker : NSObject

@property (nonatomic, assign)BOOL isPrint;

@property (nonatomic, strong)XYPrintHeader *header;
@property (nonatomic, strong)NSMutableArray *bodylist;
@property (nonatomic, strong)NSMutableArray *paymentlist;

+ (instancetype)sharedMaker;

- (NSData *)printerValueKeys;
// 用完销毁
+ (void)destroy;

+ (void)print;

@end
