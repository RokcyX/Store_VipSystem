//
//  UIColor+Hex.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


+ (UIColor *)colorWithHex:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;

@end
