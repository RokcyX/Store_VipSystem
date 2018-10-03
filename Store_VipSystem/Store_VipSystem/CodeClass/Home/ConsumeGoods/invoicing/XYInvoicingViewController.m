//
//  XYInvoicingViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYInvoicingViewController.h"
#import "XYReceivablesFootView.h"
#import "XYVipSelectionController.h"
#import "XYConfirmPayCell.h"
#import "XYInvoicingGoodsCell.h"
#import "XYInvoicingGoodsFooterView.h"

#import "XYSpecialOffersController.h"
#import "XYStaffManageController.h"
#import "XYJointPaymentController.h"

@interface XYInvoicingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYReceivablesFootView *footView;

@property (nonatomic, strong) XYVipSelectionController *vipSelect;

@property (nonatomic, strong)XYMemberManageModel *vipModel;
@property (nonatomic, strong)XYRechargeModel *rechargeModel;

@property (nonatomic, strong) XYStaffManageController *staff;
@property (nonatomic, weak)XYVipCheckControl *check;

@property (nonatomic, assign)CGFloat totalAmount;

@property (nonatomic, assign)CGFloat vipPrice;
@property (nonatomic, assign)CGFloat vipNum;

@property (nonatomic, assign)BOOL isOpen;


@property (nonatomic, strong)NSMutableArray *datalist;

@property (nonatomic, copy)NSString *priceString;

@end

@implementation XYInvoicingViewController

- (NSString *)priceString {
    if (!_priceString) {
        CGFloat amount = 0.00;
        for (XYCommodityModel *obj in self.goodslist) {
            amount += (obj.count * obj.pM_UnitPrice);
        }
        _priceString = [NSString stringWithFormat:@"%.2lf", amount];
    }
    return _priceString;
}

- (void)loadData {
    self.vipPrice = self.priceString.floatValue;
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ConfirmPay" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    if (self.isConsume) {
        self.datalist = [XYConfirmPayModel modelConfigureWithArray:parseDic[@"consume"] priceString:self.priceString];
    } else {
        self.datalist = [XYConfirmPayModel modelConfigureWithArray:parseDic[@"punching"] priceString:self.priceString];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付确认";
    self.isOpen = YES;
    [self loadData];
    [self setNaviUI];
    [self setupUI];
    
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
        self.check.title = nil;
        btn.selected = NO;
        self.vipModel = nil;
    } else {
        [self selectVip];
    }
}

- (void)setVipModel:(XYMemberManageModel *)vipModel {
    _vipModel = vipModel;
    self.rechargeModel = nil;
    self.vipPrice = self.priceString.floatValue;
    self.vipNum = 0;
    
    
    // 折后金额
    XYConfirmPayModel *priceModel = self.datalist[self.datalist.count-3];
    priceModel.detail = self.priceString;
    self.footView.priceString = priceModel.detail;
    // 优惠活动
    if (self.isConsume) {
        XYConfirmPayModel *offersModel = self.datalist[3];
        offersModel.detail = @"";
        offersModel.updateValue = @"";
        offersModel.updateValue = priceModel.detail;
    }
    // 获得积分
    XYConfirmPayModel *numModel = self.datalist[self.datalist.count-2];
    numModel.detail = @"0";
    
    if (vipModel) {
        if (vipModel.dS_Value) {
            self.vipPrice = self.priceString.floatValue *vipModel.dS_Value;
            priceModel.detail = [NSString stringWithFormat:@"%.2lf",self.vipPrice];
            self.footView.priceString = priceModel.detail;
        }
        if (vipModel.vS_Value) {
            self.vipNum = @(self.priceString.floatValue *vipModel.vS_Value).integerValue;
            numModel.detail = @(self.vipNum).stringValue;
        }
    }
    [self.tableView reloadData];
    
}

- (void)setRechargeModel:(XYRechargeModel *)rechargeModel {
    _rechargeModel = rechargeModel;
    // 折后金额
    XYConfirmPayModel *priceModel = self.datalist[self.datalist.count-3];
    // 获得积分
    XYConfirmPayModel *numModel = self.datalist[self.datalist.count-2];
    if (rechargeModel) {
        if (priceModel.detail.floatValue > rechargeModel.rP_RechargeMoney) {
            numModel.detail = @(self.vipNum + rechargeModel.rP_GivePoint).stringValue;
            if (rechargeModel.rP_Discount) {
                //                优惠
                priceModel.detail = [NSString stringWithFormat:@"%.2lf", self.vipPrice *(rechargeModel.rP_Discount/10)];
                self.footView.priceString = priceModel.detail;

            } else if (rechargeModel.rP_GiveMoney) {
                //                赠送
            } else if (rechargeModel.rP_ReduceMoney) {
                //                减少
                priceModel.detail = [NSString stringWithFormat:@"%.2lf",self.vipPrice -rechargeModel.rP_ReduceMoney];
                self.footView.priceString = priceModel.detail;
            }
        }
        [self.tableView reloadData];
    }
}

- (XYVipSelectionController *)vipSelect {
    if (!_vipSelect) {
        _vipSelect = [[XYVipSelectionController alloc] init];
        WeakSelf;
        _vipSelect.selectModel = ^(XYMemberManageModel *model) {
            weakSelf.vipModel = model;
            weakSelf.check.title = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
            weakSelf.check.screenView.selected = YES;
            //            DS_Value    快速消费折扣比例
            //            VS_Value    快速消费积分比例
            
            // titleView hidden
        };
    }
    return _vipSelect;
}

- (void)selectVip {
    
    [self.navigationController pushViewController:self.vipSelect animated:YES];
}


- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerClass:[XYConfirmPayCell class] forCellReuseIdentifier:@"XYConfirmPayCell"];
    [tableView registerClass:[XYInvoicingGoodsCell class] forCellReuseIdentifier:@"XYInvoicingGoodsCell"];
    [tableView registerClass:[XYInvoicingGoodsFooterView class] forHeaderFooterViewReuseIdentifier:@"XYInvoicingGoodsFooterView"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView = tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
    }];
    
    XYReceivablesFootView *footView = [[XYReceivablesFootView alloc] init];
    footView.priceString = self.priceString;
    footView.receivablesPrice = ^(BOOL msg, BOOL print) {
        [weakSelf placeOrderWithMsg:msg print:print];
    };
    [self.view addSubview:self.footView = footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.view);
        make.top.equalTo(tableView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
}

- (void)placeOrderWithMsg:(BOOL)msg print:(BOOL)print {
    [super placeOrderWithMsg:msg print:print];

    NSString *submitOrderUrl; // 提交订单url
    NSString *payUrl; // 支付Url
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 折后 model
    XYConfirmPayModel *model = self.datalist[self.datalist.count - 3];
    // 提成员工 model
    XYConfirmPayModel *empModel = self.datalist.lastObject;
    if (self.isConsume) {
        /*
         名称：    提交订单    地址：    /api/ConsumeOrder/SubmitConsumOrder
         输入参数：
         参数Code    参数名称    数据类型    可否为空    长度范围    备注
         CO_OrderCode    订单编号    String    否    0-100
         OrderTime    订单时间    string    是    0-500
         VIP_Card    会员卡号    string    否    0-100
         CC_GID    优惠活动GID    string    是    0-100
         Goods    商品信息    List<GoodsOrderList>    是    0-10000
         CO_Remark    备注    string    是    0-500
         isGuadan    是否挂单    bool    是    0-100
         */
        
        [parameters setValue:@"SP".orderCode forKey:@"CO_OrderCode"];
        [parameters setValue:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"] forKey:@"OrderTime"];
        [parameters setValue:@"00000" forKey:@"VIP_Card"];
        if (self.vipModel) {
            [parameters setValue:self.vipModel.vCH_Card forKey:@"VIP_Card"];
        }
        for (XYConfirmPayModel *model in self.datalist) {
            if ([model.modelKey isEqualToString:@"CC_GID"]) {
                [parameters setValue:model.updateValue forKey:model.modelKey];
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (XYCommodityModel *obj in self.goodslist) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:obj.gID forKey:@"PM_GID"];
            [dic setValue:@(obj.count) forKey:@"PM_Number"];
            [dic setValue:@(obj.pM_UnitPrice *(model.detail.floatValue / self.totalAmount)) forKey:@"PM_Money"];
            if (empModel.updateValue.length) {
                [dic setValue:[empModel.updateValue componentsSeparatedByString:@","] forKey:@"EM_GIDList"];
            }
            [dic setValue:@0 forKey:@"Type"];
            [array addObject:dic];
        }
        [parameters setValue:array forKey:@"Goods"];
        [parameters setValue:@"" forKey:@"CO_Remark"];
        
        submitOrderUrl = @"api/ConsumeOrder/SubmitConsumOrder";
        payUrl = @"api/ConsumeOrder/PaymentConsumOrder";
    } else {
        /*
         名称：    提交订单    地址：    /api/Charge/ SubmitChargeBatch
         输入参数：
         参数Code    参数名称    数据类型    可否为空    长度范围    备注
         MC_Order    充次订单    string    否    0-100
         VIP_Card    会员卡号    string    否    0-100
         MC_Remark    备注    string    是    0-500
         ServeceList    项目明细    List<GoodsOrderList>    是    0-500
         AfterDiscount    折后金额    decimal?    否    0-100
         OrderTime    订单时间    string    是    0-500
         */
        [parameters setValue:@"CC".orderCode forKey:@"MC_Order"];
        [parameters setValue:self.vipModel.vCH_Card forKey:@"VIP_Card"];
        [parameters setValue:@"" forKey:@"MC_Remark"];
        [parameters setValue:model.detail forKey:@"AfterDiscount"];
        [parameters setValue:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"] forKey:@"OrderTime"];
        
        /*
         PM_GID    商品GID    String
         PM_Number    商品数量    decimal
         PM_Money    折后金额（小计）    decimal?
         EM_GIDList    提成员工    List<string>
         Type    类型    int    0普通，1套餐
         */
        NSMutableArray *array = [NSMutableArray array];
        for (XYCommodityModel *obj in self.goodslist) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:obj.gID forKey:@"PM_GID"];
            [dic setValue:@(obj.count) forKey:@"PM_Number"];
            [dic setValue:@(obj.pM_UnitPrice*obj.count *(model.detail.floatValue / self.totalAmount)) forKey:@"PM_Money"];
            if (empModel.updateValue.length) {
                [dic setValue:[empModel.updateValue componentsSeparatedByString:@","] forKey:@"EM_GIDList"];
            }
            [dic setValue:@0 forKey:@"Type"];
            [array addObject:dic];
        }
        [parameters setValue:array forKey:@"ServeceList"];
        submitOrderUrl = @"api/Charge/SubmitChargeBatch";
        payUrl = @"api/Charge/PaymentConsumOrder";
        
    }
    [[XYPrinterMaker sharedMaker].bodylist addObject:@[@"商品", @"单价", @"数量", @"折扣", @"小计"]];
    for (XYCommodityModel *obj in self.goodslist) {
//        if () {
//            <#statements#>
//        }
//        obj.pM_IsDiscount          商品折扣开关  1开 0关
//        obj.pM_SpecialOfferValue   特价折扣开关的值
//        obj.pM_MinDisCountValue    最低折扣开关的值
//        obj.pM_MemPrice            会员价格
        
        
        [[XYPrinterMaker sharedMaker].bodylist addObject:@[obj.pM_Name, [NSString stringWithFormat:@"%.2lf", obj.pM_UnitPrice], @(obj.count).stringValue, @"无", [NSString stringWithFormat:@"%.2lf", obj.pM_UnitPrice*obj.count *(model.detail.floatValue / self.totalAmount)]]];
    }
    
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:submitOrderUrl parameters:parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                XYPaymentView *payView = [[XYPaymentView alloc] initWithTitlePrice:self.footView.priceString];
                payView.payUrl = payUrl;
                /*
                OrderGID    订单GID    Bool    否    0-100
                IS_Sms    是否发送短信    string    是    0-500
                */
                payView.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(msg), @"PayResult":@""}.mutableCopy;
                payView.jointPayBlock = ^{
                    XYJointPaymentController *jointVc = [[XYJointPaymentController alloc] init];
                    jointVc.priceString = weakSelf.footView.priceString;
                    jointVc.payUrl = payUrl;
                    /*
                     OrderGID    订单GID    Bool    否    0-100
                     IS_Sms    是否发送短信    string    是    0-500
                     */
                    jointVc.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(msg), @"PayResult":@""}.mutableCopy;
                    [weakSelf.navigationController pushViewController:jointVc animated:YES];
                    jointVc.paySuccessBlock = ^(NSData *printData) {
                        if (print) {
                            [[SEPrinterManager sharedInstance] sendPrintData:printData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                                NSLog(@"写入结：%d---错误:%@",completion,error);
                                if (!completion) {
                                    [XYProgressHUD showMessage:error];
                                }
                            }];
                        }
                    };
                };
                
                payView.paySuccessBlock = ^(NSData *printData) {
                    if (print) {
                        [[SEPrinterManager sharedInstance] sendPrintData:printData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                            NSLog(@"写入结：%d---错误:%@",completion,error);
                            if (!completion) {
                                [XYProgressHUD showMessage:error];
                            }
                        }];
                    }
                };
                [weakSelf presentViewController:payView animated:YES completion:nil];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
    
    
    
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.datalist.count;
    } else {
        if (self.isOpen) {
            return self.goodslist.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        XYConfirmPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYConfirmPayCell" forIndexPath:indexPath];
        XYConfirmPayModel *model = self.datalist[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    XYInvoicingGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYInvoicingGoodsCell" forIndexPath:indexPath];
    XYCommodityModel *model = self.goodslist[indexPath.row];
    cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section) {
        return @"   ";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 50;
    }
    return  70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section) {
        return nil;
    }
    XYInvoicingGoodsFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XYInvoicingGoodsFooterView"];
    footView.isOpen = self.isOpen;
    footView.attributedStr = self.sectionStr;
    WeakSelf;
    footView.openGoodsView = ^(BOOL isOpen) {
        weakSelf.isOpen = isOpen;
        [tableView reloadData];
    };
    return footView;
}

- (NSMutableAttributedString *)sectionStr {
    NSInteger count = 0;
    self.totalAmount = 0.00;
    for (XYCommodityModel *obj in self.goodslist) {
        count += obj.count;
        self.totalAmount += (obj.count * obj.pM_UnitPrice);
    }
    NSString *string = [NSString stringWithFormat:@"共%ld件商品，本单合计¥%.2lf",count, self.totalAmount];
    NSString *amountStr = [NSString stringWithFormat:@"¥%.2lf", self.totalAmount];
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(string.length - amountStr.length, amountStr.length)];
    
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(string.length - amountStr.length, amountStr.length)];
    return attributedStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        return 0;
    }
    if (!self.isOpen) {
        return 50;
    }
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return;
    }
    XYConfirmPayModel *model = self.datalist[indexPath.row];
    
    if (!model.rightMode && !model.isWritable && model.enabled) {
        [XYProgressHUD showMessage:[model.title stringByAppendingString:@"未开启，请通过系统管理-参数设置开启"]];
        return;
    }
    
    if (model.rightMode && !model.isWritable && !model.enabled) {
        [XYProgressHUD showMessage:[model.title stringByAppendingString:@"未开启，请通过系统管理-参数设置开启"]];
        return;
    }
    WeakSelf;
    if ([model.title isEqualToString:@"优惠活动："]) {
        XYSpecialOffersController *offers = [[XYSpecialOffersController alloc] init];
        offers.selectViewModel = ^(XYRechargeModel *obj) {
            model.detail = obj.rP_Name;
            model.updateValue = obj.gID;
            weakSelf.rechargeModel = obj;
        };
        [self.navigationController pushViewController:offers animated:YES];
    }
    
    if ([model.title isEqualToString:@"员工提成"]) {
        self.staff.selectViewModel = ^(NSArray *models) {
            NSMutableArray *names = [NSMutableArray array];
            NSMutableArray *gids = [NSMutableArray array];
            for (XYEmplModel *obj in models) {
                [names addObject:obj.eM_Name];
                [gids addObject:obj.gID];
            }
            model.detail = [names componentsJoinedByString:@","];
            model.updateValue = [gids componentsJoinedByString:@","];
            if (!models.count) {
                model.updateValue = model.detail = @"";
            }
            [tableView reloadData];
        };
        [self.navigationController pushViewController:self.staff animated:YES];
    }
}

- (XYStaffManageController *)staff {
    if (!_staff) {
        _staff = [[XYStaffManageController alloc] init];
    }
    return _staff;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
