//
//  XYVipSelectionController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/17.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipSelectionController.h"
#import "SLScanQCodeViewController.h"
#import "XYHomeBasicView.h"

@interface XYVipSelectionController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UIButton *checkAllBtn;
@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIButton *sendMsgBtn;
@property (nonatomic, assign)NSInteger pageTotal;
@property (nonatomic, strong)NSMutableArray *datalist;
@property (nonatomic, strong)NSMutableDictionary *parameters;

@end

@implementation XYVipSelectionController

- (void)loadDataWithLastPage:(BOOL)islast {
    // /api/VIP/QueryDataList
    WeakSelf;
    
    BOOL showMsg = YES;
    if ([self.parameters[@"PageIndex"] integerValue] > 1 || [self.parameters[@"CardOrNameOrCellPhoneOrFace"] length] > 0 || islast) {
        showMsg = NO;
    }
    
    [AFNetworkManager postNetworkWithUrl:@"api/VIP/QueryDataList" parameters:self.parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.pageTotal = [dic[@"data"][@"PageTotal"] integerValue];
            if ([dic[@"data"][@"PageIndex"] integerValue] == 1) {
                weakSelf.datalist = [XYMemberManageModel modelConfigureWithArray:dic[@"data"][@"DataList"] datalist:weakSelf.datalist isSelected:weakSelf.checkAllBtn.selected];
                if (islast) {
                    if (weakSelf.datalist.count == 1) {
                        XYMemberManageModel *model = self.datalist.firstObject;
                        if (model.isHaveVG) {
                            if (self.selectModel) {
                                self.selectModel(model);
                            }
                        } else {
                            [self loadSingleModel:model lastPage:islast];
                        }
                    }
                }
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

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = @{
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
    }
    return _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datalist = [NSMutableArray array];
    self.title = @"选择会员";
    [self loadDataWithLastPage:NO];
//    [self setNaviUI];
    [self setupUI];
    WeakSelf;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
        [weakSelf loadDataWithLastPage:NO];
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    
    // 上拉加载more
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        NSInteger pageIndex = [weakSelf.parameters[@"PageIndex"] integerValue];
        if (pageIndex < weakSelf.pageTotal) {
            [weakSelf.parameters setValue:@(pageIndex+1) forKey:@"PageIndex"];
            [weakSelf loadDataWithLastPage:NO];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)setNaviUI {
    UIButton *screenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat width = 60;
    CGFloat height = 35;
    screenBtn.frame = CGRectMake(0, 0, width, height);
    [screenBtn setTitle:@"筛选会员" forState:(UIControlStateNormal)];
    screenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,width-17, 0, 17-width);
    [screenBtn addTarget:self action:@selector(screenViewAction) forControlEvents:(UIControlEventTouchUpInside)];
    screenBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-8.5, 0, 8.5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenBtn];
}


// 筛选
- (void)screenViewAction {
//    [self.navigationController pushViewController:self.screenView animated:YES];
}

- (void)setupUI {
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    [basicView.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:(UIControlEventTouchUpInside)];
    [basicView.searchField addTarget:self action:@selector(searchDataAcion:) forControlEvents:(UIControlEventEditingChanged)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.basicView addSubview:self.tableView=tableView];
    WeakSelf;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom);
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
        [weakSelf loadDataWithLastPage:NO];
    }];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];
}

// 搜索
- (void)searchDataAcion:(UITextField *)textField {
    [self.parameters setValue:@1 forKey:@"PageIndex"];
    [self.parameters setValue:textField.text forKey:@"CardOrNameOrCellPhoneOrFace"];
    [self loadDataWithLastPage:NO];
}

- (void)searchFromLastPageWithCode:(NSString *)code {
    [self.parameters setValue:@1 forKey:@"PageIndex"];
    [self.parameters setValue:code forKey:@"CardOrNameOrCellPhoneOrFace"];
    [self loadDataWithLastPage:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark tableView dataSouce delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"UITableViewCell"];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XYMemberManageModel *model = self.datalist[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.vIP_HeadImg] placeholderImage:[UIImage imageNamed:@"member_vip_cellHeader"]];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"余额：%.2lf   积分：%.lf", model.mA_AvailableBalance, model.mA_AvailableIntegral];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMemberManageModel *model = self.datalist[indexPath.row];
    if (model.isHaveVG) {
        if (self.selectModel) {
            self.selectModel(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self loadSingleModel:model lastPage:NO];
    }
    
//    XYVipInfoViewController *vipInfo = [[XYVipInfoViewController alloc] init];
//    vipInfo.model = self.datalist[indexPath.row];
//    [self.navigationController pushViewController:vipInfo animated:YES];
//    [XYAppDelegate.window endEditing:YES];
}

- (void)loadSingleModel:(XYMemberManageModel *)model lastPage:(BOOL)islast {
//    api/VIP/QuerySingle
//    VCH_Card
//    isNeedVG
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/VIP/QuerySingle" parameters:@{@"VCH_Card":model.vCH_Card, @"isNeedVG":@1} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [model setValuesForKeysWithDictionary:dic[@"data"]];
                if (weakSelf.selectModel) {
                    weakSelf.selectModel(model);
                }
                if (!islast) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
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
