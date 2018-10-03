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
@property (nonatomic, weak)UIButton *saveBtn;
@property (nonatomic, weak)UIButton *amassBtn;
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
    UIButton *amassBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    amassBtn.layer.cornerRadius = 2;
    amassBtn.layer.masksToBounds = YES;
    amassBtn.layer.borderWidth = 2;
    amassBtn.layer.borderColor = RGBColor(236, 183, 173).CGColor;
    [amassBtn setTitleColor:RGBColor(236, 183, 173) forState:(UIControlStateNormal)];
    [amassBtn setTitle:@"积" forState:(UIControlStateNormal)];
    amassBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.amassBtn=amassBtn];
    [amassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerImageView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    saveBtn.layer.cornerRadius = 2;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.borderWidth = 2;
    saveBtn.layer.borderColor = RGBColor(224, 175, 62).CGColor;
    [saveBtn setTitleColor:RGBColor(224, 175, 62) forState:(UIControlStateNormal)];
    [saveBtn setTitle:@"储" forState:(UIControlStateNormal)];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.saveBtn=saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerImageView.mas_centerY);
        make.right.equalTo(amassBtn.mas_left).offset(-5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    // 暂时隐藏
    saveBtn.hidden = YES;
    amassBtn.hidden = YES;
}


- (void)setModel:(XYMemberManageModel *)model {
    _model = model;
    self.checkBox.selected = model.isSelected;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.vIP_HeadImg] placeholderImage:[UIImage imageNamed:@"member_vip_cellHeader"]];
    self.titleLabel.text = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
    self.detailLabel.text = model.vIP_CellPhone;
    
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
