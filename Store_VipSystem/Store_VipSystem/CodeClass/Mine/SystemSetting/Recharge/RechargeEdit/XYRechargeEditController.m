//
//  XYRechargeEditController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRechargeEditController.h"
#import "XYRechargeEditCell.h"

@interface XYRechargeEditController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, weak)UITableView *tableView;

@end

@implementation XYRechargeEditController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"RechargeEdit" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [XYRechargeEditModel modelConfigureWithArray:parseDic[@"data"] rechargeModel:self.model];
    [self.tableView reloadData];
}

- (void)setNaviUI {
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat width = 50;
    CGFloat height = 35;
    saveBtn.frame = CGRectMake(0, 0, width, height);
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
}

// 保存
- (void)saveAction {
    NSString *url;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];

    if (self.model) {
        // 修改
        url = @"api/RechargePackage/Edit";
        vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
    } else {
        // 添加
        //        /api/VIP/AddVIP
        url = @"api/RechargePackage/Add";
    }
    

    NSMutableDictionary *parameters = [XYRechargeEditModel parametersWithDataList:self.dataList];
    if (!parameters) {
        return;
    }
    [parameters setValue:@"1" forKey:@"RP_Type"];
    if (self.model) {
        [parameters setValue:_model.gID forKey:@"GID"];
    }
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:url parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf.navigationController popToViewController:vc animated:YES];
                if (self.model) {
                    [self.model setValuesForKeysWithDictionary:parameters];
                } else {
                    if (vc.dataOverload) {
                        vc.dataOverload();
                    }
                }
            } else {
                [XYProgressHUD showMessage:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增快捷充值";
    if (self.model) {
        self.title = @"编辑快捷充值";
    }
    [self loadData];
    [self setNaviUI];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark --- 键盘弹出 消失 通知
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    UITableViewCell *cell = (UITableViewCell *)firstResponder.superview.superview;
    CGFloat showHeight = CGRectGetHeight(self.tableView.frame) - keyboardRect.size.height;
    if (CGRectGetMaxY(cell.frame) > showHeight) {
        [self.tableView setContentOffset:CGPointMake(0, CGRectGetMaxY(cell.frame) - showHeight) animated:YES];
    }
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    [self.tableView reloadData];
}


- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYRechargeEditCell class] forCellReuseIdentifier:@"XYRechargeEditCell"];
    [tableView registerClass:[XYRechargeEditHeaderView class] forHeaderFooterViewReuseIdentifier:@"XYRechargeEditHeaderView"];
    [self.view addSubview:self.tableView=tableView];
    tableView.tableFooterView = UIView.new;
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf.view);
    }];
}


#pragma mark tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XYRechargeEditModel *model = self.dataList[section];
    return model.selectList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYRechargeEditHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XYRechargeEditHeaderView"];
    XYRechargeEditModel *model = self.dataList[section];
    headerView.model = model;
    return headerView;
}

/*
- (void)labelSelectAction:(UIButton *)btn {
    for (int i = 0; i < self.eM_TipList.count; i++) {
        XYEM_TipModel *model = self.eM_TipList[i];
        UIButton *button = [cell.contentView viewWithTag:100 + i];
        if (!button) {
            button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(labelSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.titleLabel.numberOfLines = 0;
            button.frame = CGRectMake(10 + ((ScreenWidth - 52)/2 + 16)*(i%2), 10 + 56 * (i/2), (ScreenWidth - 52)/2, 36);
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:RGBColor(249, 104, 62) forState:(UIControlStateSelected)];
            
            button.layer.borderWidth = 1;
            [cell.contentView addSubview:button];
        }
        [button setTitle:model.title forState:(UIControlStateNormal)];
        button.selected = model.isSelected;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        if (button.selected) {
            button.layer.borderColor = RGBColor(249, 104, 62).CGColor;
        }
    if (!self.readOnly) {
        XYEM_TipModel *model = self.eM_TipList[btn.tag-100];
        model.isSelected = !model.isSelected;
        [self.tableView reloadData];

    }
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYRechargeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYRechargeEditCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XYRechargeEditModel *rechargeEditModel = self.dataList[indexPath.section];

    XYValidTimeModel *model = rechargeEditModel.selectList[indexPath.row];
    cell.model = model;
    cell.selectModel = ^(XYValidTimeModel *model) {
        for (XYValidTimeModel *obj in rechargeEditModel.selectList) {
            if (!model.isSelected && !obj.rP_ValidType) {
                obj.isSelected = YES;
            }
            if (![obj isEqual:model] && model.isSelected) {
                obj.isSelected = NO;
            }
            obj.detail = @"";
            obj.endDetail = @"";
        }
        [tableView reloadData];
    };
    return cell;
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
