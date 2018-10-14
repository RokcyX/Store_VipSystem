//
//  XYJointPaymentCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/23.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYJointPaymentCell.h"

@interface XYJointPaymentCell ()
@property (nonatomic, weak) UIImageView * iconView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;

@end

@implementation XYJointPaymentCell

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
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.iconView=imageView];
    WeakSelf;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.iconView.mas_height);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 80.2, 50)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailField=textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.bottom.equalTo(weakSelf.contentView).offset(-5);
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
    }];
    
    UIButton *recBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    recBtn.tag = 102;
    [recBtn setTitle:@"选择优惠劵" forState:(UIControlStateNormal)];
    [recBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [recBtn addTarget:self action:@selector(selectCouponsAction) forControlEvents:(UIControlEventTouchUpInside)];
    recBtn.layer.cornerRadius = 5;
    recBtn.backgroundColor = RGBColor(252, 105, 67);
    recBtn.frame = CGRectMake(0, 0, recBtn.titleLabel.calculateWidth + 10, 40);
    textField.rightView = recBtn;
    //    sendMsgBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    sendMsgBtn.layer.shadowOpacity = 0.5;
    //    sendMsgBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:recBtn];
}

- (void)selectCouponsAction {
    if (self.selectCoupons) {
        self.selectCoupons(self.model);
    }
}

- (void)setModel:(XYJointPaymentModel *)model {
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.iconImage];
    self.titleLabel.text = model.title;
    self.detailField.enabled = !model.readonly;
    self.detailField.placeholder = model.placeholder;
    self.detailField.rightViewMode = model.selectEnable;
}


- (void)textFieldEditingChanged:(UITextField *)textField {
    if ([self.model.title isEqualToString:@"余额"]) {
        if (textField.text.floatValue > self.balance) {
            textField.text = @(self.balance).stringValue;
        }
    }
    if ([self.model.detail isEqualToString:textField.text]) {
        self.model.detail = textField.text;
        //    self.model.updateValue = textField.text;
        if (self.priceChanged) {
            self.priceChanged();
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
