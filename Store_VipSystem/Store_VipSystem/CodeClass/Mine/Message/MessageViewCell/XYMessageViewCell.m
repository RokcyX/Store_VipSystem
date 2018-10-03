//
//  XYMessageViewCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMessageViewCell.h"

@interface XYMessageViewCell ()
@property (nonatomic, weak)UIImageView *iconView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *messageTitleLabel;
@property (nonatomic, weak)UIView *badgeView;
@property (nonatomic, weak)UILabel *messageDetailLabel;
@end

@implementation XYMessageViewCell

#define IconHeight 17

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"mine_msg_notices"];
    [self.contentView addSubview:self.iconView=iconView];
    WeakSelf;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.width.height.mas_equalTo(IconHeight);
    }];
    
    UILabel *titleLabel= [[UILabel alloc] init];
    titleLabel.text = @"系统消息";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView.mas_centerY);
        make.left.equalTo(iconView.mas_right).offset(5);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"2014-12-31 15:13:34";
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel=timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
    }];
    
    UILabel *messageTitleLabel = [[UILabel alloc] init];
    
    messageTitleLabel.text = @"云商铺5.31升级通知";
    messageTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:self.messageTitleLabel=messageTitleLabel];
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.layer.cornerRadius = 2.5;
    badgeView.backgroundColor = [UIColor redColor];
//    badgeView.frame = CGRectMake(CGRectGetWidth(self.messageTitleLabel.frame), CGRectGetMidY(self.messageTitleLabel.frame), 5, 5);
    [self.contentView addSubview:self.badgeView=badgeView];

    UILabel *messageDetailLabel = [[UILabel alloc] init];
    messageDetailLabel.text = @"云商铺会员管理系统将于2014年1月24日升级请用户及时升级";
    messageDetailLabel.font = [UIFont systemFontOfSize:15];
    messageDetailLabel.textColor = RGBColor(143, 144, 145);
    [self.contentView addSubview:self.messageDetailLabel=messageDetailLabel];
    [messageDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.right.equalTo(timeLabel.mas_right);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
    }];
}

- (void)setModel:(XYMessageModel *)model {
    _model = model;
    self.messageTitleLabel.text = model.title;
    self.timeLabel.text = model.createTime;
    self.badgeView.hidden = model.popState;
    self.messageDetailLabel.text = @"具体内容";

    //    self.checkBox.selected = model.isSelected;
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.vIP_HeadImg] placeholderImage:[UIImage imageNamed:@"member_vip_cellHeader"]];
//    self.titleLabel.text = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
//    self.detailLabel.text = model.vIP_CellPhone;
    CGFloat labelWidth = self.messageTitleLabel.calculateWidth > ScreenWidth - 44  ? ScreenWidth - 44  : self.messageTitleLabel.calculateWidth + 8;
    self.messageTitleLabel.frame = CGRectMake(10 + 17 + 5, 10 + 17 + 15, labelWidth, 20);
    self.badgeView.frame = CGRectMake(CGRectGetMaxX(self.messageTitleLabel.frame), CGRectGetMinY(self.messageTitleLabel.frame), 5, 5);
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
