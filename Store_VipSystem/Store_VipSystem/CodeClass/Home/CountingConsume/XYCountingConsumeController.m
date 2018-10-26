//
//  XYCountingConsumeController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCountingConsumeController.h"
#import "XYHomeBasicView.h"
#import "SLScanQCodeViewController.h"
#import "XYCountingConsumeCell.h"
#import "XYVipCheckControl.h"
#import "XYVipSelectionController.h"

#import "XYCountingPaymentController.h"

@interface XYCountingConsumeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIButton *confirmBtn;

@property (nonatomic, weak)XYVipCheckControl *check;

@property (nonatomic, strong)XYMemberManageModel *vipModel;
@property (nonatomic, strong) XYVipSelectionController *vipSelect;

@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYCountingConsumeController

- (void)loadDataWithCard:(NSString *)card {
//    api/WouldOrder/QueryChargeAccountList
//
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/WouldOrder/QueryChargeAccountList" parameters:@{@"Card":card} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.datalist = [XYCountingConsumeModel modelConfigureWithArray:dic[@"data"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"计次消费";
    [self setNaviUI];
    [self setupUI];
}

- (void)setNaviUI {
    XYVipCheckControl *check = [[XYVipCheckControl alloc] initWithFrame:CGRectMake(0, 0, 110, 35)];
    [check addTarget:self action:@selector(selectVip) forControlEvents:(UIControlEventTouchUpInside)];
    [check.screenView addTarget:self action:@selector(screenDel:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:check];
    self.check = check;
}

- (void)screenDel:(UIButton *)btn {
    if (btn.selected) {
        self.check.title = nil;
        btn.selected = NO;
        self.vipModel = nil;
    } else {
        [self selectVip];
    }
}

- (void)setVipModel:(XYMemberManageModel *)vipModel {
    _vipModel = vipModel;
    self.datalist = nil;
    if (vipModel) {
        [self loadDataWithCard:vipModel.vCH_Card];
    }
    [self.tableView reloadData];
}

- (XYVipSelectionController *)vipSelect {
    if (!_vipSelect) {
        _vipSelect = [[XYVipSelectionController alloc] init];
        WeakSelf;
        _vipSelect.selectModel = ^(XYMemberManageModel *model) {
            weakSelf.vipModel = model;
            weakSelf.check.title = model.vIP_Name.length ? model.vIP_Name:model.vCH_Card;
            weakSelf.check.screenView.selected = YES;
            //            DS_Value    快速消费折扣比例
            //            VS_Value    快速消费积分比例
            
            // titleView hidden
        };
    }
    return _vipSelect;
}

- (void)selectVip {
    
    [self.navigationController pushViewController:self.vipSelect animated:YES];
}

- (void)setupUI {
    
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    [basicView.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:(UIControlEventTouchUpInside)];
//    basicView.searchField.placeholder = @"请输入会员卡号/手机号";
//    basicView.searchField.keyboardType = 4;
    [basicView.searchField addTarget:self action:@selector(searchDataAcion:) forControlEvents:(UIControlEventEditingChanged)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYCountingConsumeCell class] forCellReuseIdentifier:@"XYCountingConsumeCell"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    tableView.tableFooterView = UIView.new;
    [self.basicView addSubview:self.tableView=tableView];
    WeakSelf;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.basicView.mas_bottom).offset(-60);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = RGBColor(130, 131, 132);
    countLabel.text = @"0种商品，共0次";
    [self.basicView addSubview:self.countLabel=countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.backgroundColor = RGBColor(252, 105, 67);
    //    sendMsgBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    sendMsgBtn.layer.shadowOpacity = 0.5;
    //    sendMsgBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.basicView addSubview:self.confirmBtn=confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        weakSelf.basicView.searchField.text = string;
        [weakSelf searchVipWithCode:string];
    }];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];
}

// 搜索
- (void)searchDataAcion:(UITextField *)textField {
    [self searchVipWithCode:textField.text];
}

// 搜索会员
- (void)searchVipWithCode:(NSString *)code {
    [self.vipSelect searchFromLastPageWithCode:code];
}

- (void)confirmAction {
    NSMutableArray *array = [NSMutableArray array];
    for (XYCountingConsumeModel *model in self.datalist) {
        if (model.count) {
            [array addObject:model];
        }
    }
    if (!array.count) {
        [XYProgressHUD showMessage:@"没有选择商品次数"];
        return;
    }
    XYCountingPaymentController *payment = [[XYCountingPaymentController alloc] init];
    payment.vipModel = self.vipModel;
    payment.countingModels = array;
    [self.navigationController pushViewController:payment animated:YES];
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYCountingConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYCountingConsumeCell" forIndexPath:indexPath];
    XYCountingConsumeModel *model = self.datalist[indexPath.row];
    cell.model = model;
    WeakSelf;
    cell.countHasChanged = ^{
        [weakSelf setCount];
    };
    return cell;
}

- (void)setCount {
    self.countLabel.text = @"0种商品，共0次";
    NSInteger count = 0;
    NSInteger total = 0;
    for (XYCountingConsumeModel *model in self.datalist) {
        if (model.count) {
            count += model.count;
            total++;
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld种商品，共%ld次", total, count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 登录
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    UILabel *nameLabel = [headerView.contentView viewWithTag:101];
    UILabel *cardLabel = [headerView.contentView viewWithTag:102];
    UILabel *balanceLabel = [headerView.contentView viewWithTag:103];
    UILabel *integralLabel = [headerView.contentView viewWithTag:104];
    if (!nameLabel) {
        for (int i = 0; i< 4; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ((ScreenWidth - 10)/4) *i, 0, (ScreenWidth - 10)/4, 50)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.tag = 101 +i;
            [headerView.contentView addSubview:titleLabel];
        }
    }
//    model.vIP_Name.length ? model.vIP_Name:model.vCH_Card
    nameLabel.attributedText = [self attributedStrWithTitle:@"姓名:" detail:self.vipModel.vIP_Name];
    cardLabel.attributedText = [self attributedStrWithTitle:@"卡号:" detail:self.vipModel.vCH_Card];
    balanceLabel.attributedText = [self attributedStrWithTitle:@"余额:" detail:[NSString stringWithFormat:@"%.2lf", self.vipModel.mA_AvailableBalance]];
    integralLabel.attributedText = [self attributedStrWithTitle:@"积分:" detail:@(self.vipModel.mA_AvailableIntegral).stringValue];
    
    
    return headerView;
}

- (NSAttributedString *)attributedStrWithTitle:(NSString *)title detail:(NSString *)detail {
    if (!detail || !detail.length) {
        detail = @"无";
    }
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title, detail]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(title.length, detail.length)];
    return attributedStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 50;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self setCount];
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
