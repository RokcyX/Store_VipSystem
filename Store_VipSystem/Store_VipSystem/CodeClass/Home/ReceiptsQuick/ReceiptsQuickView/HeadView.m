//
//  HeadView.m
//  Calculator
//
//  Created by Wcaulpl on 2017/9/4.
//  Copyright © 2017年 Wcaulpl. All rights reserved.
//

#import "HeadView.h"
#import "NSString+Chinese.h"
@interface HeadView ()

@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UILabel *stringLabel;

@property (weak, nonatomic) UILabel *cardNumLabel;
@property (weak, nonatomic) UILabel *balanceLabel;
@property (weak, nonatomic) UILabel *integralLabel;

@end

@implementation HeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bulidSubViews];
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHeadView)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipe];
    }
    return self;
}

- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return label;
}

- (void)bulidSubViews {
    WeakSelf;
    [self addSubview:self.cardNumLabel = self.label];
    [self.cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf.mas_centerX).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.balanceLabel = self.label];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.cardNumLabel);
        make.left.equalTo(weakSelf.cardNumLabel.mas_right);
    }];
    
    [self addSubview:self.integralLabel = self.label];
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.balanceLabel);
        make.left.equalTo(weakSelf.balanceLabel.mas_right);
        make.right.equalTo(weakSelf);
    }];
    [self setTitleHidden];
}

- (void)setCardNum:(NSString *)cardNum {
    self.cardNumLabel.hidden = NO;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"   卡号：" stringByAppendingString:cardNum]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(6, cardNum.length)];
    
    self.cardNumLabel.attributedText = attributedStr;
}

- (void)setBalance:(NSString *)balance {
    self.balanceLabel.hidden = NO;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"   余额：" stringByAppendingString:balance]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(6, balance.length)];
    
    self.balanceLabel.attributedText = attributedStr;
}

- (void)setIntegral:(NSString *)integral {
    self.integralLabel.hidden = NO;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"   积分：" stringByAppendingString:integral]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(6, integral.length)];
    
    self.integralLabel.attributedText = attributedStr;
}

- (void)setTitleHidden {
    self.cardNumLabel.hidden = YES;
    self.balanceLabel.hidden = YES;
    self.integralLabel.hidden = YES;
}

#pragma mark - 左右扫手势
- (void)swipeHeadView
{
    if ([self.resultLabel.text isEqualToString:@"0"]) return;
    NSMutableString *tempStr = [NSMutableString stringWithString:self.resultLabel.text];
    [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length - 1, 1)];
    if (tempStr.length == 0) {
        self.resultLabel.text = @"0";
    } else {
        self.resultLabel.text = tempStr;
        self.stringLabel.text = @"";
    }
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (NSString *)text {
    return self.resultLabel.text;
}

- (void)setText:(NSString *)text {
    self.resultLabel.text = text;
    [self adjustResultLabelSizeFontWithResultStr:text];
}

- (UILabel *)stringLabel {
    if (!_stringLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.stringLabel=label];
    }
    return _stringLabel;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = @"0.00";
        if (@available(iOS 8.2, *)) {
            label.font = [UIFont systemFontOfSize:80.0 weight:UIFontWeightThin];
        } else {
            // Fallback on earlier versions
        }
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.resultLabel=label];
    }
    return _resultLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    
    [self.stringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.resultLabel.mas_top);
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.left.equalTo(weakSelf.mas_left);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-8);
    }];
}

- (void)setString:(NSString *)string {
    self.stringLabel.text = string;
}

- (NSString *)string {
    return self.stringLabel.text;
}

#pragma mark - 调整数字大小
- (void)adjustResultLabelSizeFontWithResultStr:(NSString *)resultStr
{
    if ([resultStr isChinese] || [resultStr includeChinese]) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:30]];
    } else {
        if (resultStr.length <= 6) {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:80]];
        } else if (resultStr.length > 6 && resultStr.length <= 9) {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:60]];
        } else {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:45]];
        }
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
