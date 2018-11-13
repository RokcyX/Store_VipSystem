//
//  CommodityManageController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCommodityManageController.h"
#import "XYVerticalSegmentedControl.h"
#import "XYHomeBasicView.h"
#import "SLScanQCodeViewController.h"
#import "XYCommodityViewCell/XYCommodityViewCell.h"
#import "XYShowGoodsController.h"

@interface XYCommodityManageController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)XYVerticalSegmentedControl *verticalSegmentedControl;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *parameters;
@property (nonatomic, assign)NSInteger pageTotal;
@property (nonatomic, strong)NSMutableArray *datalist;
@property (nonatomic, strong)NSArray *classifylist;
@property (nonatomic, assign)BOOL isAll;

@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation XYCommodityManageController

- (void)loadData {
//    /api/ProductManger/QueryDataList
    WeakSelf;
    
    self.task = [AFNetworkManager postNetworkWithUrl:@"api/ProductManger/QueryDataList" parameters:self.parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.pageTotal = [dic[@"data"][@"PageTotal"] integerValue];
            if ([dic[@"data"][@"PageIndex"] integerValue] == 1) {
                weakSelf.datalist = [XYCommodityModel modelConfigureWithArray:dic[@"data"][@"DataList"]];
            } else {
                [weakSelf.datalist addObjectsFromArray:[XYCommodityModel modelConfigureWithArray:dic[@"data"][@"DataList"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (weakSelf.datalist.count) {
                    if ([self.parameters[@"PageIndex"] integerValue] == 1) {
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                    }
                } else {
                    [XYProgressHUD showMessage:@"暂无数据"];
                }
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:[self.parameters[@"PageIndex"] integerValue] == 1 ? YES : NO];

}

- (void)loadAllProductTypeList {
    WeakSelf;
    self.isAll = YES;
    [AFNetworkManager postNetworkWithUrl:@"api/ProductTypeManager/QueryAllProductTypeBySM_ID" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.classifylist = [XYGoodsClassifyModel modelConfigureWithArray:dic[@"data"]];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.classifylist.count) {
                [XYProgressHUD showMessage:@"暂无数据"];
            } else {
                weakSelf.verticalSegmentedControl.countForSection = ^NSInteger{
                    return weakSelf.classifylist.count + 1;
                };
                weakSelf.verticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
                    if (section) {
                        XYGoodsClassifyModel *model = weakSelf.classifylist[section-1];
                        if (model.isOpen) {
                            return model.subList.count;
                        }
                    }
                    return 0;
                };
                [weakSelf.verticalSegmentedControl setTitleForSection:^NSString *(NSInteger section) {
                    if (!section) {
                        return @"所有";
                    }
                    return [weakSelf.classifylist[section-1] pT_Name];
                } isSelectedForSection:^BOOL(NSInteger section) {
                    if (!section) {
                        return weakSelf.isAll;
                    }
                    return [weakSelf.classifylist[section-1] isSelected];
                }];
                
                [weakSelf.verticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
                    return [[weakSelf.classifylist[indexPath.section-1] subList][indexPath.row] pT_Name];
                } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
                    return [[weakSelf.classifylist[indexPath.section-1] subList][indexPath.row] isSelected];
                }];
                
                [weakSelf.verticalSegmentedControl reloadData];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.verticalSegmentedControl reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    PT_GID    分类ID        String        是    0-100
    PM_Name    商品名称        string        是    0-50
    PM_Code    商品编号        string        是    0-50
    PM_SimpleCode    商品简码        string        是    0-50
    PM_SynType    是否同步        short        是    1-1        同步方式0不同步1独立式同步2共享式同步
    PM_UnitPriceMin    价格最小值        float        是    0-50
    PM_UnitPriceMax    价格最大值        float        是    0-22
    PM_IsService    商品类型        Int32        是    0-2        商品类型 0普通商品 1服务商品
    PageIndex    当前页        Int        否    0-10
    PageSize    页大小        int        否    0-10
    DataType    数据筛选        String        否    0-100        1:去掉商品,2:去掉礼品,3:去掉服务,4:去掉商品+礼品,5:去掉商品+服务,6:去掉服务+礼品
    PM_GIDS    商品GID列表        List<string>        否    0-1000
    */
    self.title = @"商品管理";
    if ([LoginModel judgeAuthorityWithString:self.title]) {
        [self loadAllProductTypeList];

        self.parameters = @{
                            @"PageIndex":@1,
                            @"PageSize":KPageSize}.mutableCopy;
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
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

- (void)setNaviUI {
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat width = 50;
    CGFloat height = 35;
    addBtn.frame = CGRectMake(0, 0, width, height);
    [addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(addGoodsAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)addGoodsAction {
    XYAddGoodsController *addGoodsVc = [[XYAddGoodsController alloc] init];
    [self.navigationController pushViewController:addGoodsVc animated:YES];
}

// 扫描
- (void)scanAction {
    SLScanQCodeViewController * sqVC = [[SLScanQCodeViewController alloc]init];
    WeakSelf;
    [sqVC setSendTask:^(NSString *string) {
        [weakSelf.parameters setValue:string forKey:@"PM_Code"];
        weakSelf.basicView.searchField.text = string;
        [weakSelf firstLoadData];
    }];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];
}

// 搜索
- (void)searchDataAcion:(UITextField *)textField {
    [self.parameters setValue:textField.text forKey:@"PM_Code"];
    //当检测到textfield发生变化0.7秒后会调用该方法
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.7f];
}

- (void)firstLoadData {
    [self.task cancel];
    [self.parameters setValue:@1 forKey:@"PageIndex"];
    [self loadData];
}

- (XYVerticalSegmentedControl *)verticalSegmentedControl {
    if (!_verticalSegmentedControl) {
        XYVerticalSegmentedControl *verticalSegmentedControl = [[XYVerticalSegmentedControl alloc] init];
        WeakSelf;
        verticalSegmentedControl.selectedSection = ^(NSInteger section) {
            if (!section) {
                weakSelf.isAll = YES;
                for (XYGoodsClassifyModel *obj in weakSelf.classifylist) {
                    if (obj.isOpen && obj.subList.count) {
                        for (XYGoodsClassifyModel *subObj in obj.subList) {
                            subObj.isSelected = NO;
                        }
                    }
                    obj.isSelected = NO;
                    obj.isOpen = NO;
                }
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
                [weakSelf firstLoadData];
                [weakSelf.verticalSegmentedControl reloadData];
                return ;
            }
            weakSelf.isAll = NO;
            XYGoodsClassifyModel *model = weakSelf.classifylist[section-1];
            if (model.isSelected) {
                weakSelf.isAll = YES;
                model.isSelected = NO;
                model.isOpen = NO;
                for (XYGoodsClassifyModel *obj in model.subList) {
                    obj.isSelected = NO;
                }
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
            } else {
                for (XYGoodsClassifyModel *obj in weakSelf.classifylist) {
                    if (obj.isOpen && obj.subList.count) {
                        for (XYGoodsClassifyModel *subObj in obj.subList) {
                            subObj.isSelected = NO;
                        }
                    }
                    obj.isSelected = NO;
                    obj.isOpen = NO;
                }
                model.isSelected = YES;
                model.isOpen = YES;
                [weakSelf.parameters setValue:model.gID forKey:@"PT_GID"];
            }
            [weakSelf firstLoadData];
            [weakSelf.verticalSegmentedControl reloadData];
        };
        
        verticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.classifylist[indexPath.section-1];
            model.isSelected = NO;
            XYGoodsClassifyModel *subModel = model.subList[indexPath.row];
            if (subModel.isSelected) {
                weakSelf.isAll = YES;
                subModel.isSelected = NO;
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
            } else {
                for (XYGoodsClassifyModel *obj in model.subList) {
                    obj.isSelected = NO;
                }
                subModel.isSelected = YES;
                [weakSelf.parameters setValue:subModel.gID forKey:@"PT_GID"];
            }
            [weakSelf firstLoadData];
        };
        [self.view addSubview:self.verticalSegmentedControl=verticalSegmentedControl];
    }
    return _verticalSegmentedControl;
}

- (void)setupUI {
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    WeakSelf;
    [basicView.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:(UIControlEventTouchUpInside)];
    basicView.searchField.placeholder = @"请输入商品编号";
    [basicView.searchField addTarget:self action:@selector(searchDataAcion:) forControlEvents:(UIControlEventEditingChanged)];
    
    [self.verticalSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom);
        make.width.mas_equalTo(80);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYCommodityViewCell class] forCellReuseIdentifier:@"XYCommodityViewCell"];
    [self.basicView addSubview:self.tableView=tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.verticalSegmentedControl.mas_right);
        make.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.verticalSegmentedControl.mas_top);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom);
    }];
}


#pragma mark tableView dataSouce delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYCommodityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYCommodityViewCell" forIndexPath:indexPath];
    cell.model = self.datalist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYShowGoodsController *showGoods = [[XYShowGoodsController alloc] init];
    showGoods.model = self.datalist[indexPath.row];
    [self.navigationController pushViewController:showGoods animated:YES];
    [self.view endEditing:YES];
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
