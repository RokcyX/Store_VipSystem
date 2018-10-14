//
//  XYParameterSetController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYParameterSetController.h"
#import "XYParameterSetCell.h"

@interface XYParameterSetController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, weak)NSArray *dataList;

@end

@implementation XYParameterSetController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    if ([LoginModel shareLoginModel].parameterSets.count) {
        self.dataList = [LoginModel shareLoginModel].parameterSets;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"参数设置";
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
    CGFloat showHeight = CGRectGetHeight(self.collectionView.frame) - keyboardRect.size.height;
    if (CGRectGetMaxY(cell.frame) > showHeight) {
        [self.collectionView setContentOffset:CGPointMake(0, CGRectGetMaxY(cell.frame) - showHeight) animated:YES];
    }
    
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ParameterSet_save_ok"] style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}


// 保存
- (void)saveAction {
    //  api/SetSwitch/EditSysSwitch
    
    NSArray *parameters = [XYParameterSetModel parametersWithDataList:self.dataList];
    if (parameters == nil) {
        return;
    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//    if (!data) {
//        return;
//    }
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

//    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/SetSwitch/EditSysSwitch" parameters:@{@"listSwitch":parameters} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                Set_UserDefaults(parameters, ParameterSets);
            } else {
                [XYProgressHUD showMessage:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    [self.collectionView reloadData];
}

- (void)setupUI {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 50);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[XYParameterSetCell class] forCellWithReuseIdentifier:@"XYParameterSetCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.view addSubview:self.collectionView=collectionView];
    WeakSelf;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];

}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataList.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataList[section];
    return [[dic objectForKey:@"models"] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYParameterSetCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"XYParameterSetCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataList[indexPath.section];
    NSArray *models = dic[@"models"];
    XYParameterSetModel *model = models[indexPath.item];
    
    if ([model.title isEqualToString:@"积分支付限制"]) {
        XYParameterSetModel *obj = models[indexPath.item-1];
        model.enabled = obj.sS_State;
        if (!model.enabled) {
            model.sS_State = model.enabled;
        }
    }
    
//    消费密码验证、转账密码验证、兑换密码验证、换卡密码验证才能开启
    if ([model.title isEqualToString:@"消费密码验证"] || [model.title isEqualToString:@"转账密码验证"] || [model.title isEqualToString:@"兑换密码验证"] || [model.title isEqualToString:@"换卡密码验证"]) {
        XYParameterSetModel *obj = models.firstObject;
        model.enabled = obj.sS_State;
        if (!model.enabled) {
            model.sS_State = model.enabled;
        }
        
    }
    cell.model = model;
    WeakSelf;
    cell.selectItem = ^(XYParameterSetModel *selectModel) {
        if ([selectModel.title isEqualToString:@"按消费金额返利"]) {
            XYParameterSetModel *obj = [weakSelf.dataList.lastObject objectForKey:@"models"][2];
            if (selectModel.sS_State && obj.sS_State) {
                obj.sS_State = 0;
            }
        }
        
        if ([selectModel.title isEqualToString:@"按获得积分返利"]) {
            XYParameterSetModel *obj = [weakSelf.dataList.lastObject objectForKey:@"models"][1];
            if (selectModel.sS_State && obj.sS_State) {
                obj.sS_State = 0;
            }
        }
        [collectionView reloadData];
    };
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        if(headerView == nil) {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *titleLabel = [headerView viewWithTag:102];
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] init];
            titleLabel.tag = 102;
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(headerView);
                make.left.equalTo(headerView.mas_left).offset(15);
            }];
        }
        NSDictionary *dic = self.dataList[indexPath.section];
        titleLabel.text = dic[@"title"];
        return headerView;
    }
    return nil;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataList[indexPath.section];
    NSArray *models = dic[@"models"];
    XYParameterSetModel *model = models[indexPath.item];
    if (model.hasValue) {
        return CGSizeMake(ScreenWidth-15, 50);
    }
    return CGSizeMake((ScreenWidth-15)/2, 50);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
