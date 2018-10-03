//
//  XYCustomerServiceController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCustomerServiceController.h"
#import "XYCustomerServiceModel.h"
@interface XYCustomerServiceController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYCustomerServiceController

- (void)loadData {
//    /api/CustomerService/GetCustomerServiceInfo
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/CustomerService/GetCustomerServiceInfo" parameters:@{@"GID":[LoginModel shareLoginModel].shopID} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            self.datalist = [XYCustomerServiceModel modelConfigureDic:dic[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的客服";
    [self loadData];
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
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    XYCustomerServiceModel *model = self.datalist[indexPath.row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.detailTextLabel.text = model.detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYCustomerServiceModel *model = self.datalist[indexPath.row];
    if ([model.title isEqualToString:@"联系电话"]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.detail];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else if ([model.title isEqualToString:@"QQ号码"]) {
        //是否安装QQ
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
        {
            //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
            NSString *QQ = model.detail;
            //调用QQ客户端,发起QQ临时会话
            NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            [XYProgressHUD showMessage:@"未找到QQ"];
        }
    } else if ([model.title isEqualToString:@"微信号码"]) {
        
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
