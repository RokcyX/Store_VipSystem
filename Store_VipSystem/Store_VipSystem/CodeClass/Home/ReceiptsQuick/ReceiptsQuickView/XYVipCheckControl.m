//
//  XYVipCheckControl.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipCheckControl.h"

@interface XYVipCheckControl ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UIImageView *iconView;

@end

@implementation XYVipCheckControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    WeakSelf;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择会员";
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel=titleLabel];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"receiptsQuick_shoise_vip"];
    [self addSubview:self.iconView=iconView];
    
    UIButton *screenView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    screenView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [screenView setImage:[UIImage imageNamed:@"member_navi_screen"] forState:(UIControlStateNormal)];
    [screenView setImage:[UIImage imageNamed:@"vipSelect_delete"] forState:(UIControlStateSelected)];
    [self addSubview:self.screenView=screenView];

    [screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);

    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.height.width.mas_equalTo(15);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right);
        make.top.bottom.equalTo(weakSelf);
        make.right.equalTo(screenView.mas_left).offset(-8);
    }];
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
    } else {
        _title = @"选择会员";
    }
    self.titleLabel.text = _title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
