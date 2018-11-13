//
//  XYHomeB.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/5.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHomeBasicView.h"

@interface XYHomeBasicView ()

//@property (nonatomic, weak)UITextField *searchField;
//@property (nonatomic, weak)UIButton *scanBtn;

@end

@implementation XYHomeBasicView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBColor(244, 245, 246);
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    UITextField *searchField = [[UITextField alloc] init];
    searchField.layer.cornerRadius = 4;
    searchField.layer.masksToBounds = YES;
    searchField.placeholder = @"请输入会员名称、卡号、手机号";
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    
//    UIView *searchBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 134, 55)];

    UIButton *searchView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchView.enabled = NO;
    searchView.frame = CGRectMake(0, 0, 40, 35);
    [searchView setImage:[UIImage imageNamed:@"home_basic_search"] forState:(UIControlStateNormal)];
    searchView.tintColor = [UIColor blackColor];
    searchView.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 5);
    //    [searchBackView addSubview:self.scanBtn=scanBtn];
    searchField.leftView = searchView;
    
    UIButton *scanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    scanBtn.frame = CGRectMake(0, 0, 45, 35);
    [scanBtn setImage:[UIImage imageNamed:@"home_basic_scan"] forState:(UIControlStateNormal)];
    scanBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    self.scanBtn=scanBtn;
//    [searchBackView addSubview:self.scanBtn=scanBtn];
    searchField.rightView = self.scanBtn;
    [self addSubview:self.searchField=searchField];
    WeakSelf;
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(35);
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
