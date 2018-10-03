//
//  XYSystemSettingController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYSystemSettingController.h"
#import "XYPrintSetViewController.h"
#import "XYParameterSetController.h"
#import "XYRechargeViewController.h"
#import "XYStaffManageController.h"

@interface XYSystemSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYSystemSettingController

- (void)loadData {
    //    /api/CustomerService/GetCustomerServiceInfo
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/CustomerService/GetCustomerServiceInfo" parameters:@{@"GID":[LoginModel shareLoginModel].shopID} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
//            self.datalist = [XYCustomerServiceModel modelConfigureDic:dic[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (NSArray *)datalist {
    if (!_datalist) {
        
        _datalist = @[@{@"image":@"system_print_set",@"title":@"打印设置", @"controller":@"XYPrintSetViewController"},
                      @{@"image":@"system_params_set",@"title":@"参数设置", @"controller":@"XYParameterSetController"},
                      @{@"image":@"system_supplier_manager",@"title":@"供应商管理", @"controller":@""},
                      @{@"image":@"system_level_manager",@"title":@"等级管理", @"controller":@""},
                      @{@"image":@"system_rechange_manager",@"title":@"充值管理", @"controller":@"XYRechargeViewController"},
                      @{@"image":@"system_package_manager",@"title":@"套餐管理", @"controller":@""},
                      @{@"image":@"system_staff_manager",@"title":@"员工管理", @"controller":@"XYStaffManageController"},
                      @{@"image":@"system_user_manager",@"title":@"用户管理", @"controller":@""},
                      @{@"image":@"system_lab_manager",@"title":@"标签管理", @"controller":@""}
                      //,@{@"image":@"",@"title":@"系统设置"}
                      ];
    }
    return _datalist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统管理";
//    [self loadData];
    [self setupUI];
}


- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = UIView.new;
    self.view = self.tableView = tableView;
    
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];

    NSDictionary *dic = self.datalist[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datalist[indexPath.row];
    if ([dic[@"controller"] length]) {
        XYBasicViewController *controller = [[NSClassFromString(dic[@"controller"]) alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    } else {
        [XYProgressHUD showMessage:ToDo];
    }
    
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
