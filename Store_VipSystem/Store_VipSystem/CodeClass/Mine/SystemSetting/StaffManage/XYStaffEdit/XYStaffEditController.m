//
//  XYStaffEditController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYStaffEditController.h"
#import "XYStaffEditCell.h"
#import "WBPopOverView.h"
#import "XYEM_TipModel.h"
#import "XYTextView.h"

@interface XYStaffEditController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong)NSArray *eM_TipList;
//@property (nonatomic, strong)NSArray *;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)XYTextView *remarkView;
@end

@implementation XYStaffEditController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    self.eM_TipList = [XYEM_TipModel eM_TipModelWithEmplModel:self.model];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"StaffEdit" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [XYStaffEditModel modelConfigureWithArray:parseDic[@"data"] emplModel:self.model];
    [self.tableView reloadData];
}

// 会员等级
- (void)loadShopsModelList {
    //    api/Shops/GetShops
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Shops/GetShops" parameters:@{@"GID":@""} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            [LoginModel shareLoginModel].shopModels = [ShopModel modelConfigureArray:dic[@"data"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {

    } showMsg:NO];
}

// 会员标签
- (void)loadMemberLabelList {
    //    /api/MemberLabel/QueryDataList
//    WeakSelf;
//    [AFNetworkManager postNetworkWithUrl:@"api/MemberLabel/QueryDataList" parameters:@{@"ML_Name":@"",@"ML_Type":@""} succeed:^(NSDictionary *dic) {
//        if ([dic[@"success"] boolValue]) {
//            weakSelf.labelList = [XYVipLabelModel modelConfigureWithArray:dic[@"data"] vIP_Label:self.model.vIP_Label];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView reloadData];
//        });
//    } failure:^(NSError *error) {
//
//    } showMsg:NO];
}

- (void)setNaviUI {
    if (self.readOnly) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"member_vip_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(operationAvtion)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    } else {
        if ([LoginModel shareLoginModel].shopModels.count < 2) {
            [self loadShopsModelList];
        }
        UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat width = 50;
        CGFloat height = 35;
        saveBtn.frame = CGRectMake(0, 0, width, height);
        [saveBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(244, 245, 246);
    self.title = @"新增会员";
    if (self.model) {
        self.title = @"基本信息";
    }
    
    [self loadData];
    [self loadMemberLabelList];
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
    
}

//- (NSString *)failureTimeWithNums:(NSInteger)nums unit:(NSString *)unit {
//    NSTimeInterval interval = 60 * 60 * 24;
//    if ([unit isEqualToString:@"天"]) {
//        interval = nums * interval;
//    } else if ([unit isEqualToString:@"月"]) {
//        interval = nums * (interval * 30);
//    } else if ([unit isEqualToString:@"年"]) {
//        interval = nums * (interval * 365);
//    }
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    return [dateFormatter stringFromDate:date];
//}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYStaffEditCell class] forCellReuseIdentifier:@"XYStaffEditCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.tableView=tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf.view);
    }];
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
    XYStaffEditController *addClassi = [[XYStaffEditController alloc] init];
    addClassi.model = self.model;
    addClassi.deptList = self.deptList;
    addClassi.readOnly = NO;
    [self.navigationController pushViewController:addClassi animated:YES];
  
}

- (void)deleteAction {
    //    /api/Empl/DelEmpl
    WeakSelf;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    [AFNetworkManager postNetworkWithUrl:@"api/Empl/DelEmpl" parameters:@{@"GID":self.model.gID} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.model) {
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

// 保存
- (void)saveAction {
    NSString *url;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    if (self.model) {
        // 修改
        url = @"api/Empl/EditEmpl";
        vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
    } else {
        // 添加
        //        /api/VIP/AddVIP
        url = @"api/Empl/AddEmpl";
    }
    
    NSDictionary *parameters = [self parameters];
    if (!parameters) {
        return;
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

- (NSDictionary *)parameters {
    /*
     VIP_HeadImg        会员照片    String        是    0-100
     VIP_Label        会员标签    String        是    0-500
     GID        会员GID    String        否    0-100
     */
    NSMutableDictionary *parameters = [XYStaffEditModel parametersWithDataList:self.dataList];
    if (!parameters) {
        return nil;
    }
    if (self.model) {
        [parameters setValue:self.model.gID forKey:@"GID"];
    }
    
    for (XYEM_TipModel *model in self.eM_TipList) {
        [parameters setValue:@(model.isSelected) forKey:model.updateKey];
    }
    
    if (!self.remarkView.text.length) {
        self.remarkView.text = @"";
    }
    
    [parameters setValue:self.remarkView.text forKey:@"EM_Remark"];
    
    return parameters;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return self.dataList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return (self.eM_TipList.count /2 +  (self.eM_TipList.count % 2)) * 56;
    } else if (indexPath.section == 2) {
        return 120;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    headerView.contentView.backgroundColor = RGBColor(244, 245, 246);
    headerView.textLabel.font = [UIFont systemFontOfSize:16];
    headerView.textLabel.textColor = RGBColor(127, 127, 127);
    if (section == 1) {
        headerView.textLabel.text = @"提成类型";
    } else if (section == 2) {
        headerView.textLabel.text = @"备注信息";
    } else {
        headerView.textLabel.text = @"基本信息";
    }
    return headerView;
}

- (void)addBorderToLayer:(UIView *)view {
    CAShapeLayer *border = [CAShapeLayer layer];
    // 线条颜色
    border.strokeColor = RGBColor(240, 240, 240).CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    border.cornerRadius = 5;
    // 不要设太大 不然看不出效果
    border.lineWidth = 1;
    border.lineCap = @"square";
    // 第一个是 线条长度 第二个是间距 nil时为实线
    border.lineDashPattern = @[@9, @4];
    [view.layer addSublayer:border];
    
}

- (void)labelSelectAction:(UIButton *)btn {
    if (!self.readOnly) {
        XYEM_TipModel *model = self.eM_TipList[btn.tag-100];
        model.isSelected = !model.isSelected;
        [self.tableView reloadData];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        }
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XYTextView *remarkView = [cell.contentView viewWithTag:101];
        
        if (!remarkView) {
            remarkView = [[XYTextView alloc] init];
            remarkView.font = [UIFont systemFontOfSize:17];
            remarkView.tag = 101;
            remarkView.layer.cornerRadius = 8;
            remarkView.layer.borderWidth = 1;
            remarkView.layer.borderColor = RGBColor(222, 222, 222).CGColor;
            [cell.contentView addSubview:self.remarkView=remarkView];
            [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges
                make.top.left.equalTo(cell.contentView).offset(10);
                make.bottom.right.equalTo(cell.contentView).offset(-10);

            }];
        }
        remarkView.editable = YES;
        remarkView.placeholder = @"请输入备注信息";
        if (self.readOnly) {
            remarkView.placeholder = @"";
            remarkView.editable = NO;
        }
        remarkView.text = self.model.eM_Remark;
        
        return cell;
    }
    XYStaffEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYStaffEditCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XYStaffEditModel *model = self.dataList[indexPath.row];
    if (!self.readOnly && [model.title isEqualToString:@"所属部门"]) {
        model.selectList = self.deptList;
    }
    if (!self.readOnly && [model.title isEqualToString:@"所属店铺"]) {
        model.selectList = [LoginModel shareLoginModel].shopModels;
    }
    [cell setModel:model readOnly:self.readOnly];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataList.count) {
        return;
    }
//    XYVipBasicInfoModel *model = self.dataList[indexPath.section][indexPath.row];
//    if (!self.readOnly && !model.isWritable) {
//        if ([model.title isEqualToString:@"开卡人员"]) {
//            [XYProgressHUD showMessage:ToDo];
//        }
//    }
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
