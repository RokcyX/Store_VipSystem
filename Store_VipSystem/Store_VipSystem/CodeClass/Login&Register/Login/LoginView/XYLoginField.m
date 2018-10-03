//
//  XYLoginField.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/7/31.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYLoginField.h"

@implementation XYLoginField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UITextField appearance].tintColor = RGBColor(251, 92, 25);
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeAlways;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 17, 16, 16);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 50)];
    [backView addSubview:self.iconView = imageView];
    self.leftView = backView;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(222, 222, 222);
    [self addSubview:lineView];
    WeakSelf;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
    
}



//- (CGRect)leftViewRectForBounds:(CGRect)bounds {
//    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x += 15; //像右边偏15
//    return iconRect;
    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
