//
//  XYParameterSetCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYParameterSetCell.h"
#import "XYPitchOnControl.h"
#import "XYKeyboardView.h"
@interface XYParameterSetCell ()

@property (nonatomic, weak)XYPitchOnControl *selectControl;
@property (nonatomic, weak)UITextField *textField;
@property (nonatomic, weak)UIView *lineView;
@property (nonatomic, strong)UIButton *rightView;
@end

@implementation XYParameterSetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    
    WeakSelf;
    XYPitchOnControl *selectControl = [[XYPitchOnControl alloc] init];
    selectControl.selectControl = ^{
        weakSelf.model.sS_State = weakSelf.selectControl.selected;
        if (!weakSelf.model.sS_State) {
            weakSelf.model.sS_Value = @"";
        }
        if (weakSelf.selectItem) {
            weakSelf.selectItem(weakSelf.model);
        }
    };
    [self.contentView addSubview:weakSelf.selectControl=selectControl];
    [selectControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(ScreenWidth/2-15);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.textField=textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectControl.mas_right);
        make.top.bottom.right.equalTo(weakSelf.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1];
    [self.contentView addSubview:self.lineView=lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(ScreenWidth-15);
        make.height.mas_equalTo(1);
    }];
}

- (void)fieldHidden:(BOOL)hidden {
    self.textField.hidden = hidden;
    self.lineView.hidden = hidden;
}

- (void)rightViewWithMode:(NSInteger)mode {
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    if (!self.rightView) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.contentView.frame));
        self.textField.rightView = btn;
        self.rightView = btn;
    }
    [self.rightView setTitle:@"" forState:(UIControlStateNormal)];
    [self.rightView setImage:nil forState:(UIControlStateNormal)];
    if (mode == 1) {
        [self.rightView setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.rightView setTitle:@"%" forState:(UIControlStateNormal)];
    } else {
        [self.rightView setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:(UIControlStateNormal)];
        WeakSelf;
        NSArray *selectList = @[@"现金支付", @"余额支付", @"银联支付", @"微信记账", @"支付宝记账"];
        XYKeyboardView *keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        keyboard.count = selectList.count;
        keyboard.titleForRow = ^NSString *(NSInteger row) {
            return selectList[row];
        };
        keyboard.seletedNum = self.textField.text;
        XYKeyboardToolbar *toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                weakSelf.textField.text = keyboard.string;
                weakSelf.model.sS_Value = keyboard.string.codeWithString;
            }
            [weakSelf.textField resignFirstResponder];
        };
        self.textField.inputAccessoryView = toolbar;
        self.textField.inputView = keyboard;
    }
}

- (void)setModel:(XYParameterSetModel *)model {
    _model = model;
    self.selectControl.userInteractionEnabled = model.enabled;
    self.selectControl.title = model.title;
    self.selectControl.selected = model.sS_State;
    [self fieldHidden:YES];
    self.textField.rightViewMode = UITextFieldViewModeNever;
    if (!model.sS_State) {
        model.sS_Value = @"";
    }
    if (model.hasValue) {
        self.textField.userInteractionEnabled = model.enabled;
        self.textField.keyboardType = model.keyboardType;
        self.textField.text = model.sS_Value.stringWithCode;
        self.textField.placeholder = model.placeholder;
        self.textField.inputAccessoryView = nil;
        self.textField.inputView = nil;
        [self fieldHidden:NO];
        if (model.rightMode) {
            [self rightViewWithMode:model.rightMode];
        }
    }
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    self.model.sS_Value = textField.text;
}

@end
