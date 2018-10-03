//
//  XYConfirmPayModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYConfirmPayModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *modelKey;
@property (nonatomic, copy)NSString *updateValue;
@property (nonatomic, copy)NSString *textColor;
@property (nonatomic, assign)NSInteger keyboardType;
@property (nonatomic, assign)BOOL rightMode;
@property (nonatomic, assign)BOOL isWritable;
@property (nonatomic , assign) BOOL enabled;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist priceString:(NSString *)priceString;

@end
