//
//  XYCountingConsumeCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCountingConsumeCell.h"

@interface XYCountingConsumeCell ()

@property (nonatomic, weak, readwrite)UIImageView *commodityImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *surplusLabel;
@property (nonatomic, weak)UILabel *totalLabel;

@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIButton *addBtn;
@property (nonatomic, weak)UIButton *removeBtn;
@end

@implementation XYCountingConsumeCell

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
    
    UILabel *surplusLabel = [[UILabel alloc] init];
    surplusLabel.textColor = RGBColor(143, 144, 145);
    surplusLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.surplusLabel=surplusLabel];
    [surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commodityImageView.mas_centerY);
        make.left.equalTo(titleLabel.mas_left);
        make.bottom.equalTo(commodityImageView.mas_bottom);
    }];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.textColor = RGBColor(143, 144, 145);
    totalLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.totalLabel=totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(surplusLabel);
        make.left.equalTo(surplusLabel.mas_right).offset(10);
        make.width.equalTo(surplusLabel.mas_width);
    }];
    
    [self.contentView addSubview:self.addBtn = [self buttonWithImageName:@"consumeGoods_cell_add" action:@selector(addAction)]];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(totalLabel);
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
        make.top.bottom.equalTo(totalLabel);
        make.width.mas_equalTo(40);
    }];
    
    
    [self.contentView addSubview:self.removeBtn = [self buttonWithImageName:@"consumeGoods_cell_delete" action:@selector(removeAction)]];
    [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(totalLabel);
        make.left.equalTo(totalLabel.mas_right);
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

- (void)setModel:(XYCountingConsumeModel *)model {
    _model = model;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];
    self.titleLabel.text = model.sG_Name;
    self.totalLabel.text = [NSString stringWithFormat:@"总次数：%ld", model.mCA_TotalCharge];
    self.surplusLabel.text = [NSString stringWithFormat:@"剩余次数：%ld", model.mCA_HowMany];

    self.countLabel.text = @(model.count).stringValue;
    self.removeBtn.hidden = YES;
    if (model.count) {
        self.removeBtn.hidden = NO;
    }
}


- (void)addAction {
    if (self.model.count < self.model.mCA_HowMany) {
        self.model.count ++;
        self.model = self.model;
        if (self.countHasChanged) {
            self.countHasChanged();
        }
    } else {
        [XYProgressHUD showMessage:@"不能超过剩余次数"];
    }
    
}

- (void)removeAction {
    self.model.count --;
    self.model = self.model;
    if (self.countHasChanged) {
        self.countHasChanged();
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
