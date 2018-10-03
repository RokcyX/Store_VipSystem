//
//  XYScreenViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/18.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYScreenViewController.h"
#import "XYVipLabelModel.h"
#import "XYVipGradeModel.h"
#import "XYEmplModel.h"

@interface XYScreenViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *labelList;
@property (nonatomic, strong)NSArray *vipGradeList;
@property (nonatomic, strong)NSArray *emplList;
@property (nonatomic, strong)NSArray *stateList;
@property (nonatomic, strong)NSArray *birthdayList;
@property (nonatomic, strong)NSNumber *vIP_State; //0正常1锁定2挂失
@property (nonatomic, strong)NSNumber *dayType; // 0本天1本周2本月
@end

@implementation XYScreenViewController

// 会员等级
- (void)loadVIPGradeList {
    //    /api/VIPGrade/QueryDataList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/VIPGrade/QueryDataList" parameters:@{@"GID":@"",@"GradeName":@""} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.vipGradeList = [XYVipGradeModel modelConfigureWithArray:dic[@"data"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

// 会员标签
- (void)loadMemberLabelList {
    //    /api/MemberLabel/QueryDataList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/MemberLabel/QueryDataList" parameters:@{@"ML_Name":@"",@"ML_Type":@""} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.labelList = [XYVipLabelModel modelConfigureWithArray:dic[@"data"] vIP_Label:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

//
- (void)loadEmplList {
    //    api/Empl/GetEmplList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Empl/GetEmplList" parameters:@{@"Type":@"0",@"VGID":@"",@"PGID":@""} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.emplList = [XYEmplModel modelConfigureWithArray:dic[@"data"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    self.stateList = @[@"正常", @"锁定", @"挂失"];
    self.birthdayList = @[@"今天", @"本周", @"本月"];
    [self loadMemberLabelList];
    [self loadVIPGradeList];
    [self loadEmplList];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = RGBColor(244, 245, 246);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((ScreenWidth - 52)/3, 36);
    flowLayout.minimumLineSpacing = 16;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 30);
    flowLayout.minimumInteritemSpacing = 16;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view addSubview:self.collectionView=collectionView];
    WeakSelf;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-60);
    }];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"清空" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(emptyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:RGBColor(130, 131, 132) forState:(UIControlStateNormal)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view).offset(20);
        make.width.mas_equalTo(40);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.backgroundColor = RGBColor(252, 105, 67);
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.top.equalTo(collectionView.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
        make.width.mas_equalTo(85);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:RGBColor(130, 131, 132) forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = RGBColor(130, 131, 132).CGColor;

    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmBtn.mas_left).offset(-30);
        make.top.equalTo(confirmBtn.mas_top);
        make.bottom.equalTo(confirmBtn.mas_bottom);
        make.width.mas_equalTo(confirmBtn.mas_width);
    }];
}

// 清空
- (void)emptyAction {
    for (XYVipGradeModel *model in self.vipGradeList) {
        model.isSelected = NO;
    }
    for (XYVipLabelModel *model in self.labelList) {
        model.isSelected = NO;
    }
    self.vIP_State = nil;
    self.dayType = nil;
    for (XYEmplModel *model in self.emplList) {
        model.isSelected = NO;
    }
    [self.collectionView reloadData];
}

// 取消
- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定
- (void)confirmAction {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (XYVipGradeModel *model in self.vipGradeList) {
        if (model.isSelected) {
            [dic setValue:model.gID forKey:@"VG_GID"];
            break;
        }
    }
    for (XYVipLabelModel *model in self.labelList) {
        if (model.isSelected) {
            [dic setValue:model.mL_Name forKey:@"VIP_Label"];
            break;
        }
    }
    if (self.vIP_State) {
        [dic setObject:self.vIP_State forKey:@"VIP_State"];
    }
    if (self.dayType) {
        [dic setObject:self.dayType forKey:@"DayType"];

    }
    for (XYEmplModel *model in self.emplList) {
        if (model.isSelected) {
            [dic setValue:model.gID forKey:@"EM_GID"];
            break;
        }
    }
    if (self.screenWithData) {
        self.screenWithData(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = self.vipGradeList.count;
            //            count = self.vipGradeList.count;
            break;
        case 1:
            count = self.labelList.count;
            break;
        case 2:
            count = self.stateList.count;
            break;
        case 3:
            count = self.birthdayList.count;
            break;
        case 4:
            count = self.emplList.count;
            break;
        default:
            break;
    }
    return count;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UILabel *titleLabel = [cell.contentView viewWithTag:101];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.contentView.layer.cornerRadius = 5;
        cell.contentView.layer.masksToBounds = YES;
        titleLabel.numberOfLines = 0;
        [self addBorderToLayer:cell.contentView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(cell.contentView);
        }];
    }
    titleLabel.backgroundColor = [UIColor whiteColor];
    NSString *string = @"";
    switch (indexPath.section) {
        case 0:
            string = [self.vipGradeList[indexPath.row] vG_Name];
            if ([self.vipGradeList[indexPath.row] isSelected]) {
                titleLabel.backgroundColor = RGBColor(251, 106, 66);
            }
            break;
        case 1:
            string = [self.labelList[indexPath.row] mL_Name];
            if ([self.labelList[indexPath.row] isSelected]) {
                titleLabel.backgroundColor = RGBColor(251, 106, 66);
            }
            break;
        case 2:
            string = self.stateList[indexPath.row];
            if (self.vIP_State && self.vIP_State.integerValue == indexPath.row) {
                titleLabel.backgroundColor = RGBColor(251, 106, 66);
            }
            break;
        case 3:
            string = self.birthdayList[indexPath.row];
            if (self.dayType && self.dayType.integerValue == indexPath.row) {
                titleLabel.backgroundColor = RGBColor(251, 106, 66);
            }
            break;
        case 4:
            string = [self.emplList[indexPath.row] eM_Name];
            if ([self.emplList[indexPath.row] isSelected]) {
                titleLabel.backgroundColor = RGBColor(251, 106, 66);
            }
            break;
        default:
            break;
    }
    titleLabel.text = string;
//    cell.model = [[LoginModel shareLoginModel].powerList[indexPath.section] modelList][indexPath.row];
    // Configure the cell
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            for (XYVipGradeModel *model in self.vipGradeList) {
                if ([self.vipGradeList indexOfObject:model] == indexPath.row) {
                    model.isSelected = !model.isSelected;
                } else {
                    model.isSelected = NO;
                }
            }
            break;
        case 1:
            for (XYVipLabelModel *model in self.labelList) {
                if ([self.labelList indexOfObject:model] == indexPath.row) {
                    model.isSelected = !model.isSelected;
                } else {
                    model.isSelected = NO;
                }
            }
            break;
        case 2:
            if (self.vIP_State) {
                if (self.vIP_State.integerValue != indexPath.row) {
                    self.vIP_State = @(indexPath.row);
                } else {
                    self.vIP_State = nil;
                }
            } else {
                self.vIP_State = @(indexPath.row);
            }
            
            break;
        case 3:
            if (self.dayType) {
                if (self.dayType.integerValue != indexPath.row) {
                    self.dayType = @(indexPath.row);
                } else {
                    self.dayType = nil;
                }
            } else {
                self.dayType = @(indexPath.row);
            }
            
            break;
        case 4:
            for (XYEmplModel *model in self.emplList) {
                if ([self.emplList indexOfObject:model] == indexPath.row) {
                    model.isSelected = !model.isSelected;
                } else {
                    model.isSelected = NO;
                }
            }
            break;
        default:
            break;
    }
    [collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGFloat) collectionView:(UICollectionView *)collectionView
//                    layout:(UICollectionViewLayout *)collectionViewLayout
//minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.0f;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
////    return CGSizeMake(25 + [[[_array[indexPath.section] list][indexPath.row] b] widthWithLabelWidth:KScreenWidth - 20 font:17], 45);
//}

//在表头内添加内容,需要创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 初始化表头
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.backgroundColor = RGBColor(244, 245, 246);
    UILabel *textLabel = [headerView viewWithTag:101];
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        textLabel.tag = 101;
        [headerView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(headerView);
            make.left.equalTo(headerView).offset(20);
        }];
        textLabel.backgroundColor = RGBColor(244, 245, 246);
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = RGBColor(127, 127, 127);
    }
    
    NSString *string = @"";
    switch (indexPath.section) {
        case 0:
            string = @"会员等级";
            break;
        case 1:
            string = @"会员标签";
            break;
        case 2:
            string = @"会员状态";
            break;
        case 3:
            string = @"会员生日";
            break;
        case 4:
            string = @"开卡人员";
            break;
        default:
            break;
    }
    textLabel.text = string;
    
    return headerView;
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
