//
//  XYMineHeaderView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMineHeaderView.h"

@interface XYMineHeaderView ()
@property (nonatomic, weak)UILabel *badgeLabel;
@end

@implementation XYMineHeaderView

#define LengthInIP6(lengthInIP6) ((CGFloat)lengthInIP6)/375*ScreenWidth

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"backImage_navi"];
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    WeakSelf;
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[LoginModel shareLoginModel].shopModel.sM_Picture] placeholderImage:[UIImage imageNamed:@"user_store_Header"]];
    iconImageView.layer.cornerRadius = LengthInIP6(75/2);
    iconImageView.clipsToBounds = YES;
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LengthInIP6(10));
        make.top.mas_equalTo(76 - 75/2);
        make.width.height.mas_equalTo(LengthInIP6(75));
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = [LoginModel shareLoginModel].uM_Name.length ? [LoginModel shareLoginModel].uM_Name : [LoginModel shareLoginModel].uM_Acount;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:LengthInIP6(15)];
    [self addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_offset(LengthInIP6(20));
        make.centerY.mas_equalTo(iconImageView.mas_centerY).mas_offset(-LengthInIP6(5));
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:LengthInIP6(12)];
    messageLabel.text = [LoginModel shareLoginModel].sM_Name;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = RGBColor(233, 113, 30);
    messageLabel.layer.cornerRadius = 3;
    messageLabel.layer.masksToBounds = YES;
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameLabel.mas_left);
        make.top.mas_equalTo(userNameLabel.mas_bottom).mas_offset(LengthInIP6(5));
        make.width.mas_equalTo(messageLabel.calculateWidth + 5);
    }];
    
    UILabel *showLabel = [[UILabel alloc] init];
    NSString *storeType = [LoginModel shareLoginModel].shopModel.sM_Type == 0 ? @"免费版  >" : [LoginModel shareLoginModel].shopModel.sM_Type == 1 ? @"高级版（年费）>" : @"高级版（永久）>";
    showLabel.text = storeType;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.textColor = [UIColor whiteColor];
    showLabel.frame = CGRectMake(0, 0, showLabel.calculateWidth + 30, 35);
    [self addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.width.mas_equalTo(showLabel.calculateWidth + 30);
        make.height.mas_equalTo(35);
    }];
    
    // 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:showLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = showLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    showLabel.layer.mask = maskLayer;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBColor(252, 198, 56).CGColor, (__bridge id)RGBColor(253, 169, 51).CGColor, (__bridge id)RGBColor(253, 155, 48).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, showLabel.calculateWidth + 30, 35);
    [showLabel.layer addSublayer:gradientLayer];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(255, 168, 91);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-42);
        make.height.mas_equalTo(1);
    }];

    
    UIButton *messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [messageBtn setImage:[UIImage imageNamed:@"mine_messages_icon"] forState:(UIControlStateNormal)];
    [messageBtn setTitle:@"消息" forState:(UIControlStateNormal)];
    [messageBtn addTarget:self action:@selector(messageAction) forControlEvents:(UIControlEventTouchUpInside)];
    messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [self addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(weakSelf);
        make.height.mas_equalTo(42);
    }];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.text = @"11";
    badgeLabel.font = [UIFont boldSystemFontOfSize:10];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor redColor];
    [messageBtn addSubview:self.badgeLabel=badgeLabel];
    CGFloat badgeWidth = 15.0;
    badgeLabel.layer.cornerRadius = badgeWidth/2;
    badgeLabel.layer.masksToBounds = YES;
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageBtn.titleLabel.mas_right);
        make.bottom.equalTo(messageBtn.titleLabel.mas_top).offset(badgeWidth/1.5);
        make.height.width.mas_equalTo(badgeWidth);
    }];
    UIButton *setBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [setBtn setImage:[UIImage imageNamed:@"mine_setting_icon"] forState:(UIControlStateNormal)];
    [setBtn addTarget:self action:@selector(settingAction) forControlEvents:(UIControlEventTouchUpInside)];
    [setBtn setTitle:@"设置" forState:(UIControlStateNormal)];
    setBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(weakSelf);
        make.left.equalTo(messageBtn.mas_right);
        make.width.equalTo(messageBtn.mas_width);
        make.height.mas_equalTo(42);
    }];
}

- (void)messageAction {
    if (self.chickAction) {
        self.chickAction(1);
    }
}

- (void)settingAction {
    if (self.chickAction) {
        self.chickAction(2);
    }
}

- (void)setBadge:(NSInteger)badge {
    self.badgeLabel.hidden = !badge;
    self.badgeLabel.text = @(badge).stringValue;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
