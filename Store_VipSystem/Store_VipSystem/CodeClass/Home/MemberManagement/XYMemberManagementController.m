//
//  XYMemberManagementController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/5.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMemberManagementController.h"
#import "XYHomeBasicView.h"
#import "XYMemberManageCell.h"
#import "SLScanQCodeViewController.h"
#import "XYVipInfoViewController.h"
#import "XYVipBasicInfoController.h"
#import "XYScreenViewController.h"
@interface XYMemberManagementController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UIButton *checkAllBtn;
@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIButton *sendMsgBtn;
@property (nonatomic, assign)NSInteger pageTotal;
@property (nonatomic, strong)NSMutableDictionary *parameters;

@property (nonatomic, strong)NSMutableArray *datalist;
@property (nonatomic, strong)XYScreenViewController *screenView;
@property (nonatomic, weak)XYMemberManageModel *addModel;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation XYMemberManagementController

- (void)loadData {
    // /api/VIP/QueryDataList
    WeakSelf;
    [self.task cancel];
    BOOL showMsg = YES;
    if ([self.parameters[@"PageIndex"] integerValue] > 1 || [self.parameters[@"CardOrNameOrCellPhoneOrFace"] length] > 0) {
        showMsg = NO;
    }
    
    self.task = [AFNetworkManager postNetworkWithUrl:@"api/VIP/QueryDataList" parameters:self.parameters succeed:^(NSDictionary *dic) {
        weakSelf.tableView.mj_footer.state=MJRefreshStateIdle;
        if ([dic[@"success"] boolValue]) {
            weakSelf.pageTotal = [dic[@"data"][@"PageTotal"] integerValue];
            if ([dic[@"data"][@"PageIndex"] integerValue] == 1) {
                weakSelf.datalist = [XYMemberManageModel modelConfigureWithArray:dic[@"data"][@"DataList"] datalist:weakSelf.datalist isSelected:weakSelf.checkAllBtn.selected];
            } else {
                [weakSelf.datalist addObjectsFromArray:[XYMemberManageModel modelConfigureWithArray:dic[@"data"][@"DataList"] datalist:weakSelf.datalist isSelected:NO]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([dic[@"data"][@"DataList"] count]) {
                        weakSelf.checkAllBtn.selected = NO;
                    }
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (weakSelf.datalist.count) {
                    if ([self.parameters[@"PageIndex"] integerValue] == 1) {
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                    }
                }
                weakSelf.countLabel.text = [NSString stringWithFormat:@"会员总数%@位", dic[@"data"][@"DataCount"]];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:showMsg];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员列表";
    if ([LoginModel judgeAuthorityWithString:self.title]) {
        self.datalist = [NSMutableArray array];
        
        self.parameters = @{
                            @"PageIndex":@1,
                            @"PageSize":KPageSize
                            //                                     ,
                            //                                     @"CardOrNameOrCellPhoneOrFace":@"",
                            //                                     @"VG_GID":@"",
                            //                                     @"VIP_Label":@"",
                            //                                     @"SM_GID":@"",
                            //                                     @"VIP_IsForver":@"",
                            //                                     @"VIP_State":@"",
                            //                                     @"VIP_CellPhone":@"",
                            //                                     @"DayType":@"",
                            //                                     @"ExpireDayType":@"",
                            //                                     @"DayRegisterType":@"",
                            //                                     @"NewAddType":@"",
                            //                                     @"CustDataType":@"",
                            //                                     @"EM_GID":@"",
                            //                                     @"EC_GID":@""
                            }.mutableCopy;
        [self loadData];
        [self setNaviUI];
        [self setupUI];
        WeakSelf;
        self.dataOverload = ^{
            [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
            [weakSelf loadData];
        };
        // 下拉刷新
        self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
            [weakSelf loadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        }];
        
        // 上拉加载more
        
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            NSInteger pageIndex = [weakSelf.parameters[@"PageIndex"] integerValue];
            if (pageIndex < weakSelf.pageTotal) {
                [weakSelf.parameters setValue:@(pageIndex+1) forKey:@"PageIndex"];
                [weakSelf loadData];
            }
        }];
    
//        self.tableView.mj_footer=[MJRefreshBackFooter footerWithRefreshingBlock:^{
//            NSInteger pageIndex = [weakSelf.parameters[@"PageIndex"] integerValue];
//            if (pageIndex < weakSelf.pageTotal) {
//                [weakSelf.parameters setValue:@(pageIndex+1) forKey:@"PageIndex"];
//                [weakSelf loadData];
//            }
//            [weakSelf.tableView.mj_footer endRefreshing];
//        }];
    }
}

- (void)setNaviUI {
    UIButton *screenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat width = 60;
    CGFloat height = 35;
    screenBtn.frame = CGRectMake(0, 0, width, height);
    [screenBtn setImage:[UIImage imageNamed:@"member_navi_screen"] forState:(UIControlStateNormal)];
    [screenBtn setTitle:@"筛选" forState:(UIControlStateNormal)];
    screenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,width-17, 0, 17-width);
    [screenBtn addTarget:self action:@selector(screenViewAction) forControlEvents:(UIControlEventTouchUpInside)];
    screenBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-8.5, 0, 8.5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenBtn];
}

- (XYScreenViewController *)screenView {
    if (!_screenView) {
        _screenView = [[XYScreenViewController alloc] init];
        WeakSelf;
        _screenView.screenWithData = ^(NSDictionary *dic) {
            [weakSelf.parameters removeAllObjects];
            [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
            [weakSelf.parameters setValue:KPageSize forKey:@"PageSize"];
            [weakSelf.parameters setValuesForKeysWithDictionary:dic];
            [weakSelf loadData];
        };
    }
    return _screenView;
}

// 筛选
- (void)screenViewAction {
    [self.navigationController pushViewController:self.screenView animated:YES];
}

- (void)setupUI {
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    [basicView.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:(UIControlEventTouchUpInside)];
    [basicView.searchField addTarget:self action:@selector(searchDataAcion:) forControlEvents:(UIControlEventEditingChanged)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYMemberManageCell class] forCellReuseIdentifier:@"XYMemberManageCell"];
    [self.basicView addSubview:self.tableView=tableView];
    WeakSelf;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom).offset(-60);
    }];
    
    UIButton *checkAllBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [checkAllBtn setImage:[UIImage imageNamed:@"check_box_circle_normal"] forState:(UIControlStateNormal)];
    [checkAllBtn setImage:[UIImage imageNamed:@"check_box_circle_selected"] forState:(UIControlStateSelected)];
    [checkAllBtn addTarget:self action:@selector(checkAllAction) forControlEvents:(UIControlEventTouchUpInside)];
    checkAllBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 10, 20, 5);;
    [self.basicView addSubview:self.checkAllBtn=checkAllBtn];
    [checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom);
        make.left.equalTo(weakSelf.basicView.mas_left);
        make.width.mas_equalTo(35);
    }];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"全选" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(checkAllAction) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:RGBColor(130, 131, 132) forState:(UIControlStateNormal)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.basicView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(checkAllBtn);
        make.left.equalTo(checkAllBtn.mas_right);
        make.width.mas_equalTo(40);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = RGBColor(130, 131, 132);
    [self.basicView addSubview:self.countLabel=countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_right).offset(20);
        make.centerY.equalTo(btn.mas_centerY);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addBtn setImage:[UIImage imageNamed:@"member_vip_add"] forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(addVipAction) forControlEvents:(UIControlEventTouchUpInside)];
    addBtn.backgroundColor = [UIColor whiteColor];
    //    addBtn.layer.cornerRadius = 30;
    //    addBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    addBtn.layer.shadowOpacity = 0.5;
    //    addBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.basicView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.basicView.mas_right).offset(-20);
        make.bottom.equalTo(tableView.mas_bottom).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *sendMsgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sendMsgBtn setTitle:@"发送短信" forState:(UIControlStateNormal)];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sendMsgBtn addTarget:self action:@selector(sendMsgAction) forControlEvents:(UIControlEventTouchUpInside)];
    sendMsgBtn.layer.cornerRadius = 5;
    sendMsgBtn.backgroundColor = RGBColor(252, 105, 67);
    //    sendMsgBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    sendMsgBtn.layer.shadowOpacity = 0.5;
    //    sendMsgBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.basicView addSubview:self.sendMsgBtn=sendMsgBtn];
    [sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.basicView.mas_right).offset(-15);
        make.top.equalTo(tableView.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom).offset(-10);
        make.left.equalTo(countLabel.mas_right).offset(20);
        make.width.mas_equalTo(85);
    }];
    
}

// 扫描
- (void)scanAction {
    SLScanQCodeViewController * sqVC = [[SLScanQCodeViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    [sqVC setSendTask:^(NSString *string) {
        [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
        [weakSelf.parameters setValue:string forKey:@"CardOrNameOrCellPhoneOrFace"];
        weakSelf.basicView.searchField.text = string;
        [weakSelf loadData];
    }];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];
}

// 搜索
- (void)searchDataAcion:(UITextField *)textField {
    [self.parameters setValue:@1 forKey:@"PageIndex"];
    [self.parameters setValue:textField.text forKey:@"CardOrNameOrCellPhoneOrFace"];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.7f];
}

// 全选
- (void)checkAllAction {
    self.checkAllBtn.selected = !self.checkAllBtn.selected;
    for (XYMemberManageModel *model in self.datalist) {
        model.isSelected = self.checkAllBtn.selected;
    }
    [self.tableView reloadData];
    
}

// 添加Vip
- (void)addVipAction {
    XYVipBasicInfoController *vioBasic = [[XYVipBasicInfoController alloc] init];
    [self.navigationController pushViewController:vioBasic animated:YES];
}

// 发送短信
- (void)sendMsgAction {
    [XYProgressHUD showMessage:ToDo];
}

#pragma mark tableView dataSouce delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMemberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYMemberManageCell" forIndexPath:indexPath];
    cell.model = self.datalist[indexPath.row];
    WeakSelf;
    cell.checkBoxAction = ^{
        BOOL isSelected = YES;
        for (XYMemberManageModel *model in self.datalist) {
            if (!model.isSelected) {
                isSelected = NO;
            }
        }
        weakSelf.checkAllBtn.selected = isSelected;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYVipInfoViewController *vipInfo = [[XYVipInfoViewController alloc] init];
    vipInfo.model = self.datalist[indexPath.row];
    [self.navigationController pushViewController:vipInfo animated:YES];
    [XYAppDelegate.window endEditing:YES];
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
