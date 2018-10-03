//
//  XYConfirmPayController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/17.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYConfirmPayController.h"
#import "XYReceivablesFootView.h"
#import "XYVipSelectionController.h"
#import "XYConfirmPayCell.h"

#import "XYSpecialOffersController.h"
#import "XYStaffManageController.h"
#import "XYJointPaymentController.h"

@interface XYConfirmPayController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYReceivablesFootView *footView;

@property (nonatomic, strong) XYVipSelectionController *vipSelect;

@property (nonatomic, strong)XYMemberManageModel *vipModel;
@property (nonatomic, strong)XYRechargeModel *rechargeModel;

@property (nonatomic, strong) XYStaffManageController *staff;
@property (nonatomic, strong)XYEmplModel *empModel;

@property (nonatomic, weak)XYVipCheckControl *check;

@property (nonatomic, assign)CGFloat vipPrice;
@property (nonatomic, assign)CGFloat vipNum;

@property (nonatomic, strong)NSArray *datalist;
@end

@implementation XYConfirmPayController

- (void)loadData {
    self.vipPrice = self.priceString.floatValue;
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ConfirmPay" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.datalist = [XYConfirmPayModel modelConfigureWithArray:parseDic[@"data"] priceString:self.priceString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付确认";
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
    XYConfirmPayModel *offersModel = self.datalist[3];
    offersModel.detail = @"";
    offersModel.updateValue = @"";
    XYConfirmPayModel *priceModel = self.datalist[4];
    offersModel.updateValue = priceModel.detail = self.priceString;
    XYConfirmPayModel *numModel = self.datalist[5];
    numModel.detail = @"0";

    if (vipModel) {
        XYConfirmPayModel *priceModel = self.datalist[4];
        XYConfirmPayModel *numModel = self.datalist[5];
        if (vipModel.dS_Value) {
            self.vipPrice = self.priceString.floatValue *vipModel.dS_Value;
            priceModel.detail = [NSString stringWithFormat:@"%.2lf",self.vipPrice];
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
    XYConfirmPayModel *priceModel = self.datalist[4];
    XYConfirmPayModel *numModel = self.datalist[5];
    if (rechargeModel) {
        if (priceModel.detail.floatValue > rechargeModel.rP_RechargeMoney) {
            numModel.detail = @(self.vipNum + rechargeModel.rP_GivePoint).stringValue;
            if (rechargeModel.rP_Discount) {
                //                优惠
                priceModel.detail = [NSString stringWithFormat:@"%.2lf", self.vipPrice *(rechargeModel.rP_Discount/10)];
                
            } else if (rechargeModel.rP_GiveMoney) {
                //                赠送
            } else if (rechargeModel.rP_ReduceMoney) {
                //                减少
                priceModel.detail = [NSString stringWithFormat:@"%.2lf",self.vipPrice -rechargeModel.rP_ReduceMoney];
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
    /*
     名称：    提交订单    地址：    /API/ConsumeOrder/SubmitCelerityOrder
     输入参数：
     参数Code    参数名称    数据类型    可否为空    长度范围    备注
     CO_Monetary    消费金额    decimal?    否    0-100
     CC_GID    优惠活动GID    string    是    0-100
     ActivityValue    优惠金额    string    是    0-100
     DisMoney    折后金额/应付金额    decimal    否    0-100
     EM_GIDList    提成员工    List<string>    是    0-1000
     VIP_Card    会员卡号    string    否    0-100
     CO_OrderCode    订单编号    string    否    0-100
     CO_Remark    备注    string    是    0-500
     OrderType    消费类型    int    否    0-1    （1会员消费2散客消费）
     OrderTime    订单时间    string    是    0-500
     CO_TotalPrice    订单金额    decimal?    否    0-500
     */
    
    //
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (XYConfirmPayModel *model in self.datalist) {
        if (model.modelKey) {
            [parameters setValue:model.updateValue forKey:model.modelKey];
        }
    }
    if (![parameters[@"EM_GIDList"] length]) {
        [parameters removeObjectForKey:@"EM_GIDList"];
    } else {
        [parameters setValue:[parameters[@"EM_GIDList"] componentsSeparatedByString:@","] forKey:@"EM_GIDList"];
    }
    [parameters setValue:@1 forKey:@"OrderType"];
    [parameters setValue:@"00000" forKey:@"VIP_Card"];
    NSString *priceValue = @"不打折";
    if (self.vipModel) {
        [parameters setValue:self.vipModel.vCH_Card forKey:@"VIP_Card"];
        [parameters setValue:@2 forKey:@"OrderType"];
        if (self.vipModel.dS_Value < 1) {
            priceValue = [NSString stringWithFormat:@"%.1lf折",10 *self.vipModel.dS_Value];
        }
    }
    
    [parameters setValue:parameters[@"CO_TotalPrice"] forKey:@"CO_Monetary"];
    NSString *price =@([parameters[@"CO_TotalPrice"]floatValue] - [parameters[@"DisMoney"] floatValue]).stringValue;
    [parameters setValue:price forKey:@"ActivityValue"];
    [parameters setValue:@"" forKey:@"CO_Remark"];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"消费金额:", @"detail":[@"￥" stringByAppendingString: parameters[@"CO_Monetary"]]}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"会员折扣:", @"detail":price}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"折后金额:", @"detail":[@"￥" stringByAppendingString:parameters[@"DisMoney"]]}];

    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"API/ConsumeOrder/SubmitCelerityOrder" parameters:parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XYPrinterMaker sharedMaker].isPrint = print;
                XYPaymentView *payView = [[XYPaymentView alloc] initWithTitlePrice:self.footView.priceString];
                payView.payUrl = @"API/ConsumeOrder/PaymentCelerityOrder";
                /*
                 OrderGID    订单GID    Bool    否    0-100
                 IS_Sms    是否发送短信    string    是    0-500
                 */
                payView.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(msg), @"PayResult":@""}.mutableCopy;
                payView.jointPayBlock = ^{
                    XYJointPaymentController *jointVc = [[XYJointPaymentController alloc] init];
                    jointVc.priceString = weakSelf.footView.priceString;
                    jointVc.payUrl = @"API/ConsumeOrder/PaymentCelerityOrder";
                    /*
                     OrderGID    订单GID    Bool    否    0-100
                     IS_Sms    是否发送短信    string    是    0-500
                     */
                    jointVc.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(msg), @"PayResult":@""}.mutableCopy;
                    [weakSelf.navigationController pushViewController:jointVc animated:YES];
                };
                [weakSelf presentViewController:payView animated:YES completion:nil];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYConfirmPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYConfirmPayCell" forIndexPath:indexPath];
    XYConfirmPayModel *model = self.datalist[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
