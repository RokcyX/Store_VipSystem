//
//  WSDatePickerView.h
//  WSDatePicker
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Extension.h"

/**
 *  弹出日期类型
 */
typedef enum{
    DateStyleShowYearMonthDayHourMinuteSecond = 0,//年月日时分秒
    DateStyleShowYearMonthDayHourMinute,//年月日时分
    DateStyleShowMonthDayHourMinute,//月日时分
    DateStyleShowYearMonthDay,//年月日
    DateStyleShowMonthDay,//月日
    DateStyleShowHourMinute//时分
}WSDateStyle;


@interface WSDatePickerView : UIView


@property (nonatomic, retain) NSDate *scrollToDate;//滚到指定日期

/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic,strong)UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic,strong)UIColor *datePickerColor;

/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/**
 默认滚动到当前时间
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock;

/**
 滚动到指定的的日期
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock;

@end

