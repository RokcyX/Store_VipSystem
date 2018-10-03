//
//  NSString+Chinese.h
//  calculator
//
//  Created by 杨先豪 on 2017/6/24.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Chinese)

- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字

- (NSString *)stringWithCode;

- (NSString *)orderCode;

- (NSString *)lowerHeadCaseString;

- (NSString *)upperHeadCaseString;

+ (NSString *)weekDayStringWithDate:(NSDate *)date;

+ (NSString *)dayStringWithDate:(NSDate *)date;

- (NSDate *)dateWithFormatter:(NSString *)formatter;

- (BOOL)trimming;

- (NSString *)codeWithString;

- (NSString *)transformToPinyin;

+ (NSString *)htmlEntityDecode:(NSString *)string;
+ (NSString *)jsonStringFromDataString:(NSString *) responseString;
//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)htmlStringToAttributedString;

@end
