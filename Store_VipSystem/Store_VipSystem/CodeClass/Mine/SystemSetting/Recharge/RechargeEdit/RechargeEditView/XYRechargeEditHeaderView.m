//
//  XYRechargeEditHeaderView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRechargeEditHeaderView.h"
#import "XYKeyboardView.h"

@interface XYRechargeEditHeaderView ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)UITextField *seletField;
@property (nonatomic, weak)UILabel *requiredView;
@property (nonatomic, weak)UIView *lineView;


@end

@implementation XYRechargeEditHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self buildViews];
    }
    return self;
}

- (UITextField *)textField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(82.2, 0, 130, 50)];
    textField.font = [UIFont systemFontOfSize:14];
    textField.text = @"减少金额";
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.textAlignment = NSTextAlignmentCenter;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7.5, 50)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"vip_basicInfo_right"];
    textField.rightView = imageView;
    return textField;
}

- (void)buildViews {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 67.2, 50)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    
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
    

    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    textField.leftView = rightView;

    UITextField *seletField = [self textField];
    seletField.hidden = YES;
    [self.contentView addSubview:self.seletField=seletField];
   
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1];
    [self.contentView addSubview:self.lineView=lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(XYRechargeEditModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.detailField.text = model.detail;
    self.requiredView.hidden = !model.isRequired;
    self.lineView.hidden = NO;
    self.detailField.keyboardType = model.keyboardType;
    self.detailField.placeholder = model.placeholder;
    self.detailField.enabled = model.isWritable;
    self.detailField.leftViewMode = UITextFieldViewModeNever;
    self.seletField.hidden = YES;


    if (model.seletDatas.count) {
        self.detailField.leftViewMode = UITextFieldViewModeAlways;
        self.seletField.text = model.seletTitle;
        self.seletField.hidden = NO;
        
        WeakSelf;
        
        XYKeyboardView *keyboard = [XYKeyboardView keyBoardWithType:(KeyboardTypeStringPicker)];
        keyboard.count = model.seletDatas.count;
        keyboard.titleForRow = ^NSString *(NSInteger row) {
            return [model.seletDatas[row] title];
        };
        keyboard.seletedNum = self.seletField.text;
        XYKeyboardToolbar *toolbar = [XYKeyboardToolbar defaultToolbar];
        toolbar.finished = ^(BOOL success) {
            if (success) {
                for (XYRechargeEditModel *obj in model.seletDatas) {
                    if ([obj.title isEqualToString:keyboard.string]) {
                        model.modelKey = obj.modelKey;
                        model.seletTitle = obj.title;
                        model.placeholder = obj.placeholder;
                        model.detail = obj.detail;
                        if (self.valueDidChangedBlock) {
                            self.valueDidChangedBlock();
                        }
                    }
                }
                weakSelf.seletField.text = model.seletTitle;
            }
            [weakSelf.seletField resignFirstResponder];
        };
        self.seletField.inputAccessoryView = toolbar;
        self.seletField.inputView = keyboard;
    }
    if ([model.title isEqualToString:@"有效时间"]) {
        self.lineView.hidden = YES;
        self.detailField.text = @"";
    }
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    self.model.detail = textField.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
