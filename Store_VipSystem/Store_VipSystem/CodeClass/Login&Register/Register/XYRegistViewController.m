//
//  XYRegistViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYRegistViewController.h"

@interface XYRegistViewController ()
@property (nonatomic, weak)XYLoginField *userNameField;
@property (nonatomic, weak)XYLoginField *passWordField;
@property (nonatomic, weak)XYLoginField *checkPassWordField;
@property (nonatomic, weak)XYLoginField *validationUserNameField;
@property (nonatomic, weak)UIButton *captchaBtn;
@property (nonatomic, weak)UIButton *confirmBtn;

@property (nonatomic, assign)NSInteger time;
@end

@implementation XYRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
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
        make.height.mas_equalTo(55*4);
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
    
    // 密码
    XYLoginField *passWordField = [[XYLoginField alloc] init];
    passWordField.placeholder = @"请输入6-12位字母或数字密码";
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    passLabel.text = @"密码";
    passWordField.secureTextEntry = YES;
    passWordField.leftView =passLabel;
    [backView addSubview:self.passWordField=passWordField];
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.userNameField.mas_bottom);
        make.height.equalTo(weakSelf.userNameField);
    }];
    
    // 密码确认
    XYLoginField *checkPassWordField = [[XYLoginField alloc] init];
    checkPassWordField.placeholder = @"请确认密码";
    checkPassWordField.secureTextEntry = YES;
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    checkPassWordField.leftView =checkLabel;
    [backView addSubview:self.checkPassWordField=checkPassWordField];
    [self.checkPassWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.userNameField);
        make.top.equalTo(weakSelf.passWordField.mas_bottom);
        make.height.equalTo(weakSelf.userNameField);
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
        make.top.equalTo(weakSelf.checkPassWordField.mas_bottom);
        make.height.equalTo(weakSelf.userNameField);
    }];
    
    // 登录
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
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
        [XYProgressHUD showMessage:@"手机/邮箱验证码"];
        return;
    } else {
        [self openCountdown];
        [self sendCaptchMessage];
    }
}

// 按钮倒计时
-(void)openCountdown{
    self.time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WeakSelf;
    dispatch_source_set_event_handler(_timer, ^{
        if(weakSelf.time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.captchaBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.captchaBtn setTitleColor:RGBColor(252, 109, 72) forState:UIControlStateNormal];
                self.captchaBtn.layer.borderColor = RGBAColor(252, 109, 72, 0.8).CGColor;
                self.captchaBtn.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = weakSelf.time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.captchaBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.captchaBtn setTitleColor:[UIColor colorWithHex:@"979797"] forState:UIControlStateNormal];
                self.captchaBtn.layer.borderColor =[UIColor colorWithHex:@"979797"].CGColor;
                self.captchaBtn.userInteractionEnabled = NO;
                
            });
            weakSelf.time--;
        }
    });
    dispatch_resume(_timer);
}

// 发送短信
- (void)sendCaptchMessage {
    [AFNetworkManager postNetworkWithUrl:@"api/User/RegisterVerify" parameters:@{@"LoginAccount":self.userNameField.text, @"OEMGID":@""} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![dic[@"success"] boolValue]) {
                self.time = 0;
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.time = 0;
        });
    } showMsg:YES];
}

- (BOOL)judgmentpPasswordharacter:(NSString *)password {
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    //英文字条件
    
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]"options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return YES;
    }
    return NO;
}

// 确定事件
- (void)confirmAction {
    if (!self.userNameField.text.length) {
        [XYProgressHUD showMessage:@"请输入手机号或电子邮箱"];
        return;
    }
    if (self.passWordField.text.length < 6 || self.passWordField.text.length > 20) {
        [XYProgressHUD showMessage:@"输入密码位数不在规定范围"];
        return;
    }
    if (![self judgmentpPasswordharacter:self.passWordField.text]) {
        [XYProgressHUD showMessage:@"密码只能能包含字母或数字"];
        return;
    }
    
    if (![self.passWordField.text isEqualToString:self.checkPassWordField.text]) {
        [XYProgressHUD showMessage:@"两次密码不一致"];
        return;
    }
    if (!self.validationUserNameField.text.length) {
        [XYProgressHUD showMessage:@"验证码未输入"];
        return;
    }
    [self registerAccount];
}

- (void)registerAccount {
//
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/UserManager/Register" parameters:@{@"UserAcount":self.userNameField.text, @"PassWord":self.passWordField.text,@"MeshCode":self.validationUserNameField.text,@"Domain":@"",@"SUCode":@"",@"RegSource":@""} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                Set_UserDefaults(self.userNameField.text, @"userNameText");
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        });
        
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
