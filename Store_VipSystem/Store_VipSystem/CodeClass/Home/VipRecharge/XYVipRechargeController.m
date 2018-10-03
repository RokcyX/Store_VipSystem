//
//  XYVipRechargeController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipRechargeController.h"
#import "XYHomeBasicView.h"
#import "SLScanQCodeViewController.h"
#import "XYVipCheckControl.h"

#import "XYReceivablesFootView.h"
#import "XYVipSelectionController.h"
#import "XYVipRechargeCell.h"

#import "XYSpecialOffersController.h"
#import "XYStaffManageController.h"
#import "XYJointPaymentController.h"

#import "XYPaymentView.h"

@interface XYVipRechargeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYVipCheckControl *check;

@property (nonatomic, strong)XYMemberManageModel *vipModel;
@property (nonatomic, strong)XYRechargeModel *recharge;
@property (nonatomic, weak)XYReceivablesFootView *footView;
@property (nonatomic, strong) XYStaffManageController *staff;
@property (nonatomic, strong) XYVipSelectionController *vipSelect;

@property (nonatomic, strong)NSArray *datalist;
@property (nonatomic, strong)NSArray *schemelist;

@end

@implementation XYVipRechargeController

- (void)loadData {
    self.schemelist = [LoginModel shareLoginModel].rechargeValidList;
    WeakSelf;
    if (!self.schemelist) {
        [AFNetworkManager postNetworkWithUrl:@"api/RechargePackage/GetValidList" parameters:nil succeed:^(NSDictionary *dic) {
            if ([dic[@"success"] boolValue]) {
                weakSelf.datalist = [XYRechargeModel modelConfigureWithArray:dic[@"data"] type:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
            
        } failure:^(NSError *error) {
            
        } showMsg:NO];
    }
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"VipRecharge" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.datalist = [XYVipRechargeModel modelConfigureWithArray:parseDic[@"data"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员充值";
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
    // 赠送金额
    XYVipRechargeModel *amountModel = self.datalist[1];
    // 赠送积分
    XYVipRechargeModel *pointModel = self.datalist[2];
    // 充值合计
    XYVipRechargeModel *combinedModel = self.datalist[3];
    
    self.footView.priceString = @"0.00";
    amountModel.detail = @"0.00";
    pointModel.detail = @"0";
    combinedModel.detail = @"0.00";
    [self.tableView reloadData];
    
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
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerClass:[XYVipRechargeCell class] forCellReuseIdentifier:@"XYVipRechargeCell"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView = tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
    }];
    
    XYReceivablesFootView *footView = [[XYReceivablesFootView alloc] init];
//    XYVipRechargeModel *offersModel = self.datalist.firstObject;
    
    footView.priceString = @"0.00";
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
     名称：    提交订单    地址：    /api/Recharge/ SubmitRecharge
     输入参数：
     参数Code    参数名称    数据类型    可否为空    长度范围    备注
     1MR_Order    订单号    string    是    0-100
     1VIP_Card    会员卡号    string    否    0-100
     1MR_Amount    充值金额    decimal?    否    0-100
     1MR_GivenAmount    赠送金额    decimal?    是    0-100
     1MR_Integral    赠送积分    decimal?    是    0-100
     1MR_Total    充值合计    decimal?    是    0-100
     1MR_Remark    备注    string    是    0-500
     1EM_GIDList    提成员工    List<string>    是    0-000
     CC_GID    活动GID    string    是    0-100
     OrderTime    订单时间    string    是    0-100
     */
    
    //
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (XYVipRechargeModel *model in self.datalist) {
        if (model.modelKey) {
            [parameters setValue:model.detail forKey:model.modelKey];
        }
    }
    if (![parameters[@"EM_GIDList"] length]) {
        [parameters removeObjectForKey:@"EM_GIDList"];
    } else {
        [parameters setValue:[parameters[@"EM_GIDList"] componentsSeparatedByString:@","] forKey:@"EM_GIDList"];
    }
    [parameters setValue:@1 forKey:@"CC_GID"];
    if (self.recharge) {
        [parameters setValue:self.recharge.gID forKey:@"CC_GID"];
    }
    [parameters setValue:@"CZ".orderCode forKey:@"MR_Order"];
    [parameters setValue:self.vipModel.vCH_Card forKey:@"VIP_Card"];
    [parameters setValue:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"] forKey:@"OrderTime"];
    
    [parameters setValue:self.footView.priceString forKey:@"YSMoney"];
    [parameters setValue:self.footView.priceString forKey:@"SSMoney"];
    [parameters setValue:@"" forKey:@"ZLMoney"];
    
    // print 参数
    
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"充值金额:", @"detail":[@"￥" stringByAppendingString:parameters[@"MR_Amount"]]}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"赠送金额:", @"detail":[@"￥" stringByAppendingString:parameters[@"MR_GivenAmount"]]}];
    [[XYPrinterMaker sharedMaker].paymentlist addObject:@{@"title":@"充值合计:", @"detail":[@"￥" stringByAppendingString:parameters[@"MR_Total"]]}];
    
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Recharge/SubmitRecharge" parameters:parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                XYPaymentView *payView = [[XYPaymentView alloc] initWithTitlePrice:self.footView.priceString];
                payView.payUrl = @"api/Recharge/PaymentRecharge";
                /*
                 OrderGID    订单GID    Bool    否    0-100
                 IS_Sms    是否发送短信    string    是    0-500
                 */
                payView.parameters = @{@"OrderGID":dic[@"data"][@"GID"], @"IS_Sms":@(msg), @"PayResult":@""}.mutableCopy;
                payView.jointPayBlock = ^{
                    XYJointPaymentController *jointVc = [[XYJointPaymentController alloc] init];
                    jointVc.priceString = weakSelf.footView.priceString;
                    jointVc.payUrl = @"api/Recharge/PaymentRecharge";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYVipRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYVipRechargeCell" forIndexPath:indexPath];
    XYVipRechargeModel *model = self.datalist[indexPath.row];
    if (!indexPath.row) {
        WeakSelf;
        [cell setModel:model schemelist:self.schemelist];
        cell.amoutInput = ^(NSString *result, XYRechargeModel *recharge) {
            if (!self.vipModel) {
                return NO;
            }
            
            // 赠送金额
            XYVipRechargeModel *amountModel = self.datalist[1];
            // 赠送积分
            XYVipRechargeModel *pointModel = self.datalist[2];
            // 充值合计
            XYVipRechargeModel *combinedModel = self.datalist[3];
            combinedModel.detail = result;
            weakSelf.footView.priceString = result;
            weakSelf.recharge = recharge;
            pointModel.detail = @(@(result.floatValue *self.vipModel.rS_Value).integerValue).stringValue;
            amountModel.detail = @"0.00";
            if (recharge) {
                pointModel.detail = @(recharge.rP_GivePoint).stringValue;
                if (recharge.rP_Discount) {
                    //                优惠
                    weakSelf.footView.priceString = [NSString stringWithFormat:@"%.2lf", result.floatValue *(recharge.rP_Discount/10)];
                    
                } else if (recharge.rP_GiveMoney) {
                    //                赠送
                    amountModel.detail = [NSString stringWithFormat:@"%.2lf",recharge.rP_GiveMoney];
                    combinedModel.detail = [NSString stringWithFormat:@"%.2lf",result.floatValue + recharge.rP_GiveMoney];
                    
                } else if (recharge.rP_ReduceMoney) {
                    //                减少
                    weakSelf.footView.priceString = [NSString stringWithFormat:@"%.2lf",result.floatValue -recharge.rP_ReduceMoney];
                }
            }
            
            XYVipRechargeCell *objCell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            objCell1.model = amountModel;
            XYVipRechargeCell *objCell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            objCell2.model = pointModel;

            XYVipRechargeCell *objCell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            objCell3.model = combinedModel;
            return YES;
        };
    }
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        return  50;
    }
    return 50 + (self.schemelist.count/3 + (self.schemelist.count%3 ? 1:0)) * 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYVipRechargeModel *model = self.datalist[indexPath.row];
//    WeakSelf;
    if ([model.title isEqualToString:@"提成员工"]) {
        if (!model.systemAllow) {
            [XYProgressHUD showMessage:[model.title stringByAppendingString:@"未开启，请通过系统管理-参数设置开启"]];
            return;
        }
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
