//
//  XYVipBasicInfoCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAddGoodsCell.h"
#import "XYKeyboardView.h"

@interface XYAddGoodsCell ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)UIButton *rightBtn;
@property (nonatomic, weak)UISwitch *switchControl;
@property (nonatomic, weak)UIView *rightBackView;
@property (nonatomic, weak)UILabel *requiredView;

@end

@implementation XYAddGoodsCell

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
    
    UIView *rightBackView = [[UIView alloc] init];
    textField.rightView = self.rightBackView=rightBackView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        rightBtn.tintColor = RGBColor(5, 139, 234);
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.rightBackView addSubview:self.rightBtn=rightBtn];
    }
    return _rightBtn;
}

- (UISwitch *)switchControl {
    if (!_switchControl) {
        UISwitch *switchControl = [[UISwitch alloc] init];
//        [switchControl addTarget:self action:@selector(rightBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.rightBackView addSubview:self.switchControl=switchControl];
        switchControl.center = self.rightBackView.center;
    }
    return _switchControl;
}

- (void)removeRightView {
    [self.rightBtn removeFromSuperview];
    self.rightBtn = nil;
    [self.switchControl removeFromSuperview];
    self.switchControl = nil;
}

- (void)setModel:(XYAddGoodsModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.calculateWidth + 10, CGRectGetHeight(self.contentView.frame));
    self.detailField.text = model.detail;
    self.requiredView.hidden = !model.isRequired;
    self.detailField.rightViewMode = UITextFieldViewModeAlways;
    self.detailField.placeholder = model.placeholder;
    self.detailField.enabled = model.isWritable;
    self.detailField.inputAccessoryView = nil;
    self.detailField.inputView = nil;
    self.detailField.keyboardType = model.keyboardType;
    [self removeRightView];
    if (model.rightViewType == RightViewTypeNull) {
        self.detailField.rightViewMode = UITextFieldViewModeNever;
    } else if (model.rightViewType == RightViewTypeSpace) {
        self.rightBackView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)*2, CGRectGetHeight(self.frame));
        self.rightBtn.enabled = NO;
    } else if (model.rightViewType == RightViewTypeScanAndSpace) {
        self.rightBackView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)*2 + 36, CGRectGetHeight(self.frame));
        self.rightBtn.frame = CGRectMake(0, 0, 36, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 16)/2, 10, (CGRectGetHeight(self.frame) - 16)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_scan"] forState:(UIControlStateNormal)];
    } else if (model.rightViewType == RightViewTypeIndicator) {
        self.rightBackView.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
        self.rightBtn.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(self.frame) - 17.5)/2, 10, (CGRectGetHeight(self.frame) - 17.5)/2, 0);
        [self.rightBtn setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:(UIControlStateNormal)];
        WeakSelf;
        
        XYKeyboardView *keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        keyboard.count = model.selectList.count;
        keyboard.titleForRow = ^NSString *(NSInteger row) {
            return model.selectList[row];
        };
        keyboard.seletedNum = self.detailField.text;
        XYKeyboardToolbar *toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                weakSelf.detailField.text = model.detail;
                model.updateValue = @([model.selectList indexOfObject:keyboard.string]).stringValue;
                if (model.selectList.count != 2) {
                    model.updateValue = @([model.selectList indexOfObject:keyboard.string] + 1).stringValue;
                    if (weakSelf.selectedRule) {
                        weakSelf.selectedRule([model.selectList indexOfObject:keyboard.string] + 1);
                    }
                }
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;
        
    } else if (model.rightViewType == RightViewTypeSwitch) {
        self.rightBackView.frame = CGRectMake(0, 0, 50, CGRectGetHeight(self.frame));
        self.switchControl.on = model.updateValue.boolValue;
        [self switchControl];
    }
}

- (void)isBecomeFirstResponder {
    [self.detailField becomeFirstResponder];
}
- (void)textFieldEditingChanged:(UITextField *)textField {
    NSString *string = textField.text;
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (self.model.keyboardType == 8 && array.count > 1 && [array.lastObject length]>2) {
        string = [NSString stringWithFormat:@"%.2lf", string.floatValue];
        textField.text = string;
    }
    
    self.model.detail = string;
}

- (void)rightBtnAction {
    if (self.model.rightViewType == RightViewTypeScanAndSpace) {
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
