//
//  XYMineViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMineViewController.h"
#import "XYMineHeaderView.h"
#import "XYBaseNavController.h"
#import "XYLoginViewController.h"
#import "XYSettingViewController.h"
#import "XYMessageViewController.h"
#import "XYCustomerServiceController.h"
#import "XYBAWebViewController.h"
#import "XYSystemSettingController.h"

@interface XYMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYMineHeaderView *headerView;
@property (nonatomic, strong)NSArray *datalist;

@property (nonatomic, strong)XYMessageViewController *messageVc;

@end

@implementation XYMineViewController

// 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (self.tabBarController.tabBar.hidden == YES)
    {
        self.tabBarController.tabBar.hidden =NO;
    }
    
    [super viewWillAppear:animated];
    
    [self setBadge];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (NSArray *)datalist {
    if (!_datalist) {
        _datalist = @[//@{@"title":@"云铺商城", @"image ":@"mine_shopping_mall", @"controller":@""},
                      //@{@"title":@"反馈意见", @"image ":@"mine_fade", @"controller":@""},
                      //@{@"title":@"好友分享", @"image":@"mine_share", @"controller":@""},
                      @{@"title":@"关于我们", @"image":@"mine_about_us", @"controller":@"XYBAWebViewController"},
                      @{@"title":@"我的客服", @"image":@"mine_ service", @"controller":@"XYCustomerServiceController"},
                      @{@"title":@"系统管理", @"image":@"mine_set", @"controller":@"XYSystemSettingController"}
                      ];
    }
    return _datalist;
}

- (void)loadData {
//    api/Shops/GetShops
//    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Shops/GetShops" parameters:@{@"GID":[LoginModel shareLoginModel].shopID} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            [[LoginModel shareLoginModel].shopModel setValuesForKeysWithDictionary:dic[@"data"]];
        }
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
    
    self.messageVc = [[XYMessageViewController alloc] init];
    WeakSelf;
    self.messageVc.loadDataFinish = ^{
        [weakSelf setBadge];
    };
}

- (void)setBadge {
    NSInteger count = self.messageVc.datalist.count;
    if (self.messageVc.pageTotal > 1) {
        count = 20;
    }
    NSInteger msgNum = 0;
    for (int i = 0; i < count; i++) {
        XYMessageModel *model = self.messageVc.datalist[i];
        if (!model.popState) {
            msgNum += 1;
        }
    }
    
    self.headerView.badge = msgNum;
}

- (void)setupUI {
    CGFloat height = 175 + 6 * 50 + 10;
    if (height > ScreenHeight-60 - 66) {
        height = ScreenHeight-60 - 66;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 175, ScreenWidth, height - 175) style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (height < ScreenHeight-60 - 66) {
        tableView.scrollEnabled = NO;
    }
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview: self.tableView = tableView];
    XYMineHeaderView *headerView = [[XYMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 175)];
    WeakSelf;
    headerView.chickAction = ^(NSInteger index) {
        if (index == 2) {
            XYSettingViewController *settingVc = XYSettingViewController.new;
            [weakSelf.navigationController pushViewController:settingVc animated:YES];
        } else if (index == 1) {
            [weakSelf.navigationController pushViewController:weakSelf.messageVc animated:YES];
        }
    };
    [self.view addSubview:self.headerView=headerView];
}

// 退出登录
-(void)logoutAction {
//    /api/User/SignOut
    [AFNetworkManager postNetworkWithUrl:@"api/User/SignOut" parameters:nil succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ApplicationRootVC([[XYBaseNavController alloc] initWithRootViewController:[[XYLoginViewController alloc] init]]);
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}


#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.datalist[indexPath.row];
    NSString *title = dic[@"title"];
    NSString *image = dic[@"image"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    cell.imageView.image = [UIImage imageNamed:image];
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 84;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // 登录
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    UIButton *logoutBtn = [footerView viewWithTag:101];
    if (!logoutBtn) {
        footerView.contentView.backgroundColor = [UIColor whiteColor];
        logoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [logoutBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:(UIControlEventTouchUpInside)];
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.tag = 101;
        logoutBtn.backgroundColor = RGBColor(252, 105, 67);
        [footerView.contentView addSubview:logoutBtn];
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.contentView.mas_top).offset(30);
            make.left.equalTo(footerView.contentView.mas_left).offset(23);
            make.right.equalTo(footerView.contentView.mas_right).offset(-23);
            make.height.mas_equalTo(46);
        }];
    }
    
    //    logoutBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    logoutBtn.layer.shadowOpacity = 0.5;
    //    logoutBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10;
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"    ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datalist[indexPath.row];
    XYBasicViewController *controller = [[NSClassFromString(dic[@"controller"]) alloc] init];
                                          
    if ([controller isKindOfClass:[XYBAWebViewController class]]) {
        XYBAWebViewController *vc = (XYBAWebViewController *)controller;
        vc.title = @"关于我们";
        [vc ba_web_loadURLString:@"http://m.yunvip123.com/home/aboutus"];
    }
    [self.navigationController pushViewController:controller animated:true];
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
