//
//  SLAlertController.m
//  washsystem
//
//  Created by Wcaulpl on 2017/6/7.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import "XYDeptEditController.h"
#import "XYTextView.h"
@interface XYDeptEditController ()

@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, weak) UIView *lineView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UIButton *defineButton;
@property (weak, nonatomic) UIButton *deleteButton;
@property (weak, nonatomic) UIButton *cancelButton;

@property (nonatomic, weak) XYTextView *remarkView;

@end

@implementation XYDeptEditController

- (UIView *)alertView {
    if (!_alertView) {
        UIView *alertView = [[UIView alloc] init];
        alertView.backgroundColor = RGBColor(245, 245, 245);
        alertView.layer.cornerRadius = 6;
        alertView.userInteractionEnabled = YES;
        alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView=alertView];
    }
    return _alertView;
}



- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1];
        [self.alertView addSubview:self.lineView=lineView];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        titleLabel.text = @"修改部门";
        if (!self.model) {
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = @"新增部门";
        }
        [self.alertView addSubview:self.titleLabel=titleLabel];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] init];
        textField.backgroundColor = [UIColor whiteColor];
        UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        textField.leftView = b;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.placeholder = @"输入部门名称";
        if (self.model) {
            textField.text = self.model.dM_Name;
        }
        textField.layer.cornerRadius = 8;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = RGBColor(222, 222, 222).CGColor;
        [self.alertView addSubview:self.textField=textField];
        
    }
    return _textField;
}


- (XYTextView *)remarkView {
    if (!_remarkView) {
        XYTextView *remarkView = [[XYTextView alloc] init];
        remarkView.font = [UIFont systemFontOfSize:17];
        remarkView.placeholder = @"备注信息";
        if (self.model.dM_Remark.length) {
            remarkView.text = self.model.dM_Remark;
        }
        remarkView.layer.cornerRadius = 8;
        remarkView.layer.borderWidth = 1;
        remarkView.layer.borderColor = RGBColor(222, 222, 222).CGColor;
        [self.alertView addSubview:self.remarkView=remarkView];
        
    }
    return _remarkView;
}

- (UIButton *)defineButton {
    if (_defineButton == nil) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = [UIColor whiteColor];
//        sureBtn.layer.cornerRadius = 8;
        [sureBtn setTitleColor:RGBColor(59, 171, 250) forState:(UIControlStateNormal)];
        NSString *title = @"确定";
        if (self.model) {
            title = @"保存";
        }
        [sureBtn setTitle:title forState:UIControlStateNormal];
        sureBtn.tag = 102;
        [sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.defineButton=sureBtn];
    }
    return _defineButton;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = [UIColor whiteColor];
//        sureBtn.layer.cornerRadius = 8;
        NSString *title = @"取消";
        NSInteger tag = 101;
        if (self.model) {
            title = @"删除";
            tag = 103;
        }
        [sureBtn setTitle:title forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.tag = tag;
        [sureBtn setTitleColor:RGBColor(252, 32, 44) forState:(UIControlStateNormal)];
        [self.alertView addSubview:self.deleteButton=sureBtn];
    }
    return _deleteButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.backgroundColor = [UIColor whiteColor];
//        cancleBtn.layer.cornerRadius = 8;
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [cancleBtn setTitle:NSLocalizedString(@"取消编辑", @"") forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.titleEdgeInsets = UIEdgeInsetsMake(20, ScreenWidth - 80 - cancleBtn.titleLabel.calculateWidth - 5 , 20, 20);
        cancleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        cancleBtn.tag = 101;
        [cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancelButton = cancleBtn];
    }
    return _cancelButton;
}

- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 102) {
        if (self.textField.text.length) {
            if (![self.textField.text isEqualToString:self.model.dM_Name] || ![self.remarkView.text isEqualToString:self.model.dM_Remark]) {
                if (!self.remarkView.text) {
                    self.remarkView.text = @"";
                }
                if (self.model) {
                    // 保存
                    [self updataWithSave:YES];
                } else {
                    // 新增
                    [self addDept];
                }
            } else {
                [XYProgressHUD showMessage:@"输入要修改的部门信息"];
            }
            
        } else {
            [XYProgressHUD showMessage:@"输入部门名称"];
        }
    } else if (sender.tag == 103) {
        // 删除
        [self updataWithSave:NO];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addDept {
//    api/Dept/AddDept
    
    NSDictionary *parameters =@{@"DM_Name":self.textField.text,@"DM_Remark":self.remarkView.text};
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/Dept/AddDept" parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                if (weakSelf.alertFinish) {
                    weakSelf.alertFinish();
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

- (void)updataWithSave:(BOOL)isSave {
    NSString *url = @"api/Dept/DelDept";
    NSDictionary *parameters =@{@"GID":self.model.gID};
    if (isSave) {
        url = @"api/Dept/EditDept";
        parameters =@{
                      @"GID":self.model.gID,
                      @"DM_Name":self.textField.text,
                      @"DM_Remark":self.remarkView.text
                      };
        
    }
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:url parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                if (isSave) {
                    weakSelf.model.dM_Name = weakSelf.textField.text;
                    weakSelf.model.dM_Remark = weakSelf.remarkView.text;
                    if (weakSelf.alertFinish) {
                        weakSelf.alertFinish();
                    }
                } else {
                    if (weakSelf.alertDelete) {
                        weakSelf.alertDelete();
                    }
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

- (instancetype)initWithModel:(XYDeptModel *)model defaultActin:(AlertResult)defaultActin deleteActin:(AlertResult)deleteActin {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.alertFinish = defaultActin;
        self.alertDelete = deleteActin;
        self.model = model;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.5];
    [self addNoticeForKeyboard];
    [self setupUI];
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupUI {
    WeakSelf;
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
//        make.height.equalTo(weakSelf.deleteButton.mas_bottom);
    }];
    if (self.model) {
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(weakSelf.alertView);
            make.height.mas_equalTo(60);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.alertView);
            make.left.equalTo(weakSelf.alertView.mas_left).offset(20);
            make.height.mas_equalTo(60);
        }];
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(weakSelf.alertView);
            make.height.mas_equalTo(60);
        }];
    }

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.alertView.mas_left).offset(30);
        make.right.equalTo(weakSelf.alertView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textField.mas_bottom).offset(20);
        make.left.right.equalTo(weakSelf.textField);
        make.height.mas_equalTo(100);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.remarkView.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.alertView.mas_left);
        make.right.equalTo(weakSelf.alertView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [self.defineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.left.equalTo(weakSelf.alertView.mas_left);
        make.right.equalTo(weakSelf.alertView.mas_centerX);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(weakSelf.alertView.mas_bottom);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.right.equalTo(weakSelf.alertView.mas_right);
        make.left.equalTo(weakSelf.alertView.mas_centerX);
        make.height.mas_equalTo(40);
    }];
}


///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIView *tempView = self.textField;
    CGRect newRect = [self.alertView convertRect:tempView.frame fromView:tempView.superview];
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat alertOff = CGRectGetMaxY(self.alertView.frame) + kbHeight - ScreenHeight;
    
    CGFloat offset = CGRectGetMaxY(newRect) + alertOff - CGRectGetHeight(self.alertView.frame) + 20;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.alertView.center = CGPointMake(self.alertView.center.x, self.alertView.center.y - offset);
//            self.alertView.frame = CGRectMake(0.0f, -offset, self.alertView.frame.size.width, self.alertView.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.alertView.center = self.view.center;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
