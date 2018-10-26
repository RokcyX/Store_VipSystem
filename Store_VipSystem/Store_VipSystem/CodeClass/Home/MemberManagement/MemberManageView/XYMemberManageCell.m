//
//  XYMemberManageCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/6.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMemberManageCell.h"

@interface XYMemberManageCell ()

@property (nonatomic, weak)UIButton *checkBox;
@property (nonatomic, weak)UIImageView *headerImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *detailLabel;

@end

@implementation XYMemberManageCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 60
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    UIButton *checkBox = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [checkBox setImage:[UIImage imageNamed:@"check_box_circle_normal"] forState:(UIControlStateNormal)];
    [checkBox setImage:[UIImage imageNamed:@"check_box_circle_selected"] forState:(UIControlStateSelected)];
    [checkBox addTarget:self action:@selector(checkAction:) forControlEvents:(UIControlEventTouchUpInside)];
    checkBox.imageEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15);
    [self.contentView addSubview:self.checkBox=checkBox];
    WeakSelf;
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(50);
        make.height.equalTo(self.contentView);
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.layer.cornerRadius = 8;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.image = [UIImage imageNamed:@"member_vip_cellHeader"];
    [self.contentView addSubview:self.headerImageView=headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBox.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.width.equalTo(headerImageView.mas_height);
    }];
    // 143 144 145
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"李晓霞";
    [self.contentView addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(headerImageView.mas_right).offset(10);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"15612312323";
    detailLabel.textColor = RGBColor(143, 144, 145);
    detailLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 2];
    [self.contentView addSubview:self.detailLabel=detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(titleLabel.mas_left);
        make.height.mas_equalTo(20);
        make.width.equalTo(titleLabel.mas_width);
    }];
    
    for (int i = 0; i < 5; i++) {
        UIButton *amassBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        amassBtn.tag = 120 + i;
//        amassBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 15 -20*i, CGRectGetMidY(self.contentView.bounds), 15, 15);
        amassBtn.layer.cornerRadius = 2;
        amassBtn.layer.masksToBounds = YES;
        amassBtn.layer.borderWidth = 2;
        amassBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:amassBtn];
        [amassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20*i);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        amassBtn.hidden = YES;
    }
}


- (void)setModel:(XYMemberManageModel *)model {
    _model = model;
    self.checkBox.selected = model.isSelected;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.vIP_HeadImg] placeholderImage:[UIImage imageNamed:@"member_vip_cellHeader"]];
    self.titleLabel.text = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
    self.detailLabel.text = model.vIP_CellPhone;
    
    /*
     VG_IsAccount    是否储值
     VG_IsIntegral    是否积分
     VG_IsDiscount    是否打折
     VG_IsCount    是否计次
     VG_IsTime    是否限时
     */
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];

//    NSArray *array = @[@"储",@"积",@"折",@"计",@"限"];
//    NSArray *colors = @[RGBColor(224, 175, 62), RGBColor(236, 183, 173), RGBColor(244, 195, 225), RGBColor(216, 163, 133), RGBColor(224, 175, 92)];
    if (model.vG_IsAccount) {
        [array addObject:@"储"];
        [colors addObject:RGBColor(224, 175, 62)];
    }
    
    if (model.vG_IsIntegral) {
        [array addObject:@"积"];
        [colors addObject:RGBColor(236, 183, 173)];
    }
    
    if (model.vG_IsDiscount) {
        [array addObject:@"折"];
        [colors addObject:RGBColor(244, 195, 225)];
    }
    
    if (model.vG_IsCount) {
        [array addObject:@"计"];
        [colors addObject:RGBColor(216, 163, 133)];
    }
    
    if (model.vG_IsTime) {
        [array addObject:@"限"];
        [colors addObject:RGBColor(224, 175, 92)];
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *amassBtn = [self.contentView viewWithTag:120+i];
        if (i < array.count) {
            amassBtn.layer.borderColor = [colors[i] CGColor];
            [amassBtn setTitleColor:colors[i] forState:(UIControlStateNormal)];
            [amassBtn setTitle:array[i] forState:(UIControlStateNormal)];
            amassBtn.hidden = NO;
        } else {
            amassBtn.hidden = YES;
        }
    }
}

- (void)checkAction:(UIButton *)btn {
    self.model.isSelected = btn.selected = !btn.selected;
    if (self.checkBoxAction) {
        self.checkBoxAction();
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
