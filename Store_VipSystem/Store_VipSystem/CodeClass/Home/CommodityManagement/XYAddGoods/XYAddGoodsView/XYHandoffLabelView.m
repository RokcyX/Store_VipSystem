//
//  XYHandoffLabelView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHandoffLabelView.h"

@interface XYHandoffLabelView ()

@property (nonatomic, weak)UIView *lineView;

@property (nonatomic, strong)UIImage *ordinaryImage;
@property (nonatomic, strong)UIImage *serviceImage;
@property (nonatomic, strong)UIImage *giftsImage;

@property (nonatomic, strong)NSMutableArray *ordinaryList;
@property (nonatomic, strong)NSMutableArray *serviceList;
@property (nonatomic, strong)NSMutableArray *giftsList;

@end

@implementation XYHandoffLabelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBColor(241, 241, 241);
        self.ordinaryList = [NSMutableArray array];
        self.serviceList = [NSMutableArray array];
        self.giftsList = [NSMutableArray array];
        [self buildViews];
    }
    return self;
}

- (UIButton *)buttonWithTag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitleColor:RGBColor(100, 100, 100) forState:(UIControlStateNormal)];
    btn.tag = tag;
    [btn setTitleColor:RGBColor(0, 0, 0) forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    return btn;
}

- (void)buildViews {
    WeakSelf;
    UIButton *leftBtn = [self buttonWithTag:100];
    [leftBtn setTitle:@"普通商品" forState:(UIControlStateNormal)];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf);
    }];
    
    UIButton *centerBtn = [self buttonWithTag:101];
    [centerBtn setTitle:@"服务商品" forState:(UIControlStateNormal)];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(leftBtn.mas_right);
        make.width.equalTo(leftBtn.mas_width);
    }];
    
    UIButton *rightBtn = [self buttonWithTag:102];
    [rightBtn setTitle:@"礼品" forState:(UIControlStateNormal)];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(centerBtn.mas_right);
        make.width.equalTo(centerBtn.mas_width);
        make.right.equalTo(weakSelf.mas_right);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(255, 128, 0);
    [self addSubview:self.lineView=lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(3);
    }];
    
}
- (void)selectAction:(UIButton *)btn {
    if (self.selectedItem && !btn.selected) {
        btn.selected = !btn.selected;
        for (UIButton *btnObj in self.subviews) {
            if ([btnObj isKindOfClass:[UIButton class]] && btnObj != btn) {
                btnObj.selected = NO;
            }
        }
        self.selectedIndex = btn.tag -100;
        self.selectedItem(self.selectedIndex);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    WeakSelf;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(ScreenWidth/3 *weakSelf.selectedIndex);
    }];
}

- (void)setHeaderImage:(UIImage *)headerImage {
    switch (self.selectedIndex) {
        case 0:
            self.ordinaryImage = headerImage;
            break;
        case 1:
            self.serviceImage = headerImage;
            break;
        case 2:
            self.giftsImage = headerImage;
            break;
            
        default:
            break;
    }
}

- (UIImage *)headerImage {
    switch (self.selectedIndex) {
        case 0:
            return self.ordinaryImage;
            break;
        case 1:
            return self.serviceImage;
            break;
        case 2:
            return self.giftsImage;
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)setDataList:(NSMutableArray *)dataList {
    switch (self.selectedIndex) {
        case 0:
            self.ordinaryList = dataList;
            break;
        case 1:
            self.serviceList = dataList;
            break;
        case 2:
            self.giftsList = dataList;
            break;
            
        default:
            break;
    }
}

- (NSMutableArray *)dataList {
    switch (self.selectedIndex) {
        case 0:
            return self.ordinaryList;
            break;
        case 1:
            return self.serviceList;
            break;
        case 2:
            return self.giftsList;
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)emptyData {
    self.headerImage = nil;
    [self.dataList removeAllObjects];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
