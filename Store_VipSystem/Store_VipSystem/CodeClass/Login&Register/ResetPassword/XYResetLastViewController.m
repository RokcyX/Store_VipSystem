//
//  XYRegistViewController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYResetLastViewController.h"

@interface XYResetLastViewController ()
@property (nonatomic, weak)XYLoginField *passWordField;
@property (nonatomic, weak)XYLoginField *checkPassWordField;
@property (nonatomic, weak)UIButton *confirmBtn;
@end

@implementation XYResetLastViewController

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
    
    // 密码
    XYLoginField *passWordField = [[XYLoginField alloc] init];
    passWordField.placeholder = @"请输入6-12位字母或数字密码";
    passWordField.secureTextEntry = YES;
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    passLabel.text = @"密码";
    passWordField.leftView =passLabel;
    [backView addSubview:self.passWordField=passWordField];
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(backView.mas_top);
        make.height.mas_equalTo(55);
    }];
    
    // 密码确认
    XYLoginField *checkPassWordField = [[XYLoginField alloc] init];
    checkPassWordField.placeholder = @"请确认密码";
    checkPassWordField.secureTextEntry = YES;
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 41, 55)];
    checkPassWordField.leftView =checkLabel;
    [backView addSubview:self.checkPassWordField=checkPassWordField];
    [self.checkPassWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.passWordField);
        make.top.equalTo(weakSelf.passWordField.mas_bottom);
        make.height.equalTo(weakSelf.passWordField);
    }];
    
    // 保存
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmBtn setTitle:@"保存" forState:(UIControlStateNormal)];
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

    [self saveRestPassword];
}

- (void)saveRestPassword {
//    /api/User/SetNewPwd
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/User/SetNewPwd" parameters:@{@"Account":self.acount, @"NewPwd":self.passWordField.text, @"OkPwd":self.checkPassWordField.text} succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
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
