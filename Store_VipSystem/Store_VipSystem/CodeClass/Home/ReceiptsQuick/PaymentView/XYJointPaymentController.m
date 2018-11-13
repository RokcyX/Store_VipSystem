//
//  XYJointPaymentController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYJointPaymentController.h"
#import "XYJointPaymentCell.h"
@interface XYJointPaymentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XYJointPaymentController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"JointPayment" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [XYJointPaymentModel modelConfigureWithArray:parseDic[@"data"] priceString:self.priceString];
    CGFloat price = 0;
    for (XYJointPaymentModel *model in self.dataList) {
        if (model.iconImage.length && !model.selectEnable) {
            price += model.detail.floatValue;
        }
        
        if ([model.title isEqualToString:@"余额"]) {
            if ([self.payUrl isEqualToString:@"api/Recharge/PaymentRecharge"]) {
                model.readonly = YES;
            }
            
            if (!self.balance) {
                model.readonly = YES;
            }
        }
        
    }
    XYJointPaymentModel *obj = self.dataList[1];
    obj.detail = [NSString stringWithFormat:@"%.2lf", price - self.priceString.floatValue];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联合支付";
    [self loadData];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark --- 键盘弹出 消失 通知
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    UITableViewCell *cell = (UITableViewCell *)firstResponder.superview.superview;
    CGFloat showHeight = CGRectGetHeight(self.tableView.frame) - keyboardRect.size.height;
    if (CGRectGetMaxY(cell.frame) > showHeight) {
        [self.tableView setContentOffset:CGPointMake(0, CGRectGetMaxY(cell.frame) - showHeight) animated:YES];
    }
}

- (void)keyboardDidHide:(NSNotification *)noti {
    
//    [self.tableView reloadData];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.sectionHeaderHeight = 50;
    tableView.sectionFooterHeight = 100;
    tableView.rowHeight = 50;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [tableView registerClass:[XYJointPaymentCell class] forCellReuseIdentifier:@"XYJointPaymentCell"];

    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderView"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewFooterView"];

    tableView.tableFooterView = UIView.new;
    self.view = self.tableView = tableView;
    
}


#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderView"];
    headView.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *leftLabel = [headView.contentView viewWithTag:101];
    UILabel *rightLabel = [headView.contentView viewWithTag:101];
    if (!leftLabel) {
        leftLabel = [[UILabel alloc] init];
        [headView.contentView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(headView.contentView);
            make.left.equalTo(headView.contentView.mas_left).offset(30);
            make.right.equalTo(headView.contentView.mas_centerX);
        }];
        
        rightLabel = [[UILabel alloc] init];
        [headView.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(headView.contentView);
            make.right.equalTo(headView.contentView.mas_right).offset(-30);
            make.left.equalTo(headView.contentView.mas_centerX);
        }];
    }

    leftLabel.text = [NSString stringWithFormat:@"可用余额：%.2lf",0.00];
    rightLabel.text = [NSString stringWithFormat:@"可抵扣金额：%.2lf",0.00];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJointPaymentModel *model = self.dataList[indexPath.row];
    UITableViewCell *cell;
    if (model.iconImage.length) {
        XYJointPaymentCell *JointCell = [tableView dequeueReusableCellWithIdentifier:@"XYJointPaymentCell" forIndexPath:indexPath];
        JointCell.balance = self.balance;
        JointCell.model = model;
        WeakSelf;
        JointCell.priceChanged = ^{
            CGFloat price = 0;
            for (XYJointPaymentModel *model in self.dataList) {
                if (model.iconImage.length && !model.selectEnable) {
                    price += model.detail.floatValue;
                }
            }
            XYJointPaymentModel *obj = self.dataList[1];
            obj.detail = [NSString stringWithFormat:@"%.2lf", price - weakSelf.priceString.floatValue];
            
            UITableViewCell *objCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            objCell.detailTextLabel.text =obj.detail;
        };
        cell = JointCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text =model.detail;
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewFooterView"];
    footView.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *recBtn = [footView.contentView viewWithTag:102];
    if (!recBtn) {
        recBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        recBtn.tag = 102;
        [recBtn setTitle:@"确认收款" forState:(UIControlStateNormal)];
        [recBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [recBtn addTarget:self action:@selector(payOrder) forControlEvents:(UIControlEventTouchUpInside)];
        recBtn.layer.cornerRadius = 5;
        recBtn.backgroundColor = RGBColor(252, 105, 67);
        //    sendMsgBtn.layer.shadowOffset = CGSizeMake(1, 1);
        //    sendMsgBtn.layer.shadowOpacity = 0.5;
        //    sendMsgBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        [footView.contentView addSubview:recBtn];
        [recBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footView.contentView.mas_right).offset(-30);
            make.left.equalTo(footView.contentView.mas_left).offset(30);
            make.bottom.equalTo(footView.contentView.mas_bottom).offset(-10);
            make.height.mas_equalTo(40);
        }];
    }
    
    
    
    return footView;
}

- (void)payOrder {
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
    XYJointPaymentModel *model0 = self.dataList.firstObject;
    XYJointPaymentModel *model1 = self.dataList[1];
    if (model1.detail.floatValue < 0) {
        [XYProgressHUD showMessage:[NSString stringWithFormat:@"应付%@元还差%@", model0.detail, @(-model1.detail.floatValue).stringValue]];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"DisMoney":model0.detail, @"PayTotalMoney":@(model0.detail.floatValue + model1.detail.floatValue).stringValue, @"GiveChange":model1.detail}];
    XYJointPaymentModel *pointModel = self.dataList[self.dataList.count-4];
    XYJointPaymentModel *gidModel = self.dataList.lastObject;

    NSMutableArray *array = [NSMutableArray array];
    for (XYJointPaymentModel *obj in self.dataList) {
        if (obj.modelKey.length && obj.detail.floatValue) {
            NSDictionary *dic = @{@"PayCode":obj.modelKey, @"PayName":obj.modelKey.stringWithCode, @"PayMoney":obj.detail, @"PayPoint":pointModel.detail, @"GID":gidModel.detail};
            [array addObject:dic];
        }
    }
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
    
    //    @{@"title":@"应   收:", @"detail":[@"￥" stringByAppendingString:_priceString]}
    //    @{@"title":@"实   收:", @"detail":[@"￥" stringByAppendingString: _priceString]}
    //    @{@"title":@"支付详情:", @"detail":print}
    
    //    @{@"title":@"找   零:", @"detail":@"￥0.00"}
    
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
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [XYPrinterMaker print];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XYProgressHUD showMessage: dic[@"msg"]];
            });
        }
        
        
        
    } failure:^(NSError *error) {
        
    } showMsg:YES];
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
