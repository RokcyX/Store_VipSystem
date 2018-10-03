//
//  NSString+Chinese.m
//  calculator
//
//  Created by 杨先豪 on 2017/6/24.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString (Chinese)

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString *)stringWithCode {
    NSDictionary *dic = @{@"HYCZ":@"会员充值小票",@"HYCC":@"会员充次小票",@"SPXF":@"商品消费小票",@"KSXF":@"快速消费小票",@"JCXF":@"计次消费小票",@"JFDH":@"积分兑换小票",@"SPTH":@"",@"JB":@"",@"FTXF":@"",@"HYDJ":@"",@"JSXF":@"",@"TCXF":@"套餐消费小票",@"HYKK":@"",      @"XJZF":@"现金支付",@"YEZF":@"余额支付",@"YLZF":@"银联支付",@"WXJZ":@"微信记账",@"ZFBJZ":@"支付宝记账"};
    if (dic[self]) {
        return dic[self];
    }
    return self;
}

- (NSString *)codeWithString {
    NSDictionary *dic = @{@"HYCZ":@"会员充值小票",@"HYCC":@"会员充次小票",@"SPXF":@"商品消费小票",@"KSXF":@"快速消费小票",@"JCXF":@"计次消费小票",@"JFDH":@"积分兑换小票",@"SPTH":@"",@"JB":@"",@"FTXF":@"",@"HYDJ":@"",@"JSXF":@"",@"TCXF":@"套餐消费小票",@"HYKK":@"",      @"XJZF":@"现金支付",@"YEZF":@"余额支付",@"YLZF":@"银联支付",@"WXJZ":@"微信记账",@"ZFBJZ":@"支付宝记账"};
    NSString *code = self;
    for (NSString *key in dic.allKeys) {
        if ([self isEqualToString:dic[@"key"]]) {
            code = key;
        }
    }
    return code;
}

- (NSString *)orderCode {
    NSString *dateString = [[NSDate date] stringWithFormatter:@"yyMMddHHmmss"];
    NSString *randString = @((random() % 9000) + 1000).stringValue;
    return [self stringByAppendingFormat:@"%@%@", dateString,randString];
}

- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}


- (NSString *)lowerHeadCaseString {
    NSString *headStr = [self substringToIndex:1];
    NSString *string = [self substringFromIndex:1];
    return [[headStr lowercaseString] stringByAppendingString:string];
}

- (NSString *)upperHeadCaseString {
    NSString *headStr = [self substringToIndex:1];
    NSString *string = [self substringFromIndex:1];
    return [[headStr uppercaseString] stringByAppendingString:string];
}

- (NSDate *)dateWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:self];
}

+ (NSString *)weekDayStringWithDate:(NSDate *)date {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * weekNumber = @([comps weekday]);
    NSInteger weekInt = [weekNumber integerValue];
    NSString *weekStr = @"7";
    if (weekInt-1) {
        weekStr = @(weekInt-1).stringValue;
    }
    // weekStr 1 是周一 7 是周日
    return weekStr;
}

+ (NSString *)dayStringWithDate:(NSDate *)date {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * dayNumber = @([comps day]);
    //    NSInteger weekInt = [weekNumber integerValue];
    return dayNumber.stringValue;
}

- (BOOL)trimming {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (string.length >0) {
        return NO;
        //        不是纯数字
    }else {
        if (self.length == 11) {
            return YES;
        } else {
            return NO;
        }
    }
}


+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

+ (NSString *)jsonStringFromDataString:(NSString *) responseString {
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return responseString;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)htmlStringToAttributedString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

@end
