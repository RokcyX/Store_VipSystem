//
//  XYHomeViewCell.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHomeViewCell.h"

@implementation XYHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {

    for (int i = 0; i < 3; i++) {
        XYHomeFuncView *funcView = [[XYHomeFuncView alloc] initWithFrame:CGRectMake(10 + (10 + (ScreenWidth - 40)/3)*i, 10, (ScreenWidth - 40)/3, 87)];
        funcView.tag = 200+i;
        [self.contentView addSubview:funcView];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(10 + (10 + (ScreenWidth - 40)/3)*i, 10, (ScreenWidth - 40)/3, 87);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.titleLabel.numberOfLines = 2;
        button.tag = 100+i;
        [self.contentView addSubview:button];
    }
}

- (void)setImages:(NSArray *)images titles:(NSArray *)titles isBtn:(BOOL)isBtn {
    if (isBtn) {
        // 可点击
        for (UIView *objView in self.contentView.subviews) {
            if ([objView isKindOfClass:[UIButton class]]) {
                objView.userInteractionEnabled = YES;
            }
            if (objView.tag > 199) {
                objView.hidden = NO;
                XYHomeFuncView *func = (XYHomeFuncView *)objView;
                if (199 < objView.tag && objView.tag < 203) {
                    func.iconView.image = [UIImage imageNamed:images[func.tag-200]];
                    func.titleLabel.text = titles[func.tag-200];
                }
                
            }
        }
    } else {
        // 不可点击
        for (UIView *objView in self.contentView.subviews) {
            if ([objView isKindOfClass:[UIButton class]]) {                objView.userInteractionEnabled = NO;
            }
            if (objView.tag > 199) {
                objView.hidden = YES;
            } else if (99 < objView.tag && objView.tag < 103) {
                UIButton *btn = (UIButton *)objView;
                [btn setBackgroundImage:[UIImage imageNamed: images[btn.tag-100]] forState:(UIControlStateNormal)];
                [btn setTitle:titles[btn.tag-100] forState:(UIControlStateNormal)];
            }
        }
    }
}

- (void)buttonAction:(UIButton *)btn {
    if (self.chickAction) {
        self.chickAction(btn.tag-100);
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
