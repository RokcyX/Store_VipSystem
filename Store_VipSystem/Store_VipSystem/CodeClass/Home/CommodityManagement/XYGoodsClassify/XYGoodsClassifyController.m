//
//  XYGoodsClassifyController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYGoodsClassifyController.h"
#import "XYVerticalSegmentedControl.h"
#import "XYAlertViewController.h"
@interface XYGoodsClassifyController ()

@property (nonatomic, weak)XYVerticalSegmentedControl *leftVerticalSegmentedControl;
@property (nonatomic, weak)XYVerticalSegmentedControl *rightVerticalSegmentedControl;
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, weak)NSMutableArray *subDataList;
@property (nonatomic, weak)XYGoodsClassifyModel *selectModel;
@property (nonatomic, weak)XYGoodsClassifyModel *selectSuperFine;
@end

@implementation XYGoodsClassifyController

- (void)loadAllProductTypeList {
    // api/ProductTypeManager/QueryAllProductTypeBySM_ID
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/ProductTypeManager/QueryAllProductTypeBySM_ID" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.dataList = [XYGoodsClassifyModel modelConfigureWithArray:dic[@"data"]];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.dataList.count) {
                [XYProgressHUD showMessage:@"暂无数据"];
            } else {
                [weakSelf.rightVerticalSegmentedControl reloadData];
                [weakSelf.leftVerticalSegmentedControl reloadData];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadAllProductTypeList];
    [self setNaviUI];
    [self setupUI];
    
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(finishedClassifyAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)finishedClassifyAction {
    if (self.selectModel.subList.count) {
        [XYProgressHUD showMessage:@"请继续选择二级分类"];
        return;
    }
    if (self.finishedSelected) {
        self.finishedSelected(self.selectModel);
    }
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
        leftVerticalSegmentedControl.viewForFooterInSection = ^UIView *(NSInteger section) {
            return [weakSelf addClassifyBtnWithIndex:1];
        };
        [leftVerticalSegmentedControl setTitleForSection:^NSString *(NSInteger section) {
            return @"一级分类";
        } isSelectedForSection:^BOOL(NSInteger section) {
            return NO;
        }];
        
        leftVerticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
            return weakSelf.dataList.count;
        };
        
        [leftVerticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
            return [weakSelf.dataList[indexPath.row] pT_Name];
        } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
            return [weakSelf.dataList[indexPath.row] isSelected];
        }];
        
        leftVerticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.dataList[indexPath.row];
            for (XYGoodsClassifyModel *obj in weakSelf.dataList) {
                obj.isSelected = NO;
            }
            model.isSelected = YES;
            weakSelf.selectModel = weakSelf.selectSuperFine = model;
            weakSelf.subDataList = model.subList;
            [weakSelf.rightVerticalSegmentedControl reloadData];
            [weakSelf.leftVerticalSegmentedControl reloadData];
        };
        
        leftVerticalSegmentedControl.longPressRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.dataList[indexPath.row];
            XYAlertViewController *alert = [[XYAlertViewController alloc] initWithModel:model defaultActin:^{
                [weakSelf.leftVerticalSegmentedControl reloadData];
                [weakSelf.rightVerticalSegmentedControl reloadData];
            } deleteActin:^{
                [weakSelf.dataList removeObject:model];
                [weakSelf.leftVerticalSegmentedControl reloadData];
                [weakSelf.rightVerticalSegmentedControl reloadData];
            }];
            [weakSelf presentViewController:alert animated:NO completion:nil];
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
        rightVerticalSegmentedControl.sectionColor = [UIColor whiteColor];
        rightVerticalSegmentedControl.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        rightVerticalSegmentedControl.rowColor = [UIColor whiteColor];
        rightVerticalSegmentedControl.tableView.backgroundColor = [UIColor whiteColor];
        rightVerticalSegmentedControl.viewForFooterInSection = ^UIView *(NSInteger section) {
            if (weakSelf.selectSuperFine) {
                return [weakSelf addClassifyBtnWithIndex:2];
            } else {
                return UIView.new;
            }
        };

        [rightVerticalSegmentedControl setTitleForSection:^NSString *(NSInteger section) {
            return @"二级分类";
        } isSelectedForSection:^BOOL(NSInteger section) {
            return NO;
        }];
        rightVerticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
            return weakSelf.subDataList.count;
        };
        [rightVerticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
            return [weakSelf.subDataList[indexPath.row] pT_Name];
        } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
            return [weakSelf.subDataList[indexPath.row] isSelected];
        }];
        
        rightVerticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.subDataList[indexPath.row];
            for (XYGoodsClassifyModel *obj in weakSelf.subDataList) {
                obj.isSelected = NO;
            }
            weakSelf.selectModel = model;
            model.isSelected = YES;
            [weakSelf.rightVerticalSegmentedControl reloadData];
        };
        
        rightVerticalSegmentedControl.longPressRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.subDataList[indexPath.row];
            XYAlertViewController *alert = [[XYAlertViewController alloc] initWithModel:model defaultActin:^{
                [weakSelf.rightVerticalSegmentedControl reloadData];
            } deleteActin:^{
                [weakSelf.subDataList removeObject:model];
                [weakSelf.rightVerticalSegmentedControl reloadData];
            }];
            [weakSelf presentViewController:alert animated:NO completion:nil];
        };
        [self.view addSubview:self.rightVerticalSegmentedControl=rightVerticalSegmentedControl];
    }
    return _rightVerticalSegmentedControl;
}

- (UIView *)addClassifyBtnWithIndex:(NSInteger)index {
    NSString *title = @"新增一级分类";
    CGRect rect = CGRectMake(0, 0, ScreenWidth*.4, 50);
    UIColor *backgroundColor = RGBColor(247, 248, 249);
    SEL select = @selector(addClassifyAction);
    if (index == 2) {
        title = @"新增二级分类";
        rect  = CGRectMake(0, 0, ScreenWidth*.6 - 10, 50);
        backgroundColor = [UIColor whiteColor];
        select = @selector(addsubClassifyAction);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// action

- (void)addClassifyAction {
    WeakSelf;
    XYAddClassifyController *addClassi = [[XYAddClassifyController alloc] init];
    [self.navigationController pushViewController:addClassi animated:YES];
    addClassi.addClassifyFinished = ^(XYGoodsClassifyModel *model) {
        [weakSelf.dataList addObject:model];
        [weakSelf.leftVerticalSegmentedControl reloadData];
    };
}

-(void)addsubClassifyAction {
    WeakSelf;
    XYAddClassifyController *addClassi = [[XYAddClassifyController alloc] init];
    addClassi.model = self.selectSuperFine;
    [self.navigationController pushViewController:addClassi animated:YES];
    addClassi.addClassifyFinished = ^(XYGoodsClassifyModel *model) {
        if (!weakSelf.selectSuperFine.subList) {
            weakSelf.selectSuperFine.subList = [NSMutableArray array];
            weakSelf.subDataList = weakSelf.selectSuperFine.subList;
        }
        [weakSelf.selectSuperFine.subList addObject:model];
        [weakSelf.rightVerticalSegmentedControl reloadData];
    };
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
