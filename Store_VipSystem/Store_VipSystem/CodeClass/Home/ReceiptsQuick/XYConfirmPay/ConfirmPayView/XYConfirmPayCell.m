//
//  XYConfirmPayCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYConfirmPayCell.h"
#import "XYKeyboardView.h"
@interface XYConfirmPayCell ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;

@end

@implementation XYConfirmPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80.2, 50)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailField=textField];
    WeakSelf;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
    }];
}

- (void)setModel:(XYConfirmPayModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.detailField.text = model.detail;
    self.detailField.enabled = model.isWritable;
    self.detailField.textColor = [UIColor colorWithHex:model.textColor];
    self.detailField.keyboardType = model.keyboardType;
    if (model.keyboardType < 0) {
        WeakSelf;
        XYKeyboardView *keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypetime)];
        keyboard.seletedNum = self.detailField.text;
        XYKeyboardToolbar *toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                model.detail = keyboard.string;
                model.updateValue = model.detail;
                weakSelf.detailField.text = model.detail;
            }
            [weakSelf.detailField resignFirstResponder];
        };
        self.detailField.inputAccessoryView = toolbar;
        self.detailField.inputView = keyboard;
    }
    self.accessoryType = model.rightMode;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    self.model.detail = textField.text;
    self.model.updateValue = textField.text;
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
