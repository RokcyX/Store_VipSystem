//
//  XYVipRechargeCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipRechargeCell.h"
#import "XYAmountInputView.h"
@interface XYVipRechargeCell ()<UITextFieldDelegate>

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *detailField;
@property (nonatomic, weak)NSArray *schemelist;
@end

@implementation XYVipRechargeCell

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
        make.top.bottom.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
    }];
    
}

- (id)textFieldisbtn:(BOOL)isBtn {
    if (isBtn) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(labelSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.numberOfLines = 2;
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        return button;
    }
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"手动输入";
    textField.layer.cornerRadius = 5;
    textField.delegate = self;
    textField.layer.masksToBounds = YES;
    WeakSelf;
    XYAmountInputView *amoutInput = [[XYAmountInputView alloc] init];
    amoutInput.inputString = ^(NSString *result, BOOL isFinished) {
        if (weakSelf.amoutInput && !isFinished) {
            BOOL isEnabled = weakSelf.amoutInput(result, nil);
            if (isEnabled) {
                textField.text = result;
                self.model.detail = result;
            } else {
                [XYProgressHUD showMessage:@"请选择会员"];
                [textField resignFirstResponder];
            }
            
        }
        if (isFinished) {
            [textField resignFirstResponder];
        }
    };
    textField.inputView = amoutInput;
    textField.layer.borderWidth = 1;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor = [UIColor grayColor].CGColor;

    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 101+self.schemelist.count) {
        for (XYRechargeModel *obj in self.schemelist) {
            obj.selected = NO;
        }
        [self setModel:self.model schemelist:self.schemelist];
        textField.layer.borderColor = RGBColor(249, 104, 62).CGColor;
        XYAmountInputView *amoutInput = (XYAmountInputView *)textField.inputView;
        amoutInput.resultString = textField.text;
    }
    return YES;
}

- (void)labelSelectAction:(UIButton *)btn {
    if (self.amoutInput) {
        XYRechargeModel *model = self.schemelist[btn.tag -101];
        BOOL isEnabled = self.amoutInput([NSString stringWithFormat:@"%.2lf", model.rP_RechargeMoney], model);
        UITextField *textField = [self.contentView viewWithTag:101+self.schemelist.count];
        if (isEnabled) {
            for (XYRechargeModel *obj in self.schemelist) {
                obj.selected = NO;
            }
            model.selected = YES;
            self.model.detail = [NSString stringWithFormat:@"%.2lf", model.rP_RechargeMoney];

            [self setModel:self.model schemelist:self.schemelist];
            textField.layer.borderColor = [UIColor grayColor].CGColor;
            textField.text = @"";
        } else {
            [XYProgressHUD showMessage:@"请选择会员"];
        }
        [textField resignFirstResponder];
    }


}

- (NSAttributedString *)attributedStrWithTitle:(NSString *)title detail:(NSString *)detail {
    if (!detail || !detail.length) {
        detail = @"无";
    }
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title, detail]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15]
                          range:NSMakeRange(title.length, detail.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor grayColor]
                          range:NSMakeRange(title.length, detail.length)];
    return attributedStr;
}

- (void)setModel:(XYVipRechargeModel *)model schemelist:(NSArray *)schemelist {
    self.model = model;
    self.schemelist = schemelist;
    self.detailField.hidden = NO;
    if (schemelist) {
        self.detailField.hidden = YES;
        for (int i = 0; i <=schemelist.count; i++) {
            UIButton *btn = [self.contentView viewWithTag:101+i];
            if (!btn) {
                if (i == schemelist.count) {
                   btn = [self textFieldisbtn:NO];
                } else {
                    btn = [self textFieldisbtn:YES];
                    btn.titleLabel.numberOfLines = 2;
                }
                btn.frame = CGRectMake(10 + ((ScreenWidth - 40)/3 + 10)*(i%3), 50 + 60 * (i/3), (ScreenWidth - 40)/3, 50);
                btn.tag = 101+i;
                
                [self.contentView addSubview:btn];
            }
            if (i < schemelist.count) {
                XYRechargeModel *obj = schemelist[i];
                NSAttributedString *title;
                if (obj.rP_Discount) {
                    //                优惠
                    title = [self attributedStrWithTitle:[NSString stringWithFormat:@"%.2lf元\n", obj.rP_RechargeMoney] detail:[NSString stringWithFormat:@"优惠%.2lf折", obj.rP_Discount]];
//                    RP_RechargeMoney
//                    priceModel.detail = [NSString stringWithFormat:@"%.2lf", self.vipPrice *(rechargeModel.rP_Discount/10)];
//                    self.footView.priceString = priceModel.detail;
                    
                } else if (obj.rP_GiveMoney) {
                    //                赠送
                    title = [self attributedStrWithTitle:[NSString stringWithFormat:@"%.2lf元\n", obj.rP_RechargeMoney] detail:[NSString stringWithFormat:@"赠送%.2lf元", obj.rP_GiveMoney]];
                } else if (obj.rP_ReduceMoney) {
                    //                减少
                    title = [self attributedStrWithTitle:[NSString stringWithFormat:@"%.2lf元\n", obj.rP_RechargeMoney] detail:[NSString stringWithFormat:@"减少%.2lf元", obj.rP_ReduceMoney]];
//                    priceModel.detail = [NSString stringWithFormat:@"%.2lf",self.vipPrice -rechargeModel.rP_ReduceMoney];
//                    self.footView.priceString = priceModel.detail;
                }
                
                [btn setAttributedTitle:title forState:(UIControlStateNormal)];
                if (obj.selected) {
                    btn.layer.borderColor = RGBColor(249, 104, 62).CGColor;
                } else {
                    btn.layer.borderColor = [UIColor grayColor].CGColor;
                }
            }
        }
    }
}

- (void)setModel:(XYVipRechargeModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.detailField.text = model.detail;
    self.detailField.enabled = model.isWritable;
    self.detailField.textColor = [UIColor colorWithHex:model.textColor];
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
