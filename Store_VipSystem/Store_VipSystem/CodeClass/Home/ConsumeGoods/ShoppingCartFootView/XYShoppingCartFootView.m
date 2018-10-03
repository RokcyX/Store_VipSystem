//
//  ShoppingCartFootView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/24.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYShoppingCartFootView.h"

@interface XYShoppingCartFootView ()

@property (nonatomic, weak)UIButton *shoppingCart;
@property (nonatomic, weak)UILabel *badgeLabel;

@property (nonatomic, weak)UILabel *amountLabel;
@property (nonatomic, weak)UIButton *recBtn;

@end

@implementation XYShoppingCartFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    
    WeakSelf;
    UIButton *shoppingCart = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shoppingCart setImage:[UIImage imageNamed:@"foot_shop_car"] forState:(UIControlStateNormal)];
    [shoppingCart addTarget:self action:@selector(shoppingCartAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:shoppingCart];
    [shoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(42);
    }];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.text = @"0";
    badgeLabel.font = [UIFont boldSystemFontOfSize:14];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor redColor];
    [shoppingCart addSubview:self.badgeLabel=badgeLabel];
    CGFloat badgeWidth = 20.0;
    badgeLabel.layer.cornerRadius = badgeWidth/2;
    badgeLabel.layer.masksToBounds = YES;
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shoppingCart.imageView.mas_right).offset(-10);
        make.bottom.equalTo(shoppingCart.imageView.mas_top).offset(badgeWidth/1.5);
        make.height.width.mas_equalTo(badgeWidth);
    }];
    
    UILabel *amountLabel = UILabel.new;
    [self addSubview:self.amountLabel=amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shoppingCart.mas_right).offset(20);
        make.top.bottom.equalTo(weakSelf);
    }];
    self.amountString = @"0.00";
    
    UIButton *recBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [recBtn setTitle:@"结账" forState:(UIControlStateNormal)];
    [recBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [recBtn addTarget:self action:@selector(receivablesAction) forControlEvents:(UIControlEventTouchUpInside)];
    recBtn.layer.cornerRadius = 5;
    recBtn.backgroundColor = RGBColor(252, 105, 67);
    //    sendMsgBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    sendMsgBtn.layer.shadowOpacity = 0.5;
    //    sendMsgBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self addSubview:self.recBtn=recBtn];
    [recBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.left.equalTo(amountLabel.mas_right).offset(10);
        make.width.mas_equalTo(70);
    }];
}

- (void)setGoodsNum:(NSInteger)goodsNum {
    _goodsNum = goodsNum;
    self.badgeLabel.text = @(goodsNum).stringValue;
}

- (void)setAmountString:(NSString *)amountString {
    _amountString = amountString;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"收款：" stringByAppendingString:amountString]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(3, amountString.length)];
    self.amountLabel.attributedText = attributedStr;
    
}

- (void)receivablesAction {
    if (self.invoicingAmount) {
        self.invoicingAmount();
    }
}

- (void)shoppingCartAction {
    if (self.shoppingCartShow) {
        self.shoppingCartShow();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
