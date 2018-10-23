//
//  XYShowGoodsController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYShowGoodsController.h"
#import <UIButton+WebCache.h>
#import "WBPopOverView.h"
#import "XYAddGoodsModel.h"
@interface XYShowGoodsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UIImageView *headerImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *detailLabel;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XYShowGoodsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"member_vip_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(operationAvtion)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)loadData {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"VipBasicInfo" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [NSMutableArray array];
    NSDictionary *dic = parseDic[@"GoodsInfo"];
    if (self.model.pM_IsService == 2) {
        dic = parseDic[@"GiftsInfo"];
    } else if (self.model.pM_IsService  == 1) {
        dic = parseDic[@"ServiceInfo"];
    }
    for (NSString *key in dic.allKeys) {
        if (key.integerValue > self.dataList.count) {
            [self.dataList insertObject:[XYAddGoodsModel modelConfigureWithArray:dic[key] commodityModel:self.model] atIndex:self.dataList.count];
        } else {
            [self.dataList insertObject:[XYAddGoodsModel modelConfigureWithArray:dic[key] commodityModel:self.model] atIndex:key.integerValue-1];
        }
    }
    [self.tableView reloadData];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商品详情";
    [self setNaviUI];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    WeakSelf;
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.layer.cornerRadius = 8;
    headerImageView.layer.masksToBounds = YES;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pM_BigImg] placeholderImage:[UIImage imageNamed:@"commodity_product_placeholder"]];
    [self.view addSubview:self.headerImageView=headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.height.mas_equalTo(80);
        make.width.equalTo(headerImageView.mas_height);
    }];
    // 143 144 145
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.model.pM_Name;
    [weakSelf.view addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(headerImageView.mas_right).offset(15);
        make.height.mas_equalTo(49.5);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(244, 245, 246);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = [@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2lf", self.model.pM_UnitPrice]];
    detailLabel.textColor = RGBColor(249, 0, 0);
    detailLabel.font = [UIFont systemFontOfSize:16];
    [weakSelf.view addSubview:self.detailLabel=detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(titleLabel.mas_left);
        make.height.mas_equalTo(49.5);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView=tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.view);
        make.top.equalTo(detailLabel.mas_bottom);
    }];
}

#pragma mark tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYAddGoodsModel *model = self.dataList[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"商品名称"] || [model.title isEqualToString:@"商品售价"]) {
        return 0;
    }
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XYAddGoodsModel *model = self.dataList[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"商品名称"] || [model.title isEqualToString:@"商品售价"]) {
        cell.textLabel.text =@"";
        cell.detailTextLabel.text = @"";
        return cell;
    }
    cell.textLabel.text =model.title;
    cell.detailTextLabel.text = model.detail;
    if ([model.modelKey isEqualToString:@"PM_IsDiscount"]) {
        cell.detailTextLabel.text = [model.updateValue integerValue] ? @"开启":@"关闭";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    XYAddGoodsController *editGoods = [[XYAddGoodsController alloc] init];
    editGoods.model = self.model;
    [self.navigationController pushViewController:editGoods animated:YES];
}

- (void)deleteAction {
//    /api/ProductManger/DelProduct
    WeakSelf;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    [AFNetworkManager postNetworkWithUrl:@"api/ProductManger/DelProduct" parameters:@{@"GID":self.model.gID} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
