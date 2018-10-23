//
//  XYSettingViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYSettingViewController.h"
#import "XYSettingEditViewController.h"
@interface XYSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *datalist;

@end

@implementation XYSettingViewController



- (NSArray *)datalist {
    if (!_datalist) {
        NSString *storeType = [LoginModel shareLoginModel].shopModel.sM_Type == 0 ? @"免费" : [LoginModel shareLoginModel].shopModel.sM_Type == 1 ? @"高级年费" : @"高级永久";
        if ([LoginModel shareLoginModel].shopModel) {
            _datalist = @[@[@{@"title":@"店铺LOGO", @"detail":@""}],
                          @[@{@"title":@"店铺名称", @"detail":[LoginModel shareLoginModel].shopModel.sM_Name},
                            @{@"title":@"联系人", @"detail":[LoginModel shareLoginModel].shopModel.sM_Contacter},
                            @{@"title":@"联系电话", @"detail":[LoginModel shareLoginModel].shopModel.sM_Phone},
                            @{@"title":@"密码", @"detail":@""}
                            ],
                          @[@{@"title":@"店铺类型", @"detail":[LoginModel shareLoginModel].shopModel.ShopType},
                            @{@"title":@"会员总数", @"detail":[LoginModel shareLoginModel].shopModel.ShopMbers},
                            @{@"title":@"商品数", @"detail":[LoginModel shareLoginModel].shopModel.ShopGoods},
                            @{@"title":@"用户数", @"detail":[LoginModel shareLoginModel].shopModel.ShopUsers},
                            @{@"title":@"短信库存", @"detail":@([LoginModel shareLoginModel].smsStock.UStorage).stringValue},
                            @{@"title":@"到期时间", @"detail":[LoginModel shareLoginModel].shopModel.ShopOverTime}
                            ]
                          ];
        } else {
            _datalist = @[@[@{@"title":@"店铺LOGO", @"detail":@""}],
                          @[@{@"title":@"店铺名称", @"detail":@""},
                            @{@"title":@"联系人", @"detail":@""},
                            @{@"title":@"联系电话", @"detail":@""},
                            @{@"title":@"密码", @"detail":@""}
                            ],
                          @[@{@"title":@"店铺类型", @"detail":storeType},
                            @{@"title":@"会员总数", @"detail":[NSString stringWithFormat:@"%ld/%@",[LoginModel shareLoginModel].shopModel.vipNumber, [LoginModel shareLoginModel].shopModel.sM_Type==0?@"365":@"无上限"]},
                            @{@"title":@"商品数", @"detail":[NSString stringWithFormat:@"%ld/%@",[LoginModel shareLoginModel].shopModel.proNumber, [LoginModel shareLoginModel].shopModel.sM_Type==0?@"100":@"无上限"]},
                            @{@"title":@"用户数", @"detail":[NSString stringWithFormat:@"%ld/%@",[LoginModel shareLoginModel].shopModel.sM_AcountNum, [LoginModel shareLoginModel].shopModel.sM_Type==0?@"1":@"10"]},
                            @{@"title":@"短信库存", @"detail":@""},
                            @{@"title":@"到期时间", @"detail":@""}
                            ]
                          ];
        }
        
        
    }
    return _datalist;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datalist = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺设置";
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview: self.tableView = tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
    }];
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datalist[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    UIImageView *imageView = [cell.contentView viewWithTag:101];
    if (!indexPath.section && !indexPath.row && !imageView) {
        imageView = UIImageView.new;
        imageView.tag = 101;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(2);
            make.right.equalTo(cell.contentView.mas_right).offset(-5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-2);
            make.width.mas_equalTo(17*46/7.0);
        }];
    }
    
    NSDictionary *dic = self.datalist[indexPath.section][indexPath.row];
    NSString *title = dic[@"title"];
    NSString *detail = dic[@"detail"];
    
    if (!indexPath.row && indexPath.row == [self.datalist[indexPath.section] count] - 1) {
        // 上 圆角
        [self setRoundingView:cell RoundingCorners:2];
    }else if (!indexPath.row) {
        // 上 圆角
        [self setRoundingView:cell RoundingCorners:0];
    } else if (indexPath.row == [self.datalist[indexPath.section] count] - 1) {
        // 下 圆角
        [self setRoundingView:cell RoundingCorners:1];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[LoginModel shareLoginModel].shopModel.ShopImg] placeholderImage:[UIImage imageNamed:@"user_setting_Header"]];
    
    return cell;
}




- (void)setRoundingView:(UIView *)view RoundingCorners:(NSInteger)isBottom {
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    if (isBottom == 1) {
        corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else if (isBottom == 2) {
        corners = UIRectCornerAllCorners;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    //设置大小
    maskLayer.frame = view.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10;
    }
    return 5;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"    ";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row != [self.datalist[indexPath.section] count] - 1) {
        NSDictionary *dic = self.datalist[indexPath.section][indexPath.row];
        NSString *title = dic[@"title"];
        XYSettingEditViewController *settingEdit = XYSettingEditViewController.new;
        settingEdit.string = title;
        [self.navigationController pushViewController:settingEdit animated:YES];
    }
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
