//
//  XYVipInfoViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/9.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipInfoViewController.h"

@interface XYVipInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UIImageView *backImageView;
@property (nonatomic, weak)UIImageView *headerImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *detailLabel;
@end

@implementation XYVipInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员信息";
    [self setNaviUI];
    [self setupUI];
   
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"member_vip_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(moreAvtion)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)setupUI {
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"backImage_navi"];
    [self.view addSubview:self.backImageView=backImageView];
    WeakSelf;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(60);
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.layer.cornerRadius = 8;
    headerImageView.layer.masksToBounds = YES;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.vIP_HeadImg] placeholderImage:[UIImage imageNamed:@"member_vip_cellHeader"]];
    [backImageView addSubview:self.headerImageView=headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(15);
        make.top.equalTo(backImageView.mas_top).offset(10);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-10);
        make.width.equalTo(headerImageView.mas_height);
    }];
    
    
    // 143 144 145
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.model.vIP_Name;
    [backImageView addSubview:self.titleLabel=titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_centerY);
        make.left.equalTo(headerImageView.mas_right).offset(10);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = [NSString stringWithFormat:@"%@ | %@", self.model.vG_Name, self.model.vCH_Card];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 2];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.backgroundColor = RGBColor(233, 113, 30);
    detailLabel.layer.cornerRadius = 3;
    detailLabel.layer.masksToBounds = YES;
    [backImageView addSubview:self.detailLabel=detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_centerY);
        make.left.equalTo(titleLabel.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(detailLabel.calculateWidth + 5);
    }];
    
    UIButton *basicInfoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [basicInfoBtn setTitle:@"基本信息" forState:(UIControlStateNormal)];
    [basicInfoBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [basicInfoBtn addTarget:self action:@selector(basicInfoAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"member_right_more"];
    [basicInfoBtn addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(basicInfoBtn.mas_right);
        make.centerY.equalTo(basicInfoBtn.titleLabel.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
    [backImageView addSubview:basicInfoBtn];
    [basicInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.right.equalTo(backImageView.mas_right).offset(-10);
        make.height.equalTo(backImageView.mas_height);
        make.width.mas_equalTo(120);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = RGBColor(244, 245, 246);
    tableView.bounces = NO;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(backImageView.mas_bottom);
    }];
}

#pragma mark tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGBColor(244, 245, 246);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *title;
    NSString *detail;
//    MA_AggregateAmount 累计消费
    if (indexPath.section) {
        title = @"计次卡";
        detail = @(self.model.mCA_HowMany).stringValue;
    } else {
        switch (indexPath.row) {
            case 0:
                title = @"历史消费";
                detail =[NSString stringWithFormat:@"%.2lf", self.model.mA_AggregateAmount];
                break;
            case 1:
                title = @"储值余额";
                detail = [NSString stringWithFormat:@"%.2lf", self.model.mA_AggregateStoredValue];
                break;
            case 2:
                title = @"会员积分";
                detail = @(self.model.mA_AvailableIntegral).stringValue;
                break;
                
            default:
                break;
        }
    }
    cell.textLabel.text =title;
    cell.detailTextLabel.text = detail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [XYProgressHUD showMessage:ToDo];
}

// 操作 事件
- (void)moreAvtion {
    /*
    CGPoint point = CGPointMake(ScreenWidth - 28, CGRectGetMaxY(self.navigationController.navigationBar.frame));
    WBPopOverView *popOverView=[[WBPopOverView alloc]initWithOrigin:point Width:180 Height:100 Direction:WBArrowDirectionTopRight];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    popOverView.layer.cornerRadius = 5;
    popOverView.layer.shadowOffset = CGSizeMake(1, 1);
    popOverView.layer.shadowOpacity = 0.5;
    popOverView.layer.shadowColor = [UIColor blackColor].CGColor;
//    popOverView.dataList = @[@{@"title":@"删除", @"image":@"Vip_basicInfo_delet"},@{@"title":@"修改", @"image":@"Vip_basicInfo_edit"}];
//    WeakSelf;
    popOverView.checkItem = ^(NSInteger index) {
        if (index) {
//            [weakSelf editAction];
        } else {
//            [weakSelf deleteAction];
        }
    };
    [popOverView popView];
     */
}

// 跳转基本信息
- (void)basicInfoAction {
    XYVipBasicInfoController *vioBasic = [[XYVipBasicInfoController alloc] init];
    vioBasic.model = self.model;
    [self.navigationController pushViewController:vioBasic animated:YES];
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
