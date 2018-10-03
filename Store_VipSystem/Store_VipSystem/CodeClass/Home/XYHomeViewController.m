//
//  XYHomeViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHomeViewController.h"
#import "XYHomeViewCell.h"
#import "XYHomeHeaderView.h"
#import "XYHomeSectionView.h"
#import "HomeIndexModel.h"

#import "XYMemberManagementController.h"
#import "XYCommodityManageController.h"
#import "XYVipRechargeController.h"
#import "XYCountingConsumeController.h"
#import "XYVipPunchingController.h"
#import "XYSpecialOffersController.h"


#import "XYReceiptsQuickController.h"
#import "XYConsumeGoodsController.h"

@interface XYHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)HomeIndexModel *model;
@end

@implementation XYHomeViewController

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (void)loadData {
//    /api/Report/GetIndexData
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Report/GetIndexData" parameters:@{@"AGGID":[LoginModel shareLoginModel].aG_GID} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            // 进入首页
            weakSelf.model = [HomeIndexModel modelConfigureDic:dic[@"data"]];
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
    [self loadData];
    [self setupUI];
}

- (void)setupUI {
    // 1080 476
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1080 *476)];
    bannerView.image = [UIImage imageNamed:@"home_banner"];
    [self.view addSubview:bannerView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.allowsSelection = NO; 
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XYHomeViewCell class] forCellReuseIdentifier:@"XYHomeViewCell"];
    [tableView registerClass:[XYHomeSectionView class] forHeaderFooterViewReuseIdentifier:@"XYHomeSectionView"];
    [self.view addSubview: self.tableView = tableView];
    WeakSelf;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(bannerView.mas_bottom);
    }];
    
    XYHomeHeaderView *headerView = [[XYHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 184)];
    headerView.listArray = @[
  @{@"title":@"会员管理", @"image":@"home_vip_manager"},
  @{@"title":@"商品管理", @"image":@"home_shop_manager"},
  @{@"title":@"计次消费", @"image":@"home_counts_shop"},
  @{@"title":@"会员充次", @"image":@"home_inflate_count"},
  @{@"title":@"会员充值", @"image":@"home_vip_inflatemoney"},
  @{@"title":@"积分加减", @"image":@"home_in_reduce_add"},
  @{@"title":@"积分兑换", @"image":@"home_jifen_duihuan"},
  @{@"title":@"套餐消费", @"image":@"home_taocan_xiaofei"},
  @{@"title":@"库存盘点", @"image":@"home_stock_pandian"},
  @{@"title":@"商品出入库", @"image":@"home_goods_in_out"},
  @{@"title":@"优惠活动", @"image":@"home_youhui_activity"},
  @{@"title":@"自定义属性", @"image":@"home_zidingyi"},
  @{@"title":@"开发中...", @"image":@"home_kaifazhong"},
  ];
    headerView.clickItem = ^(NSInteger index) {
        switch (index) {
            case 0:
                [self.navigationController pushViewController:[[XYMemberManagementController alloc] init] animated:YES];
                break;
            case 1:
                 [self.navigationController pushViewController:[[XYCommodityManageController alloc] init] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[[XYCountingConsumeController alloc] init] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[[XYVipPunchingController alloc] init] animated:YES];
                break;
            case 4:
                [self.navigationController pushViewController:[[XYVipRechargeController alloc] init] animated:YES];
                break;
            case 10:
                [self.navigationController pushViewController:[[XYSpecialOffersController alloc] init] animated:YES];
                break;
            default:
                [XYProgressHUD showMessage:ToDo];
                break;
        }
    };
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYHomeSectionView *secView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XYHomeSectionView"];
    secView.titleLabel.text = @"快捷入口 | 高效便捷";
    if (section) {
        secView.titleLabel.text = @"销售概括 | 轻松记账";
    }
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYHomeViewCell" forIndexPath:indexPath];
    if (indexPath.section) {
        if (self.model) {
            [cell setImages:@[@"home_bg_btn1", @"home_bg_btn2", @"home_bg_btn3"] titles:@[[NSString stringWithFormat:@"今日销售\n%@元", self.model.gridData.today_Sale], [NSString stringWithFormat:@"本月销售\n%@元", self.model.gridData.month_Sale], [NSString stringWithFormat:@"本月充值\n%@元", self.model.gridData.month_Recharge]] isBtn:NO];
        }
    } else {
        [cell setImages:@[@"home_fast_get", @"home_fast_sell", @"home_goods_shop"] titles:@[@"快捷收款", @"快速消费", @"商品消费"] isBtn:YES];
        cell.chickAction = ^(NSInteger index) {
            // todo
            if (index == 0) {
//                快捷收款
                XYReceiptsQuickController *receipt = [[XYReceiptsQuickController alloc] init];
                receipt.isReceipts = YES;
                [self.navigationController pushViewController:receipt animated:YES];
            } else if (index == 1) {
//                快速消费
                XYReceiptsQuickController *receipt = [[XYReceiptsQuickController alloc] init];
                [self.navigationController pushViewController:receipt animated:YES];
            } else if (index == 2) {
//                商品消费
                XYConsumeGoodsController *consume = [[XYConsumeGoodsController alloc] init];
                [self.navigationController pushViewController:consume animated:YES];
            }
        };
    }
//    cell.tag = indexPath.row;
//    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  107;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:true];
//    // 跳转逻辑
//    PositionDetailViewController *vc = [[PositionDetailViewController alloc] init];
//    vc.model = self.modelArray[indexPath.row];
//    vc.isComeFromHomeVC = YES;
//    [self.navigationController pushViewController:vc animated:true];
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
