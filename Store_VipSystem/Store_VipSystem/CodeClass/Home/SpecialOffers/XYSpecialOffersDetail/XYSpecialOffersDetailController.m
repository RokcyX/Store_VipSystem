//
//  XYSpecialOffersDetailController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYSpecialOffersDetailController.h"
#import "WBPopOverView.h"

@interface XYSpecialOffersDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XYSpecialOffersDetailController

- (void)loadData {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"SpecialOffersEdit" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [XYRechargeEditModel modelConfigureWithArray:parseDic[@"data"] rechargeModel:self.model];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"优惠活动详情";
    [self loadData];
    [self setNaviUI];
    [self setupUI];
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"member_vip_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(operationAvtion)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
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
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    XYRechargeEditModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.title;
    if (model.seletTitle) {
        cell.textLabel.text = model.seletTitle;
    }
    cell.detailTextLabel.text = model.detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}


#pragma mark 响应事件
// right navi
- (void)operationAvtion {
    
    CGPoint point = CGPointMake(ScreenWidth - 28, CGRectGetMaxY(self.navigationController.navigationBar.frame));
    WBPopOverView *popOverView=[[WBPopOverView alloc]initWithOrigin:point Width:180 Height:100 Direction:WBArrowDirectionTopRight];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    popOverView.layer.cornerRadius = 5;
    popOverView.layer.shadowOffset = CGSizeMake(1, 1);
    popOverView.layer.shadowOpacity = 0.5;
    popOverView.layer.shadowColor = [UIColor blackColor].CGColor;
    popOverView.dataList = @[@{@"title":@"删除", @"image":@"Vip_basicInfo_delet"},@{@"title":@"修改", @"image":@"Vip_basicInfo_edit"}];
    WeakSelf;
    popOverView.checkItem = ^(NSInteger index) {
        if (index) {
            [weakSelf editAction];
        } else {
            [weakSelf deleteAction];
        }
    };
    [popOverView popView];
}

// 编辑
- (void)editAction {
    XYSpecialOffersEditController *editVc = [[XYSpecialOffersEditController alloc] init];
    editVc.model = self.model;
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)deleteAction {
    //    api/RechargePackage/Add
    WeakSelf;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    [AFNetworkManager postNetworkWithUrl:@"api/RechargePackage/Delete" parameters:@{@"GID":self.model.gID} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf.navigationController popToViewController:vc animated:YES];
                if (self.model) {
                    if (vc.dataOverload) {
                        vc.dataOverload();
                    }
                }
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
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
