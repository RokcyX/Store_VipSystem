//
//  XYReceiptsQuickController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYReceiptsQuickController.h"
#import "HeadView.h"

#import "XYVipSelectionController.h"
#import "XYConfirmPayController.h"

@interface XYReceiptsQuickController ()

@property (weak, nonatomic) HeadView *resultLabel;

@property (nonatomic, weak) UIButton *delButton;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) UIButton *equalButton;
@property (nonatomic, weak) UIButton *pointButton;
@property (nonatomic, weak) UIButton *zeroButton;
@property (nonatomic, weak) UIButton *oneButton;
@property (nonatomic, weak) UIButton *twoButton;
@property (nonatomic, weak) UIButton *threeButton;
@property (nonatomic, weak) UIButton *fourButton;
@property (nonatomic, weak) UIButton *fiveButton;
@property (nonatomic, weak) UIButton *sixButton;
@property (nonatomic, weak) UIButton *sevenButton;
@property (nonatomic, weak) UIButton *eightButton;
@property (nonatomic, weak) UIButton *nineButton;

@property (nonatomic, strong) XYVipSelectionController *vipSelect;

@property (nonatomic, weak)XYMemberManageModel *model;
@property (nonatomic, weak)XYVipCheckControl *check;
@end

@implementation XYReceiptsQuickController

- (HeadView *)resultLabel {
    if (!_resultLabel) {
        HeadView *headView = [[HeadView alloc] init];
        [self.view addSubview:self.resultLabel=headView];
    }
    return _resultLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快速消费";
    if (self.isReceipts) {
        [self setNaviUI];
        self.title = @"快捷收款";
    }
}

- (void)setNaviUI {
    XYVipCheckControl *check = [[XYVipCheckControl alloc] initWithFrame:CGRectMake(0, 0, 110, 35)];
    [check addTarget:self action:@selector(selectVip) forControlEvents:(UIControlEventTouchUpInside)];
    [check.screenView addTarget:self action:@selector(screenDel:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:check];
    self.check = check;
}

- (void)screenDel:(UIButton *)btn {
    if (btn.selected) {
        self.model = nil;
        self.check.title = nil;
        btn.selected = NO;
        // titleView hidden
        [self.resultLabel setTitleHidden];
    } else {
        [self selectVip];
    }
}

- (XYVipSelectionController *)vipSelect {
    if (!_vipSelect) {
        _vipSelect = [[XYVipSelectionController alloc] init];
        WeakSelf;
        _vipSelect.selectModel = ^(XYMemberManageModel *model) {
            weakSelf.model = model;
            weakSelf.check.title = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
            weakSelf.check.screenView.selected = YES;
            weakSelf.resultLabel.cardNum = model.vCH_Card;
            weakSelf.resultLabel.balance = @(model.mA_AvailableBalance).stringValue;
            weakSelf.resultLabel.integral = @(model.mA_AvailableIntegral).stringValue;
            // titleView hidden
        };
    }
    return _vipSelect;
}

- (void)selectVip {
    
    [self.navigationController pushViewController:self.vipSelect animated:YES];
}

- (UIButton *)buttonWithName:(NSString *)name action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:name forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:26];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

- (UIButton *)delButton {
    if (!_delButton) {
        [self.view addSubview:self.delButton = [self buttonWithName:@"" action:@selector(del)]];
        [self.delButton setImage:[UIImage imageNamed:@"receiptsQuick_num_del"] forState:(UIControlStateNormal)];
    }
    return _delButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        [self.view addSubview:self.addButton = [self buttonWithName:@"" action:@selector(add)]];
        [self.addButton setImage:[UIImage imageNamed:@"receiptsQuick_num_add"] forState:(UIControlStateNormal)];
    }
    return _addButton;
}

- (UIButton *)equalButton {
    if (!_equalButton) {
        NSString *title = @"结账";
        if (self.isReceipts) {
            title = @"收款";
        }
        [self.view addSubview:self.equalButton = [self buttonWithName:title action:@selector(equal)]];
        self.equalButton.backgroundColor = RGBColor(252, 105, 67);
        [self.equalButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _equalButton;
}

- (UIButton *)pointButton {
    if (!_pointButton) {
        [self.view addSubview:self.pointButton = [self buttonWithName:@"." action:@selector(point)]];
    }
    return _pointButton;
}

- (UIButton *)zeroButton {
    if (!_zeroButton) {
        [self.view addSubview:self.zeroButton = [self buttonWithName:@"0" action:@selector(zero)]];
    }
    return _zeroButton;
}

- (UIButton *)oneButton {
    if (!_oneButton) {
        [self.view addSubview:self.oneButton = [self buttonWithName:@"1" action:@selector(one)]];
    }
    return _oneButton;
}

- (UIButton *)twoButton {
    if (!_twoButton) {
        [self.view addSubview:self.twoButton = [self buttonWithName:@"2" action:@selector(two)]];
    }
    return _twoButton;
}

- (UIButton *)threeButton {
    if (!_threeButton) {
        [self.view addSubview:self.threeButton = [self buttonWithName:@"3" action:@selector(three)]];
    }
    return _threeButton;
}


- (UIButton *)fourButton {
    if (!_fourButton) {
        [self.view addSubview:self.fourButton = [self buttonWithName:@"4" action:@selector(four)]];
    }
    return _fourButton;
}

- (UIButton *)fiveButton {
    if (!_fiveButton) {
        [self.view addSubview:self.fiveButton = [self buttonWithName:@"5" action:@selector(five)]];
    }
    return _fiveButton;
}

- (UIButton *)sixButton {
    if (!_sixButton) {
        [self.view addSubview:self.sixButton = [self buttonWithName:@"6" action:@selector(six)]];
    }
    return _sixButton;
}

- (UIButton *)sevenButton {
    if (!_sevenButton) {
        [self.view addSubview:self.sevenButton = [self buttonWithName:@"7" action:@selector(seven)]];
    }
    return _sevenButton;
}

- (UIButton *)eightButton {
    if (!_eightButton) {
        [self.view addSubview:self.eightButton = [self buttonWithName:@"8" action:@selector(eight)]];
    }
    return _eightButton;
}

- (UIButton *)nineButton {
    if (!_nineButton) {
        [self.view addSubview:self.nineButton = [self buttonWithName:@"9" action:@selector(nine)]];
    }
    return _nineButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    __weak typeof(self) weakSelf = self;
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.height.equalTo(weakSelf.view).multipliedBy(.53);
    }];
    
    [self.sevenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(1.5);
        make.top.equalTo(weakSelf.resultLabel.mas_bottom).offset(1.5);
    }];
    
    [self.eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_top);
        make.left.equalTo(weakSelf.sevenButton.mas_right).offset(.5);
        make.bottom.equalTo(weakSelf.sevenButton.mas_bottom);
        make.width.equalTo(weakSelf.sevenButton.mas_width);
    }];
    
    [self.nineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_top);
        make.bottom.equalTo(weakSelf.sevenButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_right).offset(.5);
        make.width.equalTo(weakSelf.sevenButton.mas_width);
        
    }];
    
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.sevenButton.mas_width);
        make.left.equalTo(weakSelf.nineButton.mas_right).offset(.5);
        make.right.equalTo(weakSelf.view.mas_right).offset(-1.5);
        make.bottom.equalTo(weakSelf.sevenButton.mas_bottom);
        make.top.equalTo(weakSelf.sevenButton.mas_top);
    }];
    
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sevenButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.sevenButton.mas_left);
        make.right.equalTo(weakSelf.sevenButton.mas_right);
        make.height.equalTo(weakSelf.sevenButton.mas_height);
    }];
    
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fourButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.fourButton.mas_left);
        make.right.equalTo(weakSelf.fourButton.mas_right);
        make.height.equalTo(weakSelf.fourButton.mas_height);
    }];
    
    [self.zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_bottom).offset(.5);
        make.left.equalTo(weakSelf.sevenButton.mas_left);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-1.5);
        make.height.equalTo(weakSelf.fourButton.mas_height);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fourButton.mas_top);
        make.left.equalTo(weakSelf.delButton.mas_left);
        make.right.equalTo(weakSelf.delButton.mas_right);
        make.bottom.equalTo(weakSelf.fourButton.mas_bottom);
    }];
    
    [self.equalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_top);
        make.left.equalTo(weakSelf.addButton.mas_left);
        make.right.equalTo(weakSelf.addButton.mas_right);
        make.bottom.equalTo(weakSelf.zeroButton.mas_bottom);
    }];
    
    [self.pointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.zeroButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.equalButton.mas_bottom);
    }];
    
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_top);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.oneButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_left);
    }];
    
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oneButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.oneButton.mas_bottom);
    }];
    
    [self.fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addButton.mas_top);
        make.right.equalTo(weakSelf.eightButton.mas_right);
        make.bottom.equalTo(weakSelf.addButton.mas_bottom);
        make.left.equalTo(weakSelf.eightButton.mas_left);
    }];
    
    [self.sixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addButton.mas_top);
        make.right.equalTo(weakSelf.nineButton.mas_right);
        make.left.equalTo(weakSelf.nineButton.mas_left);
        make.bottom.equalTo(weakSelf.addButton.mas_bottom);
    }];

}

- (NSString *)lastString {
    return [self.resultLabel.string componentsSeparatedByString:@"+"].lastObject;
}

- (void)zero {
    if ([self.lastString isEqualToString:@"0"]) return;
    [self appendNumber:@"0"];
}

- (void)one {
    [self appendNumber:@"1"];
}

- (void)two {
    [self appendNumber:@"2"];
}

- (void)three {
    [self appendNumber:@"3"];
}

- (void)four {
    [self appendNumber:@"4"];
}

- (void)five {
    [self appendNumber:@"5"];
}

- (void)six {
    [self appendNumber:@"6"];
}

- (void)seven {
    [self appendNumber:@"7"];
}

- (void)eight {
    [self appendNumber:@"8"];
}

- (void)nine {
    [self appendNumber:@"9"];
}

- (void)point {
    if ([self.lastString containsString:@"."]) return;
    [self appendNumber:@"."];
}

#pragma mark - +

- (void)del {
    if (self.resultLabel.string.length) {
        self.resultLabel.string = [self.resultLabel.string substringToIndex:self.resultLabel.string.length-1];
        [self equalAction];
    }
}

- (void)add {
    [self equalAction];
    if (self.resultLabel.string.integerValue && self.lastString.length) {
        self.resultLabel.string = [self.resultLabel.string stringByAppendingString:@"+"];
    }
}

- (void)equalAction {
    NSArray *array = [self.resultLabel.string componentsSeparatedByString:@"+"];
    CGFloat result = 0;
    for (NSString *str in array) {
        result += str.floatValue;
    }
    self.resultLabel.text = [NSString stringWithFormat:@"%.2f", result];
}

#pragma mark - =
- (void)equal {
    if (!self.resultLabel.text.floatValue) {
        [XYProgressHUD showMessage:@"请输入消费金额"];
        return;
        
    }
    
    if (self.isReceipts) {
        // 快捷收款
//        api/ConsumeOrder/SubmitFastReceipt
        
//        XYPaymentView *payView = [[XYPaymentView alloc] initWithTitlePrice:self.resultLabel.text];
//        payView.isReceipts = self.isReceipts;
//
//        payView.submitOrderUrl =@"api/ConsumeOrder/SubmitFastReceipt";
//        payView.payUrl = @"api/ConsumeOrder/PaymentFastReceipt";
//        [self presentViewController:payView animated:YES completion:nil];
        NSString *VIP_Card = @"00000";
        NSString *price = [@"￥" stringByAppendingString:self.resultLabel.text];
        NSString *priceValue = @"不打折";
        if (self.model) {
            VIP_Card = self.model.vCH_Card;
            if (self.model.dS_Value < 1) {
                price = [NSString stringWithFormat:@"￥%.2lf",self.resultLabel.text.floatValue *self.model.dS_Value];
                priceValue = [NSString stringWithFormat:@"%.1lf折",10 *self.model.dS_Value];
            }
        }
        NSDictionary *parameters = @{@"CO_Monetary":self.resultLabel.text, @"VIP_Card":VIP_Card};
        
        [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"消费金额:", @"detail":[@"￥" stringByAppendingString: self.resultLabel.text]}];
        [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"会员折扣:", @"detail":priceValue}];
        [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"折后金额:", @"detail":price}];
        WeakSelf;
        [AFNetworkManager postNetworkWithUrl:@"api/ConsumeOrder/SubmitFastReceipt" parameters:parameters succeed:^(NSDictionary *dic) {
            if ([dic[@"success"] boolValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([LoginModel shareLoginModel].printSetModel.pS_IsEnabled || ![LoginModel shareLoginModel].printSetModel) {
                        [XYPrinterMaker sharedMaker].isPrint = YES;
                    }
                    XYPaymentView *payView = [[XYPaymentView alloc] initWithTitlePrice:self.resultLabel.text];
                    payView.isReceipts = self.isReceipts;
                    payView.payUrl = @"api/ConsumeOrder/PaymentFastReceipt";
                    /*
                     OrderGID    订单GID    Bool    否    0-100
                     IS_Sms    是否发送短信    string    是    0-500
                     */
                    payView.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(0), @"PayResult":@""}.mutableCopy;
                    [weakSelf presentViewController:payView animated:YES completion:nil];
                });
            }
        } failure:^(NSError *error) {
            
        } showMsg:YES];
    } else {
        XYConfirmPayController *payVc = [[XYConfirmPayController alloc] init];
        payVc.isReceipts = self.isReceipts;
        payVc.priceString = self.resultLabel.text;
        [self.navigationController pushViewController:payVc animated:YES];
    }
}

#pragma mark - 添加数字
- (void)appendNumber:(NSString *)number
{
    if ([self.lastString isEqualToString:@"0"] && ![number isEqualToString:@"."]) {
        self.resultLabel.string = [self.resultLabel.string substringToIndex:self.resultLabel.string.length-1];
    }
//    if (self.resultLabel.text.length > (11 - 1)) return;
    NSLog(@"%@", self.resultLabel.text);

    NSString *string = [self.resultLabel.string stringByAppendingString:number];
    self.resultLabel.string = string;
    [self equalAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
