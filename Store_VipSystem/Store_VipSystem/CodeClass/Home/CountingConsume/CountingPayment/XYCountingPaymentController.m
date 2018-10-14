//
//  XYCountingPaymentController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCountingPaymentController.h"
#import "XYReceivablesFootView.h"
#import "XYStaffManageController.h"
#import "XYCountingConsumeModel.h"
#import "XYVipRechargeModel.h"

@interface XYCountingPaymentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, weak)XYReceivablesFootView *footView;
@property (nonatomic, strong) XYStaffManageController *staff;


@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYCountingPaymentController

- (void)loadData {
    
    NSArray  *datalist = @[
                           @{@"title":@"会员名称:",@"detail":self.vipModel.vIP_Name},
                           @{@"title":@"会员卡号:",@"detail":self.vipModel.vCH_Card, @"modelKey":@"VIP_Card"},
                           @{@"title":@"订单号:", @"textColor":@"FF2600", @"detail":@"JC".orderCode, @"modelKey":@"WO_OrderCode"},
                           @{@"title":@"员工提成",@"detail":@""}
                           ];
    self.datalist = [XYVipRechargeModel modelConfigureWithArray:datalist];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付确认";
    [self loadData];
    [self setupUI];
//    WeakSelf;
//    self.dataOverload = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView = tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
    }];
    
    XYReceivablesFootView *footView = [[XYReceivablesFootView alloc] init];
    footView.hiddenPrice = YES;
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
     名称：    添加计次订单    地址：    /api/WouldOrder/AddWouldOrder
     输入参数：
     参数Code    参数名称    数据类型    可否为空    长度范围    备注
     VIP_Card    会员卡号    String    否    0-100
     WO_OrderCode    订单编号    String    否    0-100
     WO_Remark    备注    String    是    0-500
     wouldOrderDetail    计次订单信息    List<WouldOrderDetail>    是    0-10000
     IS_Sms    是否发送短信    Bool    是    0-500
     Device    设备    string    是    0-500
     OrderTime    订单时间    string    是    0-500
     */
    /*
     1WOD_EMName    提成员工
     1EM_GIDList    提成员工
     GID    计次订单明细GID
     WO_GID    计次订单GID
     1WOD_UseNumber    使用次数
     1WOD_ResidueDegree    剩余次数
     1SG_GID    服务商品GID
     1SG_Code    服务商品简码
     SGC_Name
     1SG_Name    服务商品名称
     SG_Price    服务商品单价
     SG_Abstract    服务商品简介
     SG_Detail    服务商品详细
     PM_BigImg    商品图片
     CY_GID    企业GID
     WOD_Crator
     WOD_UpdateTime
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (XYVipRechargeModel *model in self.datalist) {
        if (model.modelKey) {
            [parameters setValue:model.detail forKey:model.modelKey];
        }
    }
    XYVipRechargeModel *obj = self.datalist.lastObject;
    [parameters setValue:@(msg) forKey:@"IS_Sms"];
    [parameters setValue:@"" forKey:@"Device"];
    [parameters setValue:@"" forKey:@"WO_Remark"];
    [parameters setValue:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"] forKey:@"OrderTime"];
    NSMutableArray *array = [NSMutableArray array];
    for (XYCountingConsumeModel *model in self.countingModels) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:obj.detail forKey:@"WOD_EMName"];
        [dic setValue:obj.updateValue forKey:@"EM_GIDList"];
        [dic setValue:@(model.count) forKey:@"WOD_UseNumber"];
        [dic setValue:@(model.mCA_HowMany) forKey:@"WOD_ResidueDegree"];
        [dic setValue:model.sG_GID forKey:@"SG_GID"];
        [dic setValue:model.sG_Code forKey:@"SG_Code"];
        [dic setValue:model.sG_Name forKey:@"SG_Name"];
        [dic setValue:@(model.sG_Price) forKey:@"SG_Price"];
        [dic setValue:model.pM_BigImg forKey:@"PM_BigImg"];
        [dic setValue:model.sGC_ClasName forKey:@"SGC_Name"];
        [array addObject:dic];
    }
    [parameters setValue:array forKey:@"wouldOrderDetail"];
    
    [[XYPrinterMaker sharedMaker].bodylist addObject:@[@"服务名称", @"使用", @"剩余"]];
    for (NSDictionary *body in array) {
        [[XYPrinterMaker sharedMaker].bodylist addObject:@[body[@"SG_Name"], [NSString stringWithFormat:@"%@次", body[@"WOD_UseNumber"]],[NSString stringWithFormat:@"%@次", body[@"WOD_ResidueDegree"]]]];
    }
//    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/WouldOrder/AddWouldOrder" parameters:parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            [XYPrinterMaker sharedMaker].isPrint = print;
            [XYPrinterMaker sharedMaker].header.name = dic[@"data"][@"WO_Creator"];
            [XYPrinterMaker sharedMaker].header.date = dic[@"data"][@"WO_UpdateTime"];
            [XYPrinterMaker sharedMaker].header.order = dic[@"data"][@"WO_OrderCode"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [XYProgressHUD showSuccess:@"消费完成"];
                for (XYCountingConsumeModel *model in weakSelf.countingModels) {
                    model.mCA_HowMany -= model.count;
                    model.count = 0;
                }
                //                [weakSelf.navigationController popToViewController:vc animated:YES];
                //                if (vc.dataOverload) {
                //                    vc.dataOverload();
                //                }
                // 打印
                
                if (print) {
                    [XYPrinterMaker print];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
    //
//    NSDictionary *parameters = @{@"VIP_Card":self.vipModel.vCH_Card, @"WO_OrderCode":};
}

- (void)paySuccessWithData:(NSDictionary *)dic {
    
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = @"欢迎光临";
    [printer appendText:title alignment:HLTextAlignmentCenter];
    [printer appendNewLine];
    
    [printer appendTitle:@"收银员:" value:@"2016-04-27 10:01:50" valueOffset:150];
    [printer appendTitle:@"结账日期:" value:@"4000020160427100150" valueOffset:150];
    [printer appendTitle:@"流水单号:" value:@"4000020160427100150" valueOffset:150];
    
    [printer appendSeperatorLine];
    [printer appendLeftText:@"服务名称" middleText:@"使用" rightText:@"剩余" isTitle:YES];
    CGFloat total = 0.0;
    NSDictionary *dict1 = @{@"name":@"铅笔测试一下哈哈",@"amount":@"5",@"price":@"2.0"};
    NSDictionary *dict2 = @{@"name":@"abcdefghijfdf",@"amount":@"1",@"price":@"1.0"};
    NSDictionary *dict3 = @{@"name":@"abcde笔记本啊啊",@"amount":@"3",@"price":@"3.0"};
    NSArray *goodsArray = @[dict1, dict2, dict3];
    for (NSDictionary *dict in goodsArray) {
        [printer appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    }
    
    [printer appendSeperatorLine];
    [printer appendTitle:@"打印时间:" value:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"]];
    
    [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    
}


#pragma mark -TableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.countingModels.count;
    }
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (indexPath.section) {
        XYCountingConsumeModel *model = self.countingModels[indexPath.row];
        cell.textLabel.text = model.sG_Name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"消费次数：%ld", model.count];
    } else {
        XYVipRechargeModel *model = self.datalist[indexPath.row];
        cell.textLabel.text = model.title;
        if (model.textColor.length) {
            cell.detailTextLabel.textColor = [UIColor colorWithHex:model.textColor];
        }
        if ([model.title isEqualToString:@"员工提成"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.detailTextLabel.text = model.detail;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"  ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        XYVipRechargeModel *model = self.datalist[indexPath.row];
        //    WeakSelf;
        if ([model.title isEqualToString:@"员工提成"]) {
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
