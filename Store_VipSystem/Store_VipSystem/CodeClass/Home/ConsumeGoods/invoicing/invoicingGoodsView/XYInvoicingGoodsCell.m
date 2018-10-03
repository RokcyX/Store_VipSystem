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

@property (nonatomic, weak)UILabel *countLabel;

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
    [self.contentView addSubview:self.priceLabel=priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commodityImageView.mas_centerY);
        make.left.equalTo(titleLabel.mas_left);
        make.bottom.equalTo(commodityImageView.mas_bottom);
        make.width.equalTo(titleLabel.mas_width);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = RGBColor(143, 144, 145);
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.countLabel=countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        make.centerY.equalTo(priceLabel.mas_centerY);
        make.width.mas_equalTo(40);
    }];
    
}

- (void)setModel:(XYCommodityModel *)model {
    _model = model;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];
    self.titleLabel.text = model.pM_Name;
    self.priceLabel.text = [@"¥ " stringByAppendingString:@(model.pM_UnitPrice).stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", model.count];
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
