//
//  XYMessageViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYMessageViewController.h"
#import "XYMessageDetailViewController.h"
#import "XYBAWebViewController.h"

@interface XYMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *parameters;

@end

@implementation XYMessageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parameters = @{
                            @"PageIndex":@1,
                            @"PageSize":KPageSize}.mutableCopy;
        [self loadData];

    }
    return self;
}

- (void)loadData {
//    api/Notice/QueryDataList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Notice/QueryDataList" parameters:self.parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.pageTotal = [dic[@"data"][@"PageTotal"] integerValue];
            if ([dic[@"data"][@"PageIndex"] integerValue] == 1) {
                weakSelf.datalist = [XYMessageModel modelConfigureWithArray:dic[@"data"][@"DataList"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.loadDataFinish) {
                        self.loadDataFinish();
                    }
                });
            } else {
                [weakSelf.datalist addObjectsFromArray:[XYMessageModel modelConfigureWithArray:dic[@"data"][@"DataList"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (weakSelf.datalist.count) {
                    if ([self.parameters[@"PageIndex"] integerValue] == 1) {
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                    }
                }
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    WeakSelf;
    [self setupUI];
//    // 下拉刷新
//    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//        [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
//        [weakSelf loadData];
//        [weakSelf.tableView.mj_header endRefreshing];
//        
//    }];
    
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

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[XYMessageViewCell class] forCellReuseIdentifier:@"XYMessageViewCell"];
    tableView.tableFooterView = UIView.new;
    self.view = self.tableView = tableView;
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYMessageViewCell" forIndexPath:indexPath];
    XYMessageModel *model = self.datalist[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMessageModel *model = self.datalist[indexPath.row];
    XYBAWebViewController *messageDetail = XYBAWebViewController.new;
    [messageDetail ba_web_loadHTMLString:model.content];
    messageDetail.title = model.title;
    model.popState = 1;
    [self addNoticeRelationWithModel:model];
    [self.navigationController pushViewController:messageDetail animated:YES];
    [tableView reloadData];
}

- (void)addNoticeRelationWithModel:(XYMessageModel *)model {
//    api/Notice/AddNoticeRelation
    [AFNetworkManager postNetworkWithUrl:@"api/Notice/AddNoticeRelation" parameters:@{@"Notice_GID":model._id} succeed:^(NSDictionary *dic) {
        
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
