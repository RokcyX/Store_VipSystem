//
//  XYAmountInputView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAmountInputView.h"

@interface XYAmountInputView ()

@property (nonatomic, weak) UIButton *delButton;
@property (nonatomic, weak) UIButton *equalButton;
@property (nonatomic, weak) UIButton *pointButton;
@property (nonatomic, weak) UIButton *zeroButton;
@property (nonatomic, weak) UIButton *oneButton;
@property (nonatomic, weak) UIButton *twoButton;
@property (nonatomic, weak) UIButton *threeButton;
@property (nonatomic, weak) UIButton *fourButton;
@property (nonatomic, weak) UIButton *fiveButton;
@property (nonatomic, weak) UIButton *sixButton;
@property (nonatomic, weak) UIButton *sevenButton;
@property (nonatomic, weak) UIButton *eightButton;
@property (nonatomic, weak) UIButton *nineButton;

@end

@implementation XYAmountInputView

- (UIButton *)buttonWithName:(NSString *)name action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:name forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:26];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

- (UIButton *)delButton {
    if (!_delButton) {
        [self addSubview:self.delButton = [self buttonWithName:@"" action:@selector(del)]];
        [self.delButton setImage:[UIImage imageNamed:@"receiptsQuick_num_del"] forState:(UIControlStateNormal)];
    }
    return _delButton;
}

- (UIButton *)equalButton {
    if (!_equalButton) {
        [self addSubview:self.equalButton = [self buttonWithName:@"确定" action:@selector(equal)]];
        self.equalButton.backgroundColor = RGBColor(252, 105, 67);
        [self.equalButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _equalButton;
}

- (UIButton *)pointButton {
    if (!_pointButton) {
        [self addSubview:self.pointButton = [self buttonWithName:@"." action:@selector(numberTouched:)]];
    }
    return _pointButton;
}

- (UIButton *)zeroButton {
    if (!_zeroButton) {
        [self addSubview:self.zeroButton = [self buttonWithName:@"0" action:@selector(numberTouched:)]];
    }
    return _zeroButton;
}

- (UIButton *)oneButton {
    if (!_oneButton) {
        [self addSubview:self.oneButton = [self buttonWithName:@"1" action:@selector(numberTouched:)]];
    }
    return _oneButton;
}

- (UIButton *)twoButton {
    if (!_twoButton) {
        [self addSubview:self.twoButton = [self buttonWithName:@"2" action:@selector(numberTouched:)]];
    }
    return _twoButton;
}

- (UIButton *)threeButton {
    if (!_threeButton) {
        [self addSubview:self.threeButton = [self buttonWithName:@"3" action:@selector(numberTouched:)]];
    }
    return _threeButton;
}


- (UIButton *)fourButton {
    if (!_fourButton) {
        [self addSubview:self.fourButton = [self buttonWithName:@"4" action:@selector(numberTouched:)]];
    }
    return _fourButton;
}

- (UIButton *)fiveButton {
    if (!_fiveButton) {
        [self addSubview:self.fiveButton = [self buttonWithName:@"5" action:@selector(numberTouched:)]];
    }
    return _fiveButton;
}

- (UIButton *)sixButton {
    if (!_sixButton) {
        [self addSubview:self.sixButton = [self buttonWithName:@"6" action:@selector(numberTouched:)]];
    }
    return _sixButton;
}

- (UIButton *)sevenButton {
    if (!_sevenButton) {
        [self addSubview:self.sevenButton = [self buttonWithName:@"7" action:@selector(numberTouched:)]];
    }
    return _sevenButton;
}

- (UIButton *)eightButton {
    if (!_eightButton) {
        [self addSubview:self.eightButton = [self buttonWithName:@"8" action:@selector(numberTouched:)]];
    }
    return _eightButton;
}

- (UIButton *)nineButton {
    if (!_nineButton) {
        [self addSubview:self.nineButton = [self buttonWithName:@"9" action:@selector(numberTouched:)]];
    }
    return _nineButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, 214);
        self.resultString = @"";
        [self buildSubviews];
    }
    return self;
}

- (void)buildSubviews {
    __weak typeof(self) weakSelf = self;
    
    [self.sevenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(1.5);
        make.top.equalTo(weakSelf.mas_top).offset(1.5);
    }];
    
    [self.eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_top);
        make.left.equalTo(weakSelf.sevenButton.mas_right).offset(.5);
        make.bottom.equalTo(weakSelf.sevenButton.mas_bottom);
        make.width.equalTo(weakSelf.sevenButton.mas_width);
    }];
    
    [self.nineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_top);
        make.bottom.equalTo(weakSelf.sevenButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_right).offset(.5);
        make.width.equalTo(weakSelf.sevenButton.mas_width);
        
    }];
    
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.sevenButton.mas_width);
        make.left.equalTo(weakSelf.nineButton.mas_right).offset(.5);
        make.right.equalTo(weakSelf.mas_right).offset(-1.5);
        make.bottom.equalTo(weakSelf.sixButton.mas_centerY);
        make.top.equalTo(weakSelf.sevenButton.mas_top);
    }];
    
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.sevenButton.mas_left);
        make.right.equalTo(weakSelf.sevenButton.mas_right);
        make.height.equalTo(weakSelf.sevenButton.mas_height);
    }];
    
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fourButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.fourButton.mas_left);
        make.right.equalTo(weakSelf.fourButton.mas_right);
        make.height.equalTo(weakSelf.fourButton.mas_height);
    }];
    
    [self.zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.sevenButton.mas_left);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-1.5);
        make.height.equalTo(weakSelf.fourButton.mas_height);
    }];
    
    [self.equalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.delButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.delButton.mas_left);
        make.right.equalTo(weakSelf.delButton.mas_right);
        make.bottom.equalTo(weakSelf.zeroButton.mas_bottom);
    }];
    
    [self.pointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.zeroButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.equalButton.mas_bottom);
    }];
    
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_top);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.oneButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_left);
    }];
    
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.oneButton.mas_bottom);
    }];
    
    [self.fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fourButton.mas_top);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.fourButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_left);
    }];
    
    [self.sixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fourButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.fourButton.mas_bottom);
    }];
    
}

- (void)numberTouched:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"0"] && [self.resultString isEqualToString:@"0"]) return;
    if ([btn.titleLabel.text isEqualToString:@"."] && [self.resultString containsString:@"."]) return;

    [self appendNumber:btn.titleLabel.text];
}

#pragma mark - 添加数字
- (void)appendNumber:(NSString *)number
{
    if ([self.resultString isEqualToString:@"0"] && ![number isEqualToString:@"."]) {
        self.resultString = @"0.";
    }
    
    NSString *string = [self.resultString stringByAppendingString:number];
    self.resultString = string;
    if (self.inputString) {
        self.inputString([NSString stringWithFormat:@"%.2lf", self.resultString.floatValue] , NO);
    }
}

- (void)del {
    if (self.resultString.length) {
        self.resultString = [self.resultString substringToIndex:self.resultString.length-1];
        if (self.inputString) {
            self.inputString([NSString stringWithFormat:@"%.2lf", self.resultString.floatValue] , NO);
        }
    }
}

- (void)equal {
    if (self.inputString) {
        NSString *str = @"";
        if (self.resultString.floatValue) {
            str = [NSString stringWithFormat:@"%.2lf", self.resultString.floatValue];
        }
        self.inputString(str, YES);
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
