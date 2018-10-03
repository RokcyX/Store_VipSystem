//
//  XYSettingEditViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/10.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYSettingEditViewController.h"

@interface XYSettingEditViewController ()
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITextField *textField;
@end

@implementation XYSettingEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺设置";
    [self setupUI];
}

- (void)setupUI {
    WeakSelf;
    self.view.backgroundColor = RGBColor(245, 245, 245);
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = self.string;
    textField.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.string;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.frame = CGRectMake(0, 0, titleLabel.calculateWidth+10 , 50);
    textField.leftView = self.titleLabel = titleLabel;
//    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.cornerRadius = 8;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = RGBColor(222, 222, 222).CGColor;
    if ([self.string isEqualToString:@"联系电话"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }
    [self.view addSubview:self.textField=textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.backgroundColor = RGBColor(252, 105, 67);
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textField);
        make.height.mas_equalTo(50);
        make.top.equalTo(textField.mas_bottom).offset(40);
    }];
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)saveAction {
//    api/Shops/EditShops
    
//    SM_Name
//    SM_Contacter
//    SM_Phone
    if (!self.textField.text.length) {
        [XYProgressHUD showMessage:@"请输入要修改的信息"];
        return;
    }
    /*
     SM_Addr    地址        string            是
     SM_Remark    备注        string            是
     SM_XLong    店铺X坐标        decimal?            是
     SM_YLat    店铺Y坐标        decimal?            是
     SM_Industry    所属行业        string            是
     SM_Range    经营范围        string            是
     SM_Country    所在国家        string            是
     SM_Province    所在身份        string            是
     SM_City    所在城市        string            是
     SM_Disctrict    所在区县        string            是
     SM_DetailAddr    详细地址        string            是
     SM_MapAddr    地图地址        string            是
     SM_Picture    店铺Logo        string            是    
     */
    
    
    NSMutableDictionary *parameters = @{@"SM_Name":[LoginModel shareLoginModel].shopModel.sM_Name, @"SM_Contacter":[LoginModel shareLoginModel].shopModel.sM_Contacter,@"SM_Phone":[LoginModel shareLoginModel].shopModel.sM_Phone,@"SM_Addr":[LoginModel shareLoginModel].shopModel.sM_Addr,
                                        @"SM_Remark":[LoginModel shareLoginModel].shopModel.sM_Remark,
                                        @"SM_XLong":[LoginModel shareLoginModel].shopModel.sM_XLong,
                                        @"SM_YLat":[LoginModel shareLoginModel].shopModel.sM_YLat,
                                        @"SM_Industry":[LoginModel shareLoginModel].shopModel.sM_Industry,
                                        @"SM_Range":[LoginModel shareLoginModel].shopModel.sM_Range,
                                        @"SM_Country":[LoginModel shareLoginModel].shopModel.sM_Country,
                                        @"SM_Province":[LoginModel shareLoginModel].shopModel.sM_Province,
                                        @"SM_City":[LoginModel shareLoginModel].shopModel.sM_City,
                                        @"SM_Disctrict":[LoginModel shareLoginModel].shopModel.sM_Disctrict,
                                        @"SM_DetailAddr":[LoginModel shareLoginModel].shopModel.sM_DetailAddr,
                                        @"SM_MapAddr":[LoginModel shareLoginModel].shopModel.sM_MapAddr,
                                        @"SM_Picture":[LoginModel shareLoginModel].shopModel.sM_Picture, @"GID":[LoginModel shareLoginModel].shopModel.gID}.mutableCopy;
    if ([self.string isEqualToString:@"店铺名称"]) {
        [parameters setValue:self.textField.text forKey:@"SM_Name"];
    } else if ([self.string isEqualToString:@"联系人"]) {
        [parameters setValue:self.textField.text forKey:@"SM_Contacter"];
    } else if ([self.string isEqualToString:@"联系电话"]) {
        [parameters setValue:self.textField.text forKey:@"SM_Phone"];
    }
    
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Shops/EditShops" parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [[LoginModel shareLoginModel].shopModel setValuesForKeysWithDictionary:dic[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XYProgressHUD showSuccess:dic[@"msg"]];
                });
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
