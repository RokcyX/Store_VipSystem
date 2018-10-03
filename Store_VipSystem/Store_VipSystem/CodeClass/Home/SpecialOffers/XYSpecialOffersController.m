//
//  XYSpecialOffersController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/14.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYSpecialOffersController.h"

@interface XYSpecialOffersController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *datalist;

@end

@implementation XYSpecialOffersController

- (void)loadData {
//    /api/RechargePackage/GetValidList
    NSString *url = @"api/RechargePackage/GetAllList";
    NSDictionary * parameters = @{@"RP_Type":@2};
    if (self.selectViewModel) {
        url = @"api/RechargePackage/GetValidList";
        self.datalist = [LoginModel shareLoginModel].reducedValidList.mutableCopy;
    }
    WeakSelf;
    if (!self.datalist) {
        [AFNetworkManager postNetworkWithUrl:url parameters:parameters succeed:^(NSDictionary *dic) {
            if ([dic[@"success"] boolValue]) {
                weakSelf.datalist = [XYRechargeModel modelConfigureWithArray:dic[@"data"] type:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
            
        } failure:^(NSError *error) {
            
        } showMsg:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠活动";
    [self loadData];
    [self setupUI];
}


- (void)setupUI {
    WeakSelf;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView = tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf.view);
    }];
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addBtn setImage:[UIImage imageNamed:@"member_vip_add"] forState:(UIControlStateNormal)];
    if (self.selectViewModel) {
        addBtn.hidden = YES;
    }
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    addBtn.backgroundColor = [UIColor whiteColor];
    //    addBtn.layer.cornerRadius = 30;
    //    addBtn.layer.shadowOffset = CGSizeMake(1, 1);
    //    addBtn.layer.shadowOpacity = 0.5;
    //    addBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(tableView.mas_bottom).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
}

- (void)addAction {
    XYSpecialOffersEditController *editVc = [[XYSpecialOffersEditController alloc] init];
    WeakSelf;
    self.dataOverload = ^{
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:editVc animated:YES];
}

- (BOOL)dateOutWithModel:(XYRechargeModel *)model {
    BOOL dateOut = NO;
    switch (model.rP_ValidType) {
        case 0:
            dateOut = YES;
            break;
        case 1:
            dateOut = [[NSDate date] dateBetweenDate:[model.rP_ValidStartTime dateWithFormatter:@"yyyy-MM-dd"] endDate:[model.rP_ValidEndTime dateWithFormatter:@"yyyy-MM-dd"]];
            break;
        case 2:
            
            for (NSString *date in [model.rP_ValidWeekMonth componentsSeparatedByString:@","]) {
                if ([date isEqualToString:[NSString weekDayStringWithDate:[NSDate date]]]) {
                    dateOut = YES;
                }
            }
            break;
        case 3:
            for (NSString *date in [model.rP_ValidWeekMonth componentsSeparatedByString:@","]) {
                if ([date isEqualToString:[NSString dayStringWithDate:[NSDate date]]]) {
                    dateOut = YES;
                }
            }
            break;
        case 4:
            dateOut = YES;
            break;
        default:
            break;
    }
    return dateOut;
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    XYRechargeModel *model = self.datalist[indexPath.row];
    cell.textLabel.text = model.rP_Name;
    UIImageView *imageView = [cell.contentView viewWithTag:102];
    if (!imageView) {
        imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"recharge_over_data"];
        imageView.tag = 102;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
            make.width.equalTo(imageView.mas_height);
        }];
    }
    imageView.hidden = [self dateOutWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYRechargeModel *model = self.datalist[indexPath.row];
    if (self.selectViewModel) {
        [self.navigationController popViewControllerAnimated:YES];
        self.selectViewModel(model);
        return;
    }
    XYSpecialOffersDetailController *detailVc = [[XYSpecialOffersDetailController alloc] init];
    detailVc.model = model;
    WeakSelf;
    self.dataOverload = ^{
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:detailVc animated:true];
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
