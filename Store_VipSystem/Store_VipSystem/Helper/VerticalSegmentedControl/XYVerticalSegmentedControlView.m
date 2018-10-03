//
//  VerticalSegmentedControlTableViewCell.m
//  VerticalSegmentedControl-Demo
//
//  Created by Vincent on 2/25/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import "XYVerticalSegmentedControlView.h"

@interface XYVerticalSegmentedControlView ()
@property (weak, nonatomic) UIView *indicatorLine;
@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, weak)UIControl *control;
@end

@implementation XYVerticalSegmentedControlView

- (instancetype)init {
    if (self = [super init]) {
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    WeakSelf;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = RGBColor(222, 222, 222);;
    [self addSubview:self.rightLine=rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(1);
    }];
    
    UIView *indicatorLine = [[UIView alloc] init];
    indicatorLine.backgroundColor = RGBColor(255, 128, 0);
    [self addSubview:self.indicatorLine=indicatorLine];
    [indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(4);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(222, 222, 222);
    [self addSubview:self.lineView=lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom).offset(-1);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];

}

- (UIControl *)control {
    if (!_control) {
        UIControl *control = [[UIControl alloc] init];
        [self addSubview:self.control=control];
        WeakSelf;
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
    }
    return _control;
}

- (void)setSelectedView:(void (^)(NSInteger))selectedView {
    _selectedView = selectedView;
    [self.control addTarget:self action:@selector(didSelectSection) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)didSelectSection {
    if (self.selectedView) {
        self.selectedView(self.indexPath.section);
    }
}

- (void)setLongPressView:(void (^)(NSIndexPath *))longPressView {
    _longPressView = longPressView;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)]];
}

- (void)longPressAction {
    if (self.longPressView) {
        self.longPressView(self.indexPath);
    }
}

- (void)setSegmentTitle:(NSString *)title selected:(BOOL)selected {
    self.titleLabel.text = title;
    self.indicatorLine.hidden = !selected;
    self.rightLine.hidden = selected;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
