//
//  XYAddClassifyController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/22.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAddClassifyController.h"
#import "XYAddClassifyView.h"
@interface XYAddClassifyController ()
@property (nonatomic, weak)XYAddClassifyView *pClassifyView;
@property (nonatomic, weak)XYAddClassifyView *bClassifyView;
@property (nonatomic, weak)UIButton *syncBtn;
@property (nonatomic, weak)UIButton *notSyncBtn;
@end

@implementation XYAddClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增一级分类";
    if (self.model) {
        self.title = @"新增二级分类";
    }
    [self setupUI];
}

- (UIButton *)addsyncBtnWithNotSync:(BOOL)notSync {
    SEL action = @selector(syncAction);
    if (notSync) {
        action = @selector(notSyncAction);
    }
    UIButton *syncBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    syncBtn.selected = notSync;
    [syncBtn setImage:[UIImage imageNamed:@"check_box_circle_normal"] forState:(UIControlStateNormal)];
    [syncBtn setImage:[UIImage imageNamed:@"check_box_circle_selected"] forState:(UIControlStateSelected)];
    [syncBtn addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    syncBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 5);;
    [self.view addSubview:syncBtn];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.selected = notSync;
    [btn setTitle:@"同步" forState:(UIControlStateNormal)];
    [btn setTitle:@"不同步" forState:(UIControlStateSelected)];
    [btn addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitleColor:RGBColor(130, 131, 132) forState:(UIControlStateNormal)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(syncBtn);
        make.left.equalTo(syncBtn.mas_right);
        make.width.mas_equalTo(60);
    }];
    return syncBtn;
}

- (void)setupUI {
    self.view.backgroundColor = RGBColor(245, 245, 245);
    WeakSelf;
    XYAddClassifyView *pClassifyView = [[XYAddClassifyView alloc] init];
    pClassifyView.titleLabel.text = @"一级分类";
    [self.view addSubview:self.pClassifyView=pClassifyView];
    [pClassifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(100);
    }];
    UIView *bottomView = pClassifyView;
    if (self.model) {
        pClassifyView.textField.enabled = NO;
        pClassifyView.textField.backgroundColor = RGBColor(242, 242, 242);
        pClassifyView.textField.text = self.model.pT_Name;
        XYAddClassifyView *bClassifyView = [[XYAddClassifyView alloc] init];
        bClassifyView.titleLabel.text = @"二级分类";
        [self.view addSubview:self.bClassifyView=bClassifyView];
        [bClassifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(pClassifyView);
            make.top.equalTo(pClassifyView.mas_bottom).offset(20);
        }];
        bottomView = bClassifyView;
    }
    
    self.notSyncBtn = [self addsyncBtnWithNotSync:YES];
    [self.notSyncBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom).offset(20);
        make.left.equalTo(bottomView);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(25);

    }];
    self.syncBtn = [self addsyncBtnWithNotSync:NO];
    [self.syncBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.notSyncBtn);
        make.left.equalTo(bottomView.mas_centerX);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.backgroundColor = RGBColor(252, 105, 67);
//    saveBtn.layer.shadowOffset = CGSizeMake(1, 1);
//    saveBtn.layer.shadowOpacity = 0.5;
//    saveBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.height.mas_equalTo(50);
        make.top.equalTo(weakSelf.syncBtn.mas_bottom).offset(10);
    }];
    
}


#pragma mark action

- (void)notSyncAction {
    if (self.model.pT_SynType || self.model == nil) {
        self.syncBtn.selected = self.notSyncBtn.selected;
        self.notSyncBtn.selected = !self.notSyncBtn.selected;
    }
}

- (void)syncAction {
    if (self.model.pT_SynType || self.model == nil) {
        self.notSyncBtn.selected = self.syncBtn.selected;
        self.syncBtn.selected = !self.syncBtn.selected;
    }
}

- (void)saveAction {
//    api/ProductTypeManager/AddProductType
    NSMutableDictionary *parameters = @{@"PT_SynType":@(self.syncBtn.selected)}.mutableCopy;
    
    UITextField *textField = self.pClassifyView.textField;
    if (self.model) {
        textField = self.bClassifyView.textField;
        [parameters setValue:self.model.gID forKey:@"PT_Parent"];
    } else {
        [parameters setValue:@"" forKey:@"PT_Parent"];
    }
    if (!textField.text.length) {
        [XYProgressHUD showMessage:@"请填写分类名称"];
        return;
    }
    [parameters setValue:textField.text forKey:@"PT_Name"];

    /*
     PT_Name
     PT_Parent
     PT_Remark
     PT_SynType
     */
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/ProductTypeManager/AddProductType" parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                XYGoodsClassifyModel *obj = [[XYGoodsClassifyModel alloc] init];
                [obj setValuesForKeysWithDictionary:dic[@"data"]];
                if (self.addClassifyFinished) {
                    self.addClassifyFinished(obj);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
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
