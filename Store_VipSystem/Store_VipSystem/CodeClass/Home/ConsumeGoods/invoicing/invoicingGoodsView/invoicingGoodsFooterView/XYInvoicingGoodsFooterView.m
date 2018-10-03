//
//  XYInvoicingGoodsFooterView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYInvoicingGoodsFooterView.h"

@interface XYInvoicingGoodsFooterView ()

@property (nonatomic, weak)UIButton *openBtn;
@property (nonatomic, weak)UILabel *titleLabel;

@end

@implementation XYInvoicingGoodsFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    WeakSelf;
    UIButton *openBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    openBtn.backgroundColor = [UIColor whiteColor];
    [openBtn setTitleColor:RGBColor(59, 171, 250) forState:(UIControlStateNormal)];
    [openBtn setTitle:@"收起" forState:(UIControlStateSelected)];
    [openBtn setTitle:@"展开" forState:(UIControlStateNormal)];
    [openBtn addTarget:self action:@selector(openView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.openBtn=openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(1);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(openBtn.mas_bottom).offset(1);
        make.left.right.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)openView {
    self.isOpen= !self.isOpen;
    if (self.openGoodsView) {
        self.openGoodsView(self.isOpen);
    }
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    self.openBtn.selected = isOpen;
    self.titleLabel.hidden = !isOpen;
}

- (void)setAttributedStr:(NSMutableAttributedString *)attributedStr {
    _attributedStr = attributedStr;
    self.titleLabel.attributedText = attributedStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
