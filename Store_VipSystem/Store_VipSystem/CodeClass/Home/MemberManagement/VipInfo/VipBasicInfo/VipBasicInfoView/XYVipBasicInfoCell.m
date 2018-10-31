//
//  XYVipBasicInfoCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipBasicInfoCell.h"
#import "XYKeyboardView.h"

@interface XYVipBasicInfoCell ()<UITextFieldDelegate>
@property (nonatomic, strong)XYVipBasicInfoModel *model;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)UIButton *rightBtn;
@property (nonatomic, weak)UILabel *requiredView;
@property (nonatomic, weak)UITextField *endDetailField;
@end

@implementation XYVipBasicInfoCell
#define endDetailFieldWidth 100
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
    
    UITextField *endDetailField = [[UITextField alloc] init];
    endDetailField.font = [UIFont systemFontOfSize:14];
    endDetailField.placeholder = @"选择支付方式";
    endDetailField.rightViewMode = UITextFieldViewModeAlways;
    endDetailField.leftViewMode = UITextFieldViewModeAlways;
    endDetailField.textAlignment = NSTextAlignmentCenter;
    endDetailField.hidden = YES;
    endDetailField.delegate = self;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(self.frame))];
    lineView.backgroundColor = RGBColor(244, 245, 246);
    endDetailField.leftView = lineView;
    
    UIButton *endRightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    endRightBtn.tintColor = RGBColor(5, 139, 234);
    endDetailField.rightView = endRightBtn;
    endRightBtn.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
    endRightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 17.5)/2, 10, (CGRectGetHeight(self.frame) - 17.5)/2, 0);
    [endRightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:(UIControlStateNormal)];
    XYKeyboardToolbar *toolbar;
    XYKeyboardView *keyboard;
    keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
//   103 106 105 101
    NSMutableArray *array = [NSMutableArray array];
    for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets.firstObject[@"models"]) {
        if (obj.sS_State) {
            if (obj.sS_Code.integerValue == 101 ||obj.sS_Code.integerValue == 103 ||obj.sS_Code.integerValue == 105 ||obj.sS_Code.integerValue == 106) {
                [array addObject:obj];
            }
        }
    }
    self.payWays = array;
    keyboard.count = array.count;
    keyboard.titleForRow = ^NSString *(NSInteger row) {
        return [array[row] sS_Name];
    };
    keyboard.seletedNum = self.detailField.text;
    toolbar = [XYKeyboardToolbar defaultToolbar];
    toolbar.finished = ^(BOOL success) {
        if (success) {
            weakSelf.endDetailField.text = keyboard.string;
            weakSelf.model.vCH_Fee_PayTypeText = keyboard.string;
        }
        [weakSelf.endDetailField resignFirstResponder];
    };
    endDetailField.inputAccessoryView = toolbar;
    endDetailField.inputView = keyboard;
    [self.contentView addSubview:self.endDetailField = endDetailField];
    [endDetailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(textField);
        make.width.mas_equalTo(endDetailFieldWidth+20);
    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.payWays.count) {
        [XYProgressHUD showMessage:@"没有支付方式"];
    }
    return self.payWays.count;
}

- (void)setModel:(XYVipBasicInfoModel *)model readOnly:(BOOL)readOnly {
    self.model = model;
    self.titleLabel.text = model.title;
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.calculateWidth + 10, CGRectGetHeight(self.contentView.frame));
    self.detailField.text = model.detail;
    self.requiredView.hidden = !model.isRequired;
    self.detailField.rightViewMode = UITextFieldViewModeAlways;
    self.endDetailField.hidden = YES;
    if (readOnly) {
        self.detailField.placeholder = @"";
        self.detailField.enabled = NO;
        switch (model.rightViewType) {
            case RightViewTypeSpace:
                self.rightBtn.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)*2, CGRectGetHeight(self.frame));
                self.rightBtn.enabled = NO;
                break;
            case RightViewTypeScan:
            case RightViewTypeIndicator:
            case RightViewTypeCalendar:
            case RightViewTypeNull:
                self.detailField.rightViewMode = UITextFieldViewModeNever;
                break;
            default:
                break;
        }
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
    } else if (model.rightViewType == RightViewTypeSpace) {
        self.rightBtn.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)*2, CGRectGetHeight(self.frame));
        self.rightBtn.enabled = NO;
    } else if (model.rightViewType == RightViewTypeScan) {
        self.rightBtn.frame = CGRectMake(0, 0, 36, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 16)/2, 10, (CGRectGetHeight(self.frame) - 16)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_scan"] forState:(UIControlStateNormal)];
    } else if (model.rightViewType == RightViewTypeIndicator) {
        self.rightBtn.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 17.5)/2, 10, (CGRectGetHeight(self.frame) - 17.5)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:(UIControlStateNormal)];
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
    } else if (model.rightViewType == RightViewTypeTextField) {
        self.rightBtn.frame = CGRectMake(0, 0, endDetailFieldWidth + 20 + 10, CGRectGetHeight(self.frame));
        self.rightBtn.enabled = NO;
        self.endDetailField.hidden = NO;
        self.endDetailField.text = model.vCH_Fee_PayTypeText;
    }
    
    if ([self.model.title isEqualToString:@"会员性别"]) {
        WeakSelf;
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        keyboard.count = 3;
        keyboard.titleForRow = ^NSString *(NSInteger row) {
            return @[@"男", @"女", @"保密"][row];
        };
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
    
    if ([self.model.title isEqualToString:@"会员等级"]) {
        WeakSelf;
        XYKeyboardToolbar *toolbar;
        XYKeyboardView *keyboard;
        keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        if (self.vipGradeList.count) {
            keyboard.count = self.vipGradeList.count;
            keyboard.titleForRow = ^NSString *(NSInteger row) {
                return [weakSelf.vipGradeList[row] vG_Name];
            };
            keyboard.seletedNum = self.detailField.text;
        }
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

- (void)textFieldEditingChanged:(UITextField *)textField {
    if ([self.model.title isEqualToString:@"会员手机"] && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    self.model.detail = textField.text;
}

- (void)rightBtnAction {
    if (self.model.rightViewType == RightViewTypeScan) {
        if (self.scan) {
            self.scan();
        }
    } else {
        [self.detailField becomeFirstResponder];
    }
    
//     if (self.model.rightViewType == RightViewTypeCalendar)
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
