//
//  XYPitchOnControl.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYPitchOnControl.h"

@interface XYPitchOnControl ()

@end

@implementation XYPitchOnControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 50 height
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    WeakSelf;
    UIButton *checkAllBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [checkAllBtn setImage:[UIImage imageNamed:@"check_box_circle_normal"] forState:(UIControlStateNormal)];
    [checkAllBtn setImage:[UIImage imageNamed:@"check_box_circle_selected"] forState:(UIControlStateSelected)];
    [checkAllBtn addTarget:self action:@selector(checkAllAction) forControlEvents:(UIControlEventTouchUpInside)];
    checkAllBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 5);
    [self addSubview:self.checkBtn=checkAllBtn];
    [checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(weakSelf);
        make.width.mas_equalTo(35);
    }];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn addTarget:self action:@selector(checkAllAction) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.titleBtn=btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(checkAllBtn);
        make.left.equalTo(checkAllBtn.mas_right);
        make.right.equalTo(weakSelf);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleBtn setTitle:title forState:(UIControlStateNormal)];
//    WeakSelf;
//    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(weakSelf.titleBtn.titleLabel.calculateWidth + 30);
//    }];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.checkBtn.selected = selected;
}

- (void)checkAllAction {
    self.selected = !self.selected;
    if (self.selectControl) {
        self.selectControl();
    }
}
    
- (void)setImage:(UIImage *)image {
    _image = image;
    [self.checkBtn setImage:image forState:(UIControlStateNormal)];
}

- (void)setSelectImage:(UIImage *)selectImage {
    _selectImage = selectImage;
    [self.checkBtn setImage:selectImage forState:(UIControlStateSelected)];
}
    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
