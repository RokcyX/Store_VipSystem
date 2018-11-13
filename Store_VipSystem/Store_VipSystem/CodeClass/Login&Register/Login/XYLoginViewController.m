//
//  XYLoginViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/7/31.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYLoginViewController.h"
#import "XYRegistViewController.h"
#import "XYResetFirstViewController.h"
#import "XYTabbarContorller.h"

@interface XYLoginViewController ()
@property (nonatomic, weak)UIImageView *backgroundImageView;
@property (nonatomic, weak)XYLoginField *userNameField;
@property (nonatomic, weak)XYLoginField *passWordField;

@property (nonatomic, weak)UIButton *rememberPassword;
@property (nonatomic, weak)UIButton *checkBox;
@property (nonatomic, weak)UIButton *loginButton;
@property (nonatomic, weak)UIButton *registButton;
@property (nonatomic, weak)UIButton *forgetPassword;
@end

@implementation XYLoginViewController



// 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (self.tabBarController.tabBar.hidden == YES)
    {
        self.tabBarController.tabBar.hidden =NO;
    }
    
    [super viewWillAppear:animated];
    self.userNameField.text = Get_UserDefaults(UserNameText);
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
// 隐藏导航栏

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    // 背景图
    self.view.backgroundColor = RGBColor(247, 247, 247);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"backimage_up_login"];
    [self.view addSubview:self.backgroundImageView=imageView];
    WeakSelf;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(ScreenWidth/1080 *1025);
    }];
    
    // 用户名
    XYLoginField *userNameField = [[XYLoginField alloc] init];
    userNameField.placeholder = @"手机号或电子邮箱";
    userNameField.text = Get_UserDefaults(UserNameText);
    userNameField.iconView.image = [UIImage imageNamed:@"acount_login"];
    [self.view addSubview:self.userNameField=userNameField];
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
        make.top.equalTo(weakSelf.backgroundImageView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    // 密码
    XYLoginField *passWordField = [[XYLoginField alloc] init];
    passWordField.placeholder = @"您的云上铺登录密码";
    passWordField.secureTextEntry = YES;
    if ([Get_UserDefaults(RememberPassword) boolValue]) {
        passWordField.text = Get_UserDefaults(PasswordText);
    }
    passWordField.iconView.image = [UIImage imageNamed:@"password_login"];
    [self.view addSubview:self.passWordField=passWordField];
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.userNameField.mas_bottom);
        make.height.equalTo(weakSelf.userNameField);
    }];
    
    // 登录
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = RGBColor(249, 104, 62);
    [self.view addSubview:self.loginButton=loginButton];
    
    // 注册
    UIButton *registButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [registButton setTitleColor:RGBColor(249, 104, 62) forState:(UIControlStateNormal)];
    [registButton setTitle:@"注册" forState:(UIControlStateNormal)];
    registButton.backgroundColor = [UIColor whiteColor];
    registButton.layer.cornerRadius = 3;
    registButton.layer.masksToBounds = YES;
    registButton.layer.borderWidth = 2;
    registButton.layer.borderColor = RGBColor(249, 104, 62).CGColor;
    [registButton addTarget:self action:@selector(registerAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.registButton=registButton];
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.passWordField.mas_bottom).offset(50);
        make.height.equalTo(weakSelf.userNameField);
        make.width.equalTo(weakSelf.registButton);
    }];
    
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.loginButton);
        make.height.equalTo(weakSelf.loginButton);
        make.left.equalTo(weakSelf.loginButton.mas_right).offset(30);
    }];
    // 记住密码
    UIButton *remember = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [remember addTarget:self action:@selector(rememberPasswordAction) forControlEvents:(UIControlEventTouchUpInside)];
    [remember setBackgroundImage:[UIImage imageNamed:@"unselected_login"] forState:(UIControlStateNormal)];
    if ([Get_UserDefaults(RememberPassword) boolValue]) {
       [remember setBackgroundImage:[UIImage imageNamed:@"selected_login"] forState:(UIControlStateNormal)];
    }
    [self.view addSubview:self.checkBox=remember];
    [remember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.registButton.mas_bottom).offset(25);
        make.width.height.mas_equalTo(20);
    }];
    
    UIButton *rememberPassword = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rememberPassword addTarget:self action:@selector(rememberPasswordAction) forControlEvents:(UIControlEventTouchUpInside)];
    [rememberPassword setTitleColor:RGBColor(160, 160, 160) forState:(UIControlStateNormal)];
    rememberPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rememberPassword setTitle:@"记住密码" forState:(UIControlStateNormal)];
    [self.view addSubview:self.rememberPassword=rememberPassword];
    [self.rememberPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remember.mas_right);
        make.top.equalTo(weakSelf.registButton.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    // 忘记密码
    UIButton *forgetPassword = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [forgetPassword addTarget:self action:@selector(forgetPasswordAction) forControlEvents:(UIControlEventTouchUpInside)];
    [forgetPassword setTitleColor:RGBColor(160, 160, 160) forState:(UIControlStateNormal)];
    forgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPassword setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    [self.view addSubview:self.forgetPassword=forgetPassword];
    [self.forgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.registButton.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
}

// 登录
- (void)loginAction {
    // 判断用户名 密码
//    self.userNameField.text = @"17266666666";
//    self.passWordField.text = @"123456";
//     self.userNameField.text = @"13725589468";
//     self.passWordField.text = @"147258";
//    self.userNameField.text = @"17371729593";
//    self.passWordField.text = @"123456";
//    self.userNameField.text = @"qijian@qq.com";
//    self.passWordField.text = @"123456";
    if (!self.userNameField.text.length) {
        [XYProgressHUD showMessage:@"请输入用户名"];
        return;
    }
    if (!self.passWordField.text.length) {
        [XYProgressHUD showMessage:@"请输入密码"];
        return;
    }
//    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/UserManager/Login" parameters:@{@"UserAcount":self.userNameField.text, @"PassWord":self.passWordField.text, @"Type":@(4)} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            [LoginModel modelConfigureDic:dic[@"data"]];
            Set_UserDefaults(self.userNameField.text, UserNameText);
            if ([Get_UserDefaults(RememberPassword) boolValue]) {
                Set_UserDefaults(self.passWordField.text, PasswordText);
            }
            // 进入首页
            dispatch_async(dispatch_get_main_queue(), ^{
                ApplicationRootVC([XYTabbarContorller merchantsTabbar]);
            });
        }
        
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

// 注册
- (void)registerAction {
    XYRegistViewController *regist = [[XYRegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}


// 记住密码
- (void)rememberPasswordAction {
    if ([Get_UserDefaults(RememberPassword) boolValue]) {
        Set_UserDefaults(@"NO", RememberPassword);
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"unselected_login"] forState:(UIControlStateNormal)];
    } else {
        Set_UserDefaults(@"YES", RememberPassword);
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"selected_login"] forState:(UIControlStateNormal)];
    }
}

// 忘记密码
- (void)forgetPasswordAction {
    XYResetFirstViewController *resetVc = [[XYResetFirstViewController alloc] init];
    [self.navigationController pushViewController:resetVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
