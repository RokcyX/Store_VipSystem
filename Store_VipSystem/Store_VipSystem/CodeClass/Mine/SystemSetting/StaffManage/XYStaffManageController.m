//
//  XYStaffManageController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYStaffManageController.h"
#import "XYVerticalSegmentedControl.h"

#import "XYDeptEditController.h"

@interface XYStaffManageController ()

@property (nonatomic, weak)XYVerticalSegmentedControl *leftVerticalSegmentedControl;
@property (nonatomic, weak)XYVerticalSegmentedControl *rightVerticalSegmentedControl;
@property (nonatomic, strong)NSMutableArray *deptList;
@property (nonatomic, strong)NSMutableArray *staffAllList;
@property (nonatomic, weak)NSMutableArray *staffList;
@property (nonatomic, weak)XYDeptModel *selectModel;

@property (nonatomic, assign)BOOL isAll;

@end

@implementation XYStaffManageController

- (void)getDeptList {
//    /api/Dept/GetDeptList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Dept/GetDeptList" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.deptList = [XYDeptModel modelConfigureWithArray:dic[@"data"]];
            if (weakSelf.staffAllList) {
                [weakSelf integratorData];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.deptList.count) {
                [XYProgressHUD showMessage:@"暂无数据"];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)queryEmplList {
//    api/Empl/QueryEmpl
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Empl/QueryEmpl" parameters:@{@"DM_GID":@""} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.staffAllList = [XYEmplModel modelConfigureWithArray:dic[@"data"]];
            if (weakSelf.deptList) {
                [weakSelf integratorData];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.staffAllList.count) {
                [XYProgressHUD showMessage:@"暂无数据"];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)integratorData {
    for (XYDeptModel *dept in self.deptList) {
        dept.staffList = [NSMutableArray array];
        for (XYEmplModel *empl in self.staffAllList) {
            if ([empl.dM_GID isEqualToString:dept.gID]) {
                [dept.staffList addObject:empl];
            }
        }
    }
    self.isAll = YES;
    self.staffList= self.staffAllList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftVerticalSegmentedControl reloadData];
        [self.rightVerticalSegmentedControl reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftVerticalSegmentedControl reloadData];
    [self.rightVerticalSegmentedControl reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"员工管理";
    [self getDeptList];
    [self queryEmplList];
    [self setupUI];
    if (self.selectViewModel) {
        [self setNaviUI];
    }
}

- (void)setNaviUI {
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat width = 50;
    CGFloat height = 35;
    addBtn.frame = CGRectMake(0, 0, width, height);
    [addBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(selectFinished) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    //    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)selectFinished {
    NSMutableArray *selectlist = [NSMutableArray array];
    for (XYEmplModel *model in self.staffAllList) {
        if (model.isSelected) {
            [selectlist addObject:model];
        }
    }
    self.selectViewModel(selectlist);
    [self.navigationController popViewControllerAnimated:YES];
}

- (XYVerticalSegmentedControl *)leftleftVerticalSegmentedControl {
    if (!_leftVerticalSegmentedControl) {
        XYVerticalSegmentedControl *leftVerticalSegmentedControl = [[XYVerticalSegmentedControl alloc] init];
        WeakSelf;
        // 左边👈
        leftVerticalSegmentedControl.sectionColor = RGBColor(247, 248, 249);
        leftVerticalSegmentedControl.rowColor = [UIColor whiteColor];
        leftVerticalSegmentedControl.tableView.backgroundColor = RGBColor(247, 248, 249);
        if (self.selectViewModel) {
            leftVerticalSegmentedControl.sectionHeight = 0;
        }
        if (!self.selectViewModel) {
            leftVerticalSegmentedControl.viewForHeaderInSection = ^UIView *(NSInteger section) {
                return [weakSelf addClassifyBtnWithIndex:1];
            };
        }
        
        leftVerticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
            return weakSelf.deptList.count + 1;
        };
        
        [leftVerticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
            if (!indexPath.row) {
                return @"全部";
            }
            return [weakSelf.deptList[indexPath.row-1] dM_Name];
        } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
            if (!indexPath.row) {
                return weakSelf.isAll;
            }
            return [weakSelf.deptList[indexPath.row-1] isSelected];
        }];
        
        leftVerticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            weakSelf.isAll = NO;
            for (XYDeptModel *obj in weakSelf.deptList) {
                obj.isSelected = NO;
            }
            if (!indexPath.row) {
                weakSelf.isAll = YES;
                weakSelf.staffList = weakSelf.staffAllList;
            } else {
                XYDeptModel *model = weakSelf.deptList[indexPath.row-1];
                model.isSelected = YES;
                weakSelf.selectModel = model;
                weakSelf.staffList = model.staffList;
            }
            [weakSelf.rightVerticalSegmentedControl reloadData];
            [weakSelf.leftVerticalSegmentedControl reloadData];
        };
        
        leftVerticalSegmentedControl.longPressRow = ^(NSIndexPath *indexPath) {
            if (indexPath.row) {
                XYDeptModel *model = weakSelf.deptList[indexPath.row-1];
                XYDeptEditController *alert = [[XYDeptEditController alloc] initWithModel:model defaultActin:^{
                    [weakSelf.leftVerticalSegmentedControl reloadData];
                    [weakSelf.rightVerticalSegmentedControl reloadData];
                } deleteActin:^{
                    if (model.isSelected) {
                        weakSelf.isAll = YES;
                        weakSelf.staffList = weakSelf.staffAllList;
                    }
                    [weakSelf.deptList removeObject:model];
                    [weakSelf.leftVerticalSegmentedControl reloadData];
                    [weakSelf.rightVerticalSegmentedControl reloadData];
                }];
                [weakSelf presentViewController:alert animated:NO completion:nil];
            }

        };
        [self.view addSubview:self.leftVerticalSegmentedControl=leftVerticalSegmentedControl];
    }
    return _leftVerticalSegmentedControl;
}

- (XYVerticalSegmentedControl *)rightVerticalSegmentedControl {
    if (!_rightVerticalSegmentedControl) {
        XYVerticalSegmentedControl *rightVerticalSegmentedControl = [[XYVerticalSegmentedControl alloc] init];
        WeakSelf;
        // 右边👉
        if (self.selectViewModel) {
            rightVerticalSegmentedControl.sectionHeight = 0;
            rightVerticalSegmentedControl.selelctShow = YES;
        }
        rightVerticalSegmentedControl.sectionColor = [UIColor whiteColor];
        rightVerticalSegmentedControl.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        rightVerticalSegmentedControl.rowColor = [UIColor whiteColor];
        rightVerticalSegmentedControl.tableView.backgroundColor = [UIColor whiteColor];
        
        if (!self.selectViewModel) {
            rightVerticalSegmentedControl.viewForHeaderInSection = ^UIView *(NSInteger section) {
                return [weakSelf addClassifyBtnWithIndex:2];
            };
        }

        rightVerticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
            return weakSelf.staffList.count;
        };
        [rightVerticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
            return [weakSelf.staffList[indexPath.row] eM_Name];
        } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
            return [weakSelf.staffList[indexPath.row] isSelected];
        }];
        
        rightVerticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            
            XYEmplModel *model = weakSelf.staffList[indexPath.row];
            if (weakSelf.selectViewModel) {
                if (self.key && [[model valueForKey:self.key] boolValue]) {
                    model.isSelected = !model.isSelected;
                    [weakSelf.leftVerticalSegmentedControl reloadData];
                } else {
                    [XYProgressHUD showMessage:@"该员工没有此类型提成"];
                }
            } else {
                XYStaffEditController *addClassi = [[XYStaffEditController alloc] init];
                addClassi.model = model;
                addClassi.readOnly = YES;
                addClassi.deptList = weakSelf.deptList;
                [weakSelf.navigationController pushViewController:addClassi animated:YES];
                weakSelf.dataOverload = ^{
                    [weakSelf.rightVerticalSegmentedControl reloadData];
                };
            }
        };
        [self.view addSubview:self.rightVerticalSegmentedControl=rightVerticalSegmentedControl];
    }
    return _rightVerticalSegmentedControl;
}

- (UIView *)addClassifyBtnWithIndex:(NSInteger)index {
    NSString *title = @"新增部门";
    CGRect rect = CGRectMake(0, 0, ScreenWidth*.4, 50);
    UIColor *backgroundColor = RGBColor(247, 248, 249);
    SEL select = @selector(addDeptAction);
    if (index == 2) {
        title = @"新增员工";
        rect  = CGRectMake(0, 0, ScreenWidth*.6 - 10, 50);
        backgroundColor = [UIColor whiteColor];
        select = @selector(addStaffAction);
    }
    UIView *backView = [[UIView alloc] initWithFrame:rect];
    backView.backgroundColor = backgroundColor;
    UIButton *addIconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addIconBtn.frame = CGRectMake(0, 0, 40, 50);
    [addIconBtn setImage:[UIImage imageNamed:@"classify_add_more"] forState:(UIControlStateNormal)];
    [addIconBtn addTarget:self action:select forControlEvents:(UIControlEventTouchUpInside)];
    addIconBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 10);
    [backView addSubview:addIconBtn];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.frame = CGRectMake(40, 0, CGRectGetWidth(rect) - 40, 50);
    [btn addTarget:self action:select forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:RGBColor(59, 171, 250) forState:(UIControlStateNormal)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView addSubview:btn];
    
    return backView;
}

- (void)setupUI {
    WeakSelf;
    
    [self.leftleftVerticalSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(ScreenWidth*.4);
    }];
    
    [self.rightVerticalSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftVerticalSegmentedControl.mas_right).offset(10);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.leftVerticalSegmentedControl.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}
// action

- (void)addDeptAction {
    WeakSelf;
    XYDeptEditController *alert = [[XYDeptEditController alloc] initWithModel:nil defaultActin:^{
        [weakSelf getDeptList];
    } deleteActin:nil];
    [weakSelf presentViewController:alert animated:NO completion:nil];
}

-(void)addStaffAction {
    WeakSelf;
    XYStaffEditController *addClassi = [[XYStaffEditController alloc] init];
    addClassi.deptList = weakSelf.deptList;
    [self.navigationController pushViewController:addClassi animated:YES];
    self.dataOverload = ^{
        [weakSelf queryEmplList];
    };
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
