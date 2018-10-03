//
//  XYRegistViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYResetFirstViewController.h"
#import "XYResetLastViewController.h"

@interface XYResetFirstViewController ()
@property (nonatomic, weak)XYLoginField *userNameField;
@property (nonatomic, weak)XYLoginField *validationUserNameField;
@property (nonatomic, weak)UIButton *captchaBtn;
@property (nonatomic, weak)UIButton *confirmBtn;
@end

@implementation XYResetFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = RGBColor(245, 245, 245);
    // 背景图
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = RGBColor(222, 222, 222).CGColor;
    [self.view addSubview:backView];
    WeakSelf;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-1);
        make.left.equalTo(weakSelf.view).offset(-1);
        make.right.equalTo(weakSelf.view).offset(1);
        make.height.mas_equalTo(55*2);
    }];
    
    // 用户名
    XYLoginField *userNameField = [[XYLoginField alloc] init];
    userNameField.placeholder = @"请输入手机号或电子邮箱";
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    userLabel.text = @"账号";
    userNameField.leftView =userLabel;
    [backView addSubview:self.userNameField=userNameField];
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(backView.mas_top);
        make.height.mas_equalTo(55);
    }];
    
    // 验证
    XYLoginField *validationUserNameField = [[XYLoginField alloc] init];
    validationUserNameField.placeholder = @"手机/邮箱验证码";
    UILabel *validationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    validationLabel.text = @"验证";
    validationUserNameField.leftView =validationLabel;
    validationUserNameField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *captchaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 134, 55)];
    validationUserNameField.rightView = captchaBackView;
    UIButton *captchaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    captchaBtn.frame = CGRectMake(22, 12, 90, 31);
    [captchaBtn setTitleColor:RGBColor(252, 109, 72) forState:(UIControlStateNormal)];
    [captchaBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    captchaBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    captchaBtn.backgroundColor = [UIColor whiteColor];
    captchaBtn.layer.cornerRadius = 2;
    captchaBtn.layer.masksToBounds = YES;
    captchaBtn.layer.borderWidth = .5;
    captchaBtn.layer.borderColor = RGBAColor(252, 109, 72, 0.8).CGColor;
    [captchaBtn addTarget:self action:@selector(captchaAction) forControlEvents:(UIControlEventTouchUpInside)];
    [captchaBackView addSubview:self.captchaBtn=captchaBtn];
    
    [backView addSubview:self.validationUserNameField=validationUserNameField];
    [self.validationUserNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.userNameField.mas_bottom);
        make.height.equalTo(weakSelf.userNameField);
    }];
    
    // 登录
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.layer.cornerRadius = 5;
//    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.backgroundColor = RGBColor(252, 105, 67);
//    confirmBtn.layer.shadowOffset = CGSizeMake(1, 1);
//    confirmBtn.layer.shadowOpacity = 0.5;
//    confirmBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.confirmBtn=confirmBtn];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(23);
        make.left.equalTo(weakSelf.view.mas_left).offset(23);
        make.right.equalTo(weakSelf.view.mas_right).offset(-23);
        make.height.mas_equalTo(46);
    }];
}

// 获取验证码事件
- (void)captchaAction {
    if (!self.userNameField.text.length) {
        [XYProgressHUD showMessage:@"请输入手机号或电子邮箱"];
        return;
    } else {
        [self openCountdown];
        [self sendCaptchMessage];
    }
}

// 按钮倒计时
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue); dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.captchaBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.captchaBtn setTitleColor:RGBColor(252, 109, 72) forState:UIControlStateNormal];
                self.captchaBtn.layer.borderColor = RGBAColor(252, 109, 72, 0.8).CGColor;
                self.captchaBtn.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.captchaBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.captchaBtn setTitleColor:[UIColor colorWithHex:@"979797"] forState:UIControlStateNormal];
                self.captchaBtn.layer.borderColor =[UIColor colorWithHex:@"979797"].CGColor;
                self.captchaBtn.userInteractionEnabled = NO;
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

// 发送短信
- (void)sendCaptchMessage {
    [AFNetworkManager postNetworkWithUrl:@"api/User/ResetPasswordVerify" parameters:@{@"LoginAccount":self.userNameField.text} succeed:^(NSDictionary *dic) {
        
        if ([dic[@"WebResult"][@"success"] boolValue]) {
            [XYProgressHUD showSuccess:@"验证码发送成功！"];
        } else {
            [XYProgressHUD showSuccess:@"验证码发送失败！"];
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

// 确定事件
- (void)confirmAction {
    if (!self.userNameField.text.length) {
        [XYProgressHUD showMessage:@"手机/邮箱验证码"];
        return;
    }
    if (!self.validationUserNameField.text.length) {
        [XYProgressHUD showMessage:@"验证码未输入"];
        return;
    }
    [self nextStep];
}

- (void)nextStep {
//    /api/User/IsResetPasswordVerify
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/User/IsResetPasswordVerify" parameters:@{@"Account":self.userNameField.text, @"Verify":self.validationUserNameField.text} succeed:^(NSDictionary *dic) {
        
        if ([dic[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                XYResetLastViewController *lastVc = [[XYResetLastViewController alloc] init];
                lastVc.acount = weakSelf.userNameField.text;
                [weakSelf.navigationController pushViewController:lastVc animated:YES];
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:YES];
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
