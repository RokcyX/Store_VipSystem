//
//  XYStaffEditCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYStaffEditCell.h"
#import "XYKeyboardView.h"

@interface XYStaffEditCell ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)UIButton *rightBtn;
@property (nonatomic, weak)UIView *rightBackView;
@property (nonatomic, weak)UILabel *requiredView;

@end

@implementation XYStaffEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 60
        
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailField=textField];
    WeakSelf;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    textField.leftView = self.titleLabel=titleLabel;
    
    UILabel *requiredView = [[UILabel alloc] init];
    requiredView.text = @"＊";
    requiredView.textAlignment = NSTextAlignmentRight;
    requiredView.font = [UIFont systemFontOfSize:8];
    requiredView.textColor = [UIColor redColor];
    [titleLabel addSubview:self.requiredView=requiredView];
    [requiredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_right);
        make.bottom.equalTo(titleLabel.mas_centerY);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.tintColor = RGBColor(5, 139, 234);
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    textField.rightView = self.rightBtn=rightBtn;
    
}

- (void)setModel:(XYStaffEditModel *)model readOnly:(BOOL)readOnly {
    self.model = model;
    self.titleLabel.text = model.title;
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.calculateWidth + 10, CGRectGetHeight(self.contentView.frame));
    self.detailField.text = model.detail;
    self.requiredView.hidden = !model.isRequired;
    self.detailField.rightViewMode = UITextFieldViewModeAlways;
    if (readOnly) {
        self.detailField.placeholder = @"";
        self.detailField.enabled = NO;
        self.detailField.rightViewMode = UITextFieldViewModeNever;
        return;
    }
    self.detailField.placeholder = model.placeholder;
    self.detailField.enabled = model.isWritable;
    self.rightBtn.enabled = YES;
    self.detailField.inputAccessoryView = nil;
    self.detailField.inputView = nil;
    self.detailField.keyboardType = model.keyboardType;
    if (model.rightViewType == RightViewTypeNull) {
        self.detailField.rightViewMode = UITextFieldViewModeNever;
    } else if (model.rightViewType == RightViewTypeIndicator) {
        self.rightBtn.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 17.5)/2, 10, (CGRectGetHeight(self.frame) - 17.5)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:(UIControlStateNormal)];
        WeakSelf;
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        if (model.selectList.count) {
            keyboard.count = self.model.selectList.count;
            keyboard.titleForRow = ^NSString *(NSInteger row) {
                if ([model.selectList[row] isKindOfClass:[NSString class]]) {
                    return model.selectList[row];
                } else if ([model.selectList[row] isKindOfClass:[ShopModel class]]) {
                    return [model.selectList[row] sM_Name];
                }else{
                    if ([model.selectList[row] respondsToSelector:@selector(dM_Name)]) {
                        return [model.selectList[row] dM_Name];
                    }
                    return  @"没有获取数据的接口";
                }
            };
            keyboard.seletedNum = self.detailField.text;
        }
        toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                weakSelf.detailField.text = model.detail;
                if ([model.selectList.firstObject isKindOfClass:[NSString class]]) {
                    model.updateValue = @([model.selectList indexOfObject:model.detail]).stringValue;
                } else {
                    if ([model.selectList.firstObject isKindOfClass:[XYDeptModel class]]) {
                        for (XYDeptModel *dept in model.selectList) {
                            if ([dept.dM_Name isEqualToString:model.detail]) {
                                model.updateValue = dept.gID;
                            }
                        }
                    } else {
                        
                    }
                }
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;

    } else if (model.rightViewType == RightViewTypeCalendar) {
        WeakSelf;
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
        self.rightBtn.frame = CGRectMake(0, 0, 30.8, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 18)/2, 10, (CGRectGetHeight(self.frame) - 18)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_calender"] forState:(UIControlStateNormal)];
    }
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if ([self.model.title isEqualToString:@"手机号码"] && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    self.model.detail = textField.text;
}

- (void)rightBtnAction {
    [self.detailField becomeFirstResponder];
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
