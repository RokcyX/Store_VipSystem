//
//  XYHomeSectionView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHomeSectionView.h"

@implementation XYHomeSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(245, 245, 245);
    [self.contentView addSubview:lineView];
    WeakSelf;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBColor(102, 102, 102);
    [self.contentView addSubview:self.titleLabel = label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-1);
        make.right.equalTo(weakSelf.contentView.mas_right);
    }];
    
    UIView *lineBView = [[UIView alloc] init];
    lineBView.backgroundColor = RGBColor(245, 245, 245);
    [self.contentView addSubview:lineBView];
    [lineBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
    
//    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom);
//    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
