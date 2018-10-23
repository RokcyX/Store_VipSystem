//
//  XYCommodityViewCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCommodityViewCell.h"
@interface XYCommodityViewCell ()

@property (nonatomic, weak, readwrite)UIImageView *commodityImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *priceLabel;
@property (nonatomic, weak)UILabel *stockLabel;

@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIButton *addBtn;
@property (nonatomic, weak)UIButton *removeBtn;
@end

@implementation XYCommodityViewCell

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
    
    UILabel *stockLabel = [[UILabel alloc] init];
    stockLabel.textColor = RGBColor(143, 144, 145);
    stockLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.stockLabel=stockLabel];
    [stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commodityImageView.mas_bottom);
        make.left.equalTo(titleLabel.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.equalTo(titleLabel.mas_width);
    }];
    
    [self.contentView addSubview:self.addBtn = [self buttonWithImageName:@"consumeGoods_cell_add" action:@selector(addAction)]];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(stockLabel);
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.width.equalTo(weakSelf.addBtn.mas_height);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = RGBColor(143, 144, 145);
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.countLabel=countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.addBtn.mas_left);
        make.top.bottom.equalTo(stockLabel);
        make.width.mas_equalTo(40);
    }];
    
    
    [self.contentView addSubview:self.removeBtn = [self buttonWithImageName:@"consumeGoods_cell_delete" action:@selector(removeAction)]];
    [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(stockLabel);
        make.right.equalTo(weakSelf.countLabel.mas_left);
        make.width.equalTo(weakSelf.removeBtn.mas_height);
    }];
    
}

- (UIButton *)buttonWithImageName:(NSString *)imageName  action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

- (void)setModel:(XYCommodityModel *)model {
    _model = model;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];
    self.titleLabel.text = model.pM_Name;
    self.priceLabel.text = [@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2lf", model.pM_UnitPrice]];
    self.stockLabel.text = [@"库存： " stringByAppendingString:@(model.stock_Number).stringValue];
    self.countLabel.text = @(model.count).stringValue;
    self.consume = NO;
    if (self.addToShoppingCart) {
        self.consume = YES;
        self.removeBtn.hidden = YES;
        if (model.count) {
            self.removeBtn.hidden = NO;
        }
    }
}

- (void)setConsume:(BOOL)consume {
    self.countLabel.hidden = !consume;
    self.addBtn.hidden = !consume;
    self.removeBtn.hidden = !consume;
}


- (void)addAction {
    if (self.addToShoppingCart) {
        BOOL isShop = self.addToShoppingCart(self);
        if (isShop) {
            self.model.count ++;
            self.model = self.model;
        }
    }
}

- (void)removeAction {
    if (!self.model.count) {
        return;
    }
    self.model.count --;
    self.model = self.model;
    self.addToShoppingCart(nil);
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
