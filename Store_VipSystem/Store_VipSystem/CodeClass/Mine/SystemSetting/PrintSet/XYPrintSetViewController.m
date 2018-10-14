//
//  XYPrintSetViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYPrintSetViewController.h"
#import "XYPitchOnControl.h"
#import "XYBluetoothSetController.h"

@interface XYPrintSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYPitchOnControl *onControl;
@property (nonatomic, weak)XYPitchOnControl *offControl;
@property (nonatomic, strong)XYPrintSetModel *model;

@end

@implementation XYPrintSetViewController

- (void)loadData {
    //    /api/PrintSet/GetPrintSet
    WeakSelf;
    if ([LoginModel shareLoginModel].printSetModel) {
        weakSelf.model = [LoginModel shareLoginModel].printSetModel;
        [weakSelf.tableView reloadData];
        weakSelf.onControl.selected = weakSelf.model.pS_IsEnabled;
        weakSelf.offControl.selected = !weakSelf.model.pS_IsEnabled;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打印设置";
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    WeakSelf;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"打印开关";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(245, 245, 245);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.right.left.equalTo(titleLabel);
        make.height.mas_equalTo(1);
    }];
    
    XYPitchOnControl *onControl = [[XYPitchOnControl alloc] init];
    onControl.title = @"开启打印";
    onControl.selectControl = ^{
        weakSelf.offControl.selected = !weakSelf.onControl.selected;
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:weakSelf.onControl=onControl];
    [onControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.height.left.equalTo(titleLabel);
        make.right.equalTo(weakSelf.view.mas_centerX);
    }];
    
    XYPitchOnControl *offControl = [[XYPitchOnControl alloc] init];
    offControl.title = @"关闭打印";
    offControl.selected = YES;
    offControl.selectControl = ^{
        weakSelf.onControl.selected = !weakSelf.offControl.selected;
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:self.offControl=offControl];
    [offControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.right.height.equalTo(titleLabel);
        make.left.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saveBtn setTitle:@"保存设置" forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    saveBtn.backgroundColor = RGBColor(252, 105, 67);
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView=tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(onControl.mas_bottom);
        make.bottom.equalTo(saveBtn.mas_top);
    }];
    
}

- (void)saveAction {
//    WeakSelf;
    [self.model.parameters setValue:@(self.onControl.selected) forKey:@"PS_IsEnabled"];
    [AFNetworkManager postNetworkWithUrl:@"api/PrintSet/EditPrintSet" parameters:self.model.parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                Set_UserDefaults(@(self.onControl.selected), PrintIsOn);
            } else {
//                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

#pragma mark -TableViewDataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.offControl.selected) {
        return 0;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"    ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.model.printTimesList.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *title = @"";
    NSString *detail = @"";
    if (!indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        title = @"默认打印机";
        detail = @"选择打印机";
        if ([SEPrinterManager sharedInstance].connectedPerpheral) {
            detail = [SEPrinterManager sharedInstance].connectedPerpheral.name;
        }
    } else {
        if (indexPath.row == 0) {
            title = @"打印份数";
        } else {
            PrintTimes *times = self.model.printTimesList[indexPath.row-1];
            title = times.title;
            UITextField *titleField = [cell.contentView viewWithTag:102];
            if (!titleField) {
                titleField = [[UITextField alloc] init];
                titleField.tag = 102;
                titleField.keyboardType = 4;
                [titleField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
                [cell.contentView addSubview:titleField];
                [titleField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.right.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView.mas_centerX).offset(50);
                }];
            }
            titleField.text = @(times.pT_Times).stringValue;
        }
        
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    return cell;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PrintTimes *times = self.model.printTimesList[indexPath.row-1];
    times.pT_Times = textField.text.integerValue;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [self.navigationController pushViewController:XYBluetoothSetController.new animated:YES];
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
