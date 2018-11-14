//
//  XYInvoicingGoodsCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYInvoicingGoodsCell.h"

@interface XYInvoicingGoodsCell ()

@property (nonatomic, weak, readwrite)UIImageView *commodityImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *priceLabel;

@property (nonatomic, weak)UITextField *countField;

@property (nonatomic, weak)UITextField *detailField;

@end

@implementation XYInvoicingGoodsCell

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
    WeakSelf;
    UIImageView *commodityImageView = [[UIImageView alloc] init];
    commodityImageView.layer.cornerRadius = 8;
    commodityImageView.layer.masksToBounds = YES;
    commodityImageView.image = [UIImage imageNamed:@"commodity_product_placeholder"];
    [self.contentView addSubview:self.commodityImageView=commodityImageView];
    [commodityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.height.mas_equalTo(50);
        make.width.equalTo(commodityImageView.mas_height);
    }];
    // 143 144 145
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(commodityImageView.mas_centerY);
        make.left.equalTo(commodityImageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = RGBColor(249, 0, 0);
    priceLabel.font = [UIFont systemFontOfSize:15];
    
    UITextField *countField = [[UITextField alloc] init];
    countField.font = [UIFont systemFontOfSize:14];
    [countField addTarget:self action:@selector(countFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    countField.keyboardType = 4;
    countField.leftViewMode = UITextFieldViewModeAlways;
    countField.leftView = self.priceLabel=priceLabel;
    [self.contentView addSubview:self.countField=countField];
    
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.keyboardType = 8;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor redColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
    nameLabel.text = @"￥";
    nameLabel.textColor = [UIColor redColor];
    textField.leftView = nameLabel;
    [self.contentView addSubview:self.detailField=textField];
    
    for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets[2][@"models"]) {
        if ([obj.title isEqualToString:@"折后金额修改"]) {
            textField.enabled = obj.sS_State;
        }
    }
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        make.centerY.equalTo(countField.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    
    [countField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commodityImageView.mas_centerY);
        make.left.equalTo(titleLabel.mas_left);
        make.bottom.equalTo(commodityImageView.mas_bottom);
        make.right.equalTo(textField.mas_left).offset(-10);
    }];
}

- (void)setModel:(XYCommodityModel *)model {
    _model = model;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];
    self.titleLabel.text = model.pM_Name;
    NSString *text = [NSString stringWithFormat:@"¥ %.2lf     x", model.pM_UnitPrice];
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:NSMakeRange(text.length-2, 2)];
    self.priceLabel.attributedText = attributedStr;
    
    self.priceLabel.frame = CGRectMake(0, 0, [self.priceLabel calculateWidth], 25);
    
    self.countField.text = @(model.count).stringValue;
    self.detailField.text = model.discountPriceStr;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    self.model.discountPriceStr = textField.text;
    if (textField.text.floatValue > self.model.pM_UnitPrice*self.model.count) {
//        [XYProgressHUD showMessage:@"折后金额不能大于原价"];
        self.model.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.model.discountPrice *self.model.count];
    }
    textField.text = self.model.discountPriceStr;
    if (self.changeDiscount) {
        self.changeDiscount();
    }
}

- (void)countFieldEditingChanged:(UITextField *)textField {
    self.model.count = textField.text.integerValue;
    self.detailField.text = self.model.discountPriceStr = [NSString stringWithFormat:@"%.2lf", self.model.discountPrice *self.model.count];
    if (self.changeDiscount) {
        self.changeDiscount();
    }
}

@end
