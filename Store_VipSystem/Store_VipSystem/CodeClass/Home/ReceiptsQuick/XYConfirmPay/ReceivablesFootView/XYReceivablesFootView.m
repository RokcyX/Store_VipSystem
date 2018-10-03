//
//  XYReceivablesFootView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/18.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYReceivablesFootView.h"
#import "XYPitchOnControl.h"
@interface XYReceivablesFootView ()
    
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)XYPitchOnControl *msgControl;
@property (nonatomic, weak)XYPitchOnControl *printControl;
@property (nonatomic, weak)UIButton *recBtn;
    

@end

@implementation XYReceivablesFootView

- (void)setHiddenPrice:(BOOL)hiddenPrice {
    _hiddenPrice = hiddenPrice;
    self.titleLabel.hidden = hiddenPrice;
    if (hiddenPrice) {
        [self.recBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = @"收款：";
    [titleLabel sizeToFit];
    [titleLabel adjustsFontSizeToFitWidth];
    [self addSubview:self.titleLabel=titleLabel];
    WeakSelf;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.top.bottom.equalTo(weakSelf);
    }];
    
    XYPitchOnControl *msgControl = [[XYPitchOnControl alloc] init];
    msgControl.image = [UIImage imageNamed:@"unselected_login"];
    msgControl.selectImage = [UIImage imageNamed:@"selected_login"];
    msgControl.title = @"短信";
    msgControl.selected = NO;
    [self addSubview:self.msgControl=msgControl];
    [msgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(70);
    }];
    
    XYPitchOnControl *printControl = [[XYPitchOnControl alloc] init];
    printControl.image = [UIImage imageNamed:@"unselected_login"];
    printControl.selectImage = [UIImage imageNamed:@"selected_login"];
    printControl.title = @"打印";
    printControl.selected = [LoginModel shareLoginModel].printSetModel.pS_IsEnabled;
    if (![LoginModel shareLoginModel].printSetModel) {
        printControl.selected = YES;
    }
    [self addSubview:self.printControl=printControl];
    [printControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(msgControl.mas_right).offset(0);
        make.top.bottom.width.equalTo(msgControl);
    }];
    
    UIButton *recBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [recBtn setTitle:@"收款" forState:(UIControlStateNormal)];
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
        make.left.equalTo(printControl.mas_right).offset(30);
        make.width.mas_equalTo(70);
    }];
    
}

- (void)receivablesAction {
    if (self.receivablesPrice) {
        self.receivablesPrice(self.msgControl.selected, self.printControl.selected);
    }
}

- (void)setPriceString:(NSString *)priceString {
    _priceString = priceString;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"收款：" stringByAppendingString:self.priceString]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(3, self.priceString.length)];
    NSInteger fontSize = 17;
    NSInteger length = priceString.length;
    if (length - 5 > 0 ) {
        fontSize -= 1.4 * (priceString.length - 5);
        if (fontSize < 10) {
            fontSize = 10;
        }
    }
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(3, self.priceString.length)];
    
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
