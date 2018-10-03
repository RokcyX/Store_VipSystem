//
//  XYAddClassifyView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/22.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAddClassifyView.h"

@implementation XYAddClassifyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    WeakSelf;
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_centerY);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftView = b;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.cornerRadius = 8;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = RGBColor(222, 222, 222).CGColor;
    [self addSubview:self.textField=textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_centerY);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
