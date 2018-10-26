//
//  SLAlertController.m
//  washsystem
//
//  Created by Wcaulpl on 2017/6/7.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import "XYPaymentView.h"
#import "XYHomeFuncView.h"

@interface XYPaymentView ()

@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, weak) UIView *lineView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) UIButton *defineButton;

@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYPaymentView

- (UIView *)alertView {
    if (!_alertView) {
        UIView *alertView = [[UIView alloc] init];
        alertView.backgroundColor = [UIColor whiteColor];
//        alertView.layer.cornerRadius = 6;
        alertView.userInteractionEnabled = YES;
        alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView=alertView];
    }
    return _alertView;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1];
        [self.alertView addSubview:self.lineView=lineView];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self.alertView addSubview:self.titleLabel=titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.backgroundColor = [UIColor whiteColor];
//        cancleBtn.layer.cornerRadius = 8;
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        cancleBtn.tag = 100;
        [cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancelButton = cancleBtn];
    }
    return _cancelButton;
}

- (UIButton *)defineButton {
    if (_defineButton == nil) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = [UIColor whiteColor];
        //        sureBtn.layer.cornerRadius = 8;
        [sureBtn setTitleColor:RGBColor(59, 171, 250) forState:(UIControlStateNormal)];
        [sureBtn setImage:[UIImage imageNamed:@"vip_basicInfo_right"] forState:UIControlStateNormal];
        [sureBtn setTitle:@"联合支付" forState:UIControlStateNormal];
        [sureBtn setImageEdgeInsets:UIEdgeInsetsMake(0, sureBtn.titleLabel.calculateWidth +20, 0, -20-sureBtn.titleLabel.calculateWidth)];
        sureBtn.tag = 99;
        [sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.defineButton=sureBtn];
    }
    return _defineButton;
}

- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 100) {
        // 取消
        [self dismissView];
    } else if (sender.tag == 99) {
        // 联合支付
        [self dismissView];
        if (self.jointPayBlock) {
            self.jointPayBlock();
        }
    } else {
        BOOL canPay = NO;
        NSString *btnStr = [_datalist[sender.tag -101] stringWithCode];
        if ([btnStr isEqualToString:@"余额支付"]) {
            if ([self.payUrl isEqualToString:@"api/Recharge/PaymentRecharge"]) {
                [XYProgressHUD showMessage:@"会员充值不能使用余额支付"];
                return;
            }
            
            if (self.balance < self.priceString.floatValue) {
                [XYProgressHUD showMessage:@"余额不足"];
                return;
            }
        }
        
        for (XYParameterSetModel *obj in [LoginModel shareLoginModel].parameterSets.firstObject[@"models"]) {
            if ([obj.title isEqualToString:btnStr]) {
                canPay = obj.sS_State;
            }
        }
        if (canPay) {
            [self payOrderWithPayCode:self.datalist[sender.tag-101]];
        } else {
            [XYProgressHUD showMessage:[btnStr stringByAppendingString:@"未开启，请通过系统管理-参数设置开启"]];
        }
    }
}

- (void)payOrderWithPayCode:(NSString *)payCode {
    /*
     PayResult    收银台信息    OrderPayResult    否    0-100
     
     名称：收银台返回信息    OrderPayResult
     参数Code    参数名称    数据类型    备注
     PayTypeList     支付方式    List<PayType>
     GiveChange    找零金额    decimal
     PayTotalMoney     实收金额    decimal
     DisMoney    应收金额    decimal
     
     名称：支付方式    PayType
     参数Code    参数名称    数据类型    备注
     PayCode     编码    String
     PayName    名称    string
     PayMoney     金额    decimal?
     PayPoint    抵扣积分    decimal?
     GID     优惠券关系表GID    string

     */
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"DisMoney":_priceString, @"PayTotalMoney":_priceString, @"GiveChange":@0}];
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dics = @{@"PayCode":payCode, @"PayName":payCode.stringWithCode, @"PayMoney":_priceString, @"PayPoint":@0};
    [array addObject:dics];
    [dict setValue:array forKey:@"PayTypeList"];
    [self.parameters setValue:dict forKey:@"PayResult"];
    
    // print 参数
    NSMutableArray *strlist = [NSMutableArray array];
    for (NSDictionary *strDic in array) {
        [strlist addObject:[NSString stringWithFormat:@"%@(%@)", strDic[@"PayName"], strDic[@"PayMoney"]]];
    }
    NSString *print = [strlist componentsJoinedByString:@","];//

    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"应    收:", @"detail":[@"￥" stringByAppendingString:_priceString]}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"实    收:", @"detail":[@"￥" stringByAppendingString: _priceString]}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"支付详情:", @"detail":print}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"找    零:", @"detail":@"￥0.00"}];
    
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:self.payUrl parameters:self.parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            [XYPrinterMaker sharedMaker].header.name = dic[@"data"][@"MR_Creator"];
            [XYPrinterMaker sharedMaker].header.date = dic[@"data"][@"MR_PrepaidTime"];
            [XYPrinterMaker sharedMaker].header.order = dic[@"data"][@"MR_Order"];
            if (![XYPrinterMaker sharedMaker].header.name.length) {
                [XYPrinterMaker sharedMaker].header.name = dic[@"data"][@"CO_Creator"];
                [XYPrinterMaker sharedMaker].header.date = dic[@"data"][@"CO_UpdateTime"];
                [XYPrinterMaker sharedMaker].header.order = dic[@"data"][@"CO_OrderCode"];
                if (![XYPrinterMaker sharedMaker].header.name.length) {
                    [XYPrinterMaker sharedMaker].header.name = dic[@"data"][@"MC_Creator"];
                    [XYPrinterMaker sharedMaker].header.date = dic[@"data"][@"MC_UpdateTime"];
                    [XYPrinterMaker sharedMaker].header.order = dic[@"data"][@"MC_Order"];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:.1 animations:^{
                    weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0];
                } completion:^(BOOL finished) {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [XYPrinterMaker print];
                    }];
                }];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}



- (instancetype)initWithTitlePrice:(NSString *)price {
    if (self = [super init]) {
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.priceString = price;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[@"收款：" stringByAppendingString:self.priceString]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(3, self.priceString.length)];

    self.titleLabel.attributedText = attributedStr;
}

- (NSArray *)datalist {
    if (!_datalist) {
        _datalist = @[@"XJZF",@"YEZF",@"YLZF",@"WXJZ",@"ZFBJZ"];
    }
    return _datalist;
}

- (void)setupUI {
    WeakSelf;
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.alertView).offset(-20);
        make.top.equalTo(weakSelf.alertView);
        make.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.cancelButton.mas_centerY);
        make.left.equalTo(weakSelf.alertView.mas_left).offset(20);
    }];
    
//    UIView *backView = UIView.new;
//    [self.alertView addSubview:backView];
//    backView mas_m
//    frame = CGRectMake(0, 0, ScreenWidth, );
    for (int i = 0; i < self.datalist.count; i++) {
        XYHomeFuncView *funcView = [[XYHomeFuncView alloc] initWithFrame:CGRectMake(10 + ((ScreenWidth - 50)/4 + 10)*(i%4), 50 + 90 * (i/4), (ScreenWidth - 50)/4, 80)];
        funcView.iconView.image = [UIImage imageNamed:[@"payment_" stringByAppendingString:self.datalist[i]]];
//        funcView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        funcView.titleLabel.font = [UIFont systemFontOfSize:14];
        funcView.titleLabel.text = [self.datalist[i] stringWithCode];
        [self.alertView addSubview:funcView];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(10 + ((ScreenWidth - 50)/4 + 10)*(i%4), 50 + 90 * (i/4), (ScreenWidth - 50)/4, 80);
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = 101+i;
        [self.alertView addSubview:button];
    }
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cancelButton.mas_bottom).offset((self.datalist.count /4 +  (self.datalist.count % 4 ? 1:0)) * 90 + 10);
        make.left.equalTo(weakSelf.alertView.mas_left);
        make.right.equalTo(weakSelf.alertView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat height = 0;
    self.defineButton.hidden = YES;
    if (!weakSelf.isReceipts) {
        height = 50;
        self.defineButton.hidden = NO;
    }
    [self.defineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.left.equalTo(weakSelf.alertView.mas_left);
        make.right.equalTo(weakSelf.alertView.mas_right);
        make.height.mas_equalTo(height);
        make.bottom.equalTo(weakSelf.alertView.mas_bottom);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WeakSelf;
    [UIView animateWithDuration:.1 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.5];
    }];

}

- (void)dismissView {
    WeakSelf;
    [UIView animateWithDuration:.1 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0];
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissView];
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
