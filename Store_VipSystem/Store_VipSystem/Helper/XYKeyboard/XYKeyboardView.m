//
//  XYKeyboardView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYKeyboardView.h"
#import "WSDatePickerView.h"

@interface XYKeyboardView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak)UIDatePicker *datePicker;
@property (nonatomic, weak)UIPickerView *stringPicker;
@property (nonatomic, weak)WSDatePickerView *dateView;
@end

@implementation XYKeyboardView

+(XYKeyboardView *)keyBoardWithType:(KeyboardType)keyboardType {
    return [[XYKeyboardView alloc] initWithType:keyboardType];
}


+ (XYKeyboardView *)keyBoardWithCount:(NSInteger)count {
    return [[XYKeyboardView alloc] initWithCount:count];
}

- (instancetype)initWithType:(KeyboardType)keyboardType
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, 214);
        self.keyboardType = keyboardType;
        [self buildSubViews];
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        self.count = count;
        self.frame = CGRectMake(0, 0, ScreenWidth, (count /7 +  (count % 7 ? 1:0)) * 56);
        self.keyboardType = KeyboardTypeDaysNumber;
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    WeakSelf;
    if (self.keyboardType == KeyboardTypeDatePicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [self addSubview:self.datePicker=datePicker];
        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
    } else if (self.keyboardType == KeyboardTypeStringPicker) {
        UIPickerView *stringPicker = [[UIPickerView alloc] init];
        [self addSubview:self.stringPicker = stringPicker];
        stringPicker.dataSource = self;
        stringPicker.delegate = self;
        [stringPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
    } else if (self.keyboardType == KeyboardTypeDaysNumber) {
        for (int i = 0; i < self.count; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.tag = 101 + i;
            [button addTarget:self action:@selector(labelSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.titleLabel.numberOfLines = 0;
            button.frame = CGRectMake(10 + ((ScreenWidth - 80)/7 + 10)*(i%7), 10 + 56 * (i/7), (ScreenWidth - 80)/7, 36);
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:RGBColor(249, 104, 62) forState:(UIControlStateSelected)];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor clearColor].CGColor;
            [self addSubview:button];
            [button setTitle:@(i+1).stringValue forState:(UIControlStateNormal)];
        }
    } else if (self.keyboardType == KeyboardTypetime) {
        WSDatePickerView *dateView = [[WSDatePickerView alloc] initWithDateStyle:(DateStyleShowYearMonthDayHourMinuteSecond) CompleteBlock:^(NSDate *date) {
            weakSelf.string = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        }];
        [self addSubview:self.dateView=dateView];
        [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
    }
}

- (void)labelSelectAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    if (btn.selected) {
        btn.layer.borderColor = RGBColor(249, 104, 62).CGColor;
    }
}

- (void)setSeletedNum:(NSString *)seletedNum {
    self.string = _seletedNum = seletedNum;
    if (self.keyboardType == KeyboardTypeStringPicker) {
        for (int i = 0; i < self.count; i++) {
            if (self.titleForRow) {
                NSString *title = self.titleForRow(i);
                if ([title isEqualToString:self.string]) {
                    [self.stringPicker selectRow:i inComponent:0 animated:YES];
                }
            }
        }
    } else if (self.keyboardType == KeyboardTypeDaysNumber) {
        if (seletedNum.length) {
            NSArray *array = [seletedNum componentsSeparatedByString:@","];
            for (NSString *num in array) {
                UIButton *button = [self viewWithTag:num.integerValue + 100];
                button.selected = YES;
                button.layer.borderColor = RGBColor(249, 104, 62).CGColor;
            }
        }
    } else if (self.keyboardType == KeyboardTypetime) {
        self.dateView.scrollToDate = [seletedNum dateWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (NSString *)string {
    if (self.keyboardType == KeyboardTypeDatePicker) {
        return [[self.datePicker date] stringWithFormatter:@"yyyy-MM-dd"];
    } else if (self.keyboardType == KeyboardTypeDaysNumber) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i <= self.count; i++) {
            UIButton *button = [self viewWithTag:100+i];
            if (button.selected) {
                [array addObject:@(i).stringValue];
            }
        }
        _string = [array componentsJoinedByString:@","];
        
    }
    return _string;
}

- (void)setCount:(NSInteger)count {
    _count = count;
}

#pragma mark pickerView dataSource delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.titleForRow) {
        NSString *title = self.titleForRow(row);
        if (!self.seletedNum) {
            if (component == 0 && row == 0) {
                self.string = title;
            }
        }
        return  title;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.titleForRow) {
       self.string = self.titleForRow(row);
    } else {
        self.string = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
