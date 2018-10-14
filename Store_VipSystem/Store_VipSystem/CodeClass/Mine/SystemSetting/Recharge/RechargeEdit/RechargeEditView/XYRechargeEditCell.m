//
//  XYRechargeEditCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRechargeEditCell.h"
#import "XYKeyboardView.h"

@interface XYRechargeEditCell ()<UITextFieldDelegate>

@property (nonatomic, weak)UIButton *titleBtn;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)UITextField *endDetailField;
@property (nonatomic, weak)UILabel *untilLabel;

@end

@implementation XYRechargeEditCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 60
        
        [self setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 0)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self buildViews];
    }
    return self;
}

- (UITextField *)textField {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.delegate = self;
    textField.placeholder = @"点击选择";
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}

- (void)buildViews {
    UITextField *detailField = self.textField;
    detailField.leftViewMode = UITextFieldViewModeAlways;
    detailField.rightViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.detailField=detailField];
    WeakSelf;
    [detailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        
    }];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(labelSelectAction) forControlEvents:(UIControlEventTouchUpInside)];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.numberOfLines = 0;
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button setTitleColor:RGBColor(249, 104, 62) forState:(UIControlStateSelected)];
    button.layer.borderWidth = 1;
    detailField.leftView = self.titleBtn=button;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (CGRectGetWidth(self.contentView.frame))/2, CGRectGetHeight(self.contentView.frame)-20)];
    detailField.rightView = rightView;
    
    UILabel *untilLabel = [[UILabel alloc] init];
    untilLabel.textAlignment = NSTextAlignmentCenter;
    untilLabel.text = @"至";
    [rightView addSubview:self.untilLabel=untilLabel];
    [untilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(rightView);
        make.width.mas_equalTo(60);
    }];
    
    UITextField *endDetailField = self.textField;
    XYKeyboardToolbar *toolbar;
    XYKeyboardView *keyboard;
    keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeDatePicker)];
    toolbar = [XYKeyboardToolbar defaultToolbar];
    toolbar.finished = ^(BOOL success) {
        if (success) {
            weakSelf.model.endDetail = keyboard.string;
            endDetailField.text = weakSelf.model.endDetail;
        }
        [endDetailField resignFirstResponder];
    };
    endDetailField.inputAccessoryView = toolbar;
    endDetailField.inputView = keyboard;
    [self.contentView addSubview:self.endDetailField = endDetailField];
    [endDetailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(detailField);
        make.width.mas_equalTo(CGRectGetWidth(weakSelf.contentView.frame)/2-60);
    }];
}

- (void)labelSelectAction {
    [XYAppDelegate.window endEditing:YES];
    self.model.isSelected = !self.model.isSelected;
    if (self.selectModel) {
        self.selectModel(self.model);
    }
}

- (void)setModel:(XYValidTimeModel *)model {
    _model = model;
    [self.titleBtn setTitle:model.title forState:(UIControlStateNormal)];
    self.titleBtn.selected = model.isSelected;
    self.titleBtn.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.titleBtn.selected) {
        self.titleBtn.layer.borderColor = RGBColor(249, 104, 62).CGColor;
    }
    self.titleBtn.frame = CGRectMake(0, 0, self.titleBtn.titleLabel.calculateWidth + 15, CGRectGetHeight(self.contentView.frame)-20);
    self.detailField.text = model.detail;
    if (!model.rightType) {
        self.detailField.placeholder = @"";
    }
    self.detailField.rightViewMode = UITextFieldViewModeNever;
    WeakSelf;
    self.endDetailField.hidden = YES;
    if (model.rightType == 2) {
        self.detailField.rightViewMode = UITextFieldViewModeAlways;
        self.endDetailField.text = model.endDetail;
        self.endDetailField.hidden = NO;
    }
    
    self.detailField.inputAccessoryView = nil;
    self.detailField.inputView = nil;
    if (model.rP_ValidType == 1) {
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeDatePicker)];
        toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                weakSelf.detailField.text = model.detail;
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;
    } else if (model.rP_ValidType == 2) {
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithCount:7];
        keyboard.seletedNum = self.detailField.text;
        toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                weakSelf.detailField.text = model.detail;
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;
    } else if (model.rP_ValidType == 3) {
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithCount:31];
        keyboard.seletedNum = self.detailField.text;
        toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                weakSelf.detailField.text = model.detail;
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.model.rightType) {
        return NO;
    }
    if (!self.model.isSelected) {
        [XYProgressHUD showMessage:[NSString stringWithFormat:@"选择’%@‘后,可选择",self.model.title]];
        [XYAppDelegate.window endEditing:YES];
    }
    return self.model.isSelected;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (self.model.isSelected) {
        if ([textField isEqual:self.endDetailField]) {
            self.model.endDetail = textField.text;
        } else {
            self.model.detail = textField.text;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
