//
//  XYVipBasicInfoController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYVipBasicInfoController.h"
#import "XYVipBasicInfoCell.h"
#import "XYVipLabelModel.h"
#import <UIButton+WebCache.h>
#import "SLScanQCodeViewController.h"
//#import "SelectPhotoManager.h"
@interface XYVipBasicInfoController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong)NSArray *labelList;
@property (nonatomic, strong)NSArray *vipGradeList;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, assign)BOOL readOnly;
@property (nonatomic, weak)UIButton *headerImageBtn;
//@property (nonatomic, strong)WBPopOverView *popOverView;
@property (nonatomic, strong)UIImage *headerImage;
@end

@implementation XYVipBasicInfoController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNaviUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"member_vip_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(operationAvtion)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)setHeaderImage:(UIImage *)headerImage {
    _headerImage = headerImage;
    if (headerImage) {
        [self.headerImageBtn setImage:headerImage forState:(UIControlStateNormal)];
    } else {
        [self.headerImageBtn setImage:[UIImage imageNamed:@"vip_basicInfo_head"] forState:(UIControlStateNormal)];
    }
    
}

- (void)loadData {
    self.headerImage = nil;
    if (self.labelList.count) {
        for (XYVipLabelModel *model in self.labelList) {
            model.isSelected = NO;
            [model defaultVIP_Label:self.model.vIP_Label];
        }
    }
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"VipBasicInfo" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
    self.dataList = [NSMutableArray array];
    NSDictionary *dic = parseDic[@"VipBasicInfo"];
    for (NSString *key in dic.allKeys) {
        if (key.integerValue > self.dataList.count) {
            [self.dataList insertObject:[XYVipBasicInfoModel modelConfigureWithArray:dic[key] memberModel:self.model] atIndex:self.dataList.count];
        } else {
            [self.dataList insertObject:[XYVipBasicInfoModel modelConfigureWithArray:dic[key] memberModel:self.model] atIndex:key.integerValue-1];
        }
    }
    [self.tableView reloadData];
    
    [self.headerImageBtn sd_setImageWithURL:[NSURL URLWithString:self.model.vIP_HeadImg] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"vip_basicInfo_head"]];
}

// 会员等级
- (void)loadVIPGradeList {
//    /api/VIPGrade/QueryDataList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/VIPGrade/QueryDataList" parameters:@{@"GID":@"",@"GradeName":@""} succeed:^(NSDictionary *dic) {
         if ([dic[@"success"] boolValue]) {
             weakSelf.vipGradeList = [XYVipGradeModel modelConfigureWithArray:dic[@"data"]];
         }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
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
            weakSelf.labelList = [XYVipLabelModel modelConfigureWithArray:dic[@"data"] vIP_Label:self.model.vIP_Label];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(244, 245, 246);
    self.title = @"新增会员";
    if (self.model) {
        self.readOnly = YES;
        [self setNaviUI];
        self.title = @"基本信息";
    } else {
        [self loadVIPGradeList];
    }
    
    [self loadData];
    [self loadMemberLabelList];
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
    CGFloat showHeight = CGRectGetHeight(self.tableView.frame) + 70 - keyboardRect.size.height;
    if (CGRectGetMaxY(cell.frame) > showHeight) {
        [self.tableView setContentOffset:CGPointMake(0, CGRectGetMaxY(cell.frame) - showHeight) animated:YES];
    }
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
//    VG_CardAmount        售卡金额
//    VG_InitialAmount        初始金额
//    VG_InitialIntegral        初始积分            
    XYVipBasicInfoModel *model = self.dataList[1][1];
    for (XYVipGradeModel *vipGrade in self.vipGradeList) {
        if ([model.detail isEqualToString:vipGrade.vG_Name] && ![model.updateValue isEqualToString:vipGrade.gID]) {
            model.updateValue = vipGrade.gID;
            XYVipBasicInfoModel *model1 = self.dataList[2][0];
            model1.detail = [NSString stringWithFormat:@"%.2lf", vipGrade.vG_CardAmount];
            XYVipBasicInfoModel *model2 = self.dataList[2][1];
            model2.detail = [NSString stringWithFormat:@"%.2lf", vipGrade.vG_InitialAmount];
            XYVipBasicInfoModel *model3 = self.dataList[2][2];
            model3.detail =  [NSString stringWithFormat:@"%.2lf", vipGrade.vG_InitialIntegral];
            XYVipBasicInfoModel *model4 = self.dataList[2][3];
            if (vipGrade.vG_IsTime) {
                model4.isWritable = NO;
                model4.detail = [self failureTimeWithNums:vipGrade.vG_IsTimeNum unit:vipGrade.vG_IsTimeUnit];
            } else {
                model4.isWritable = YES;
                model4.detail = @"";
            }
            [self.tableView reloadData];
            
        }
    }
}

- (NSString *)failureTimeWithNums:(NSInteger)nums unit:(NSString *)unit {
    NSTimeInterval interval = 60 * 60 * 24;
    if ([unit isEqualToString:@"天"]) {
        interval = nums * interval;
    } else if ([unit isEqualToString:@"月"]) {
        interval = nums * (interval * 30);
    } else if ([unit isEqualToString:@"年"]) {
        interval = nums * (interval * 365);
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYVipBasicInfoCell class] forCellReuseIdentifier:@"XYVipBasicInfoCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.tableView=tableView];
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-70);
    }];
    
    UIButton *headerImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    headerImageBtn.frame = CGRectMake(ScreenWidth - 100, 10, 100, 100);
    headerImageBtn.backgroundColor = [UIColor whiteColor];
    headerImageBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [headerImageBtn sd_setImageWithURL:[NSURL URLWithString:self.model.vIP_HeadImg] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"vip_basicInfo_head"]];
    [headerImageBtn addTarget:self action:@selector(headerImageAction) forControlEvents:(UIControlEventTouchUpInside)];
    [tableView addSubview:self.headerImageBtn=headerImageBtn];
//    10; 50 10 
    
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
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.height.mas_equalTo(50);
        make.top.equalTo(tableView.mas_bottom).offset(10);
    }];
    
    UIButton *continueBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (self.model) {
        [continueBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [continueBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    } else {
        [continueBtn setTitle:@"继续添加" forState:(UIControlStateNormal)];
        [continueBtn addTarget:self action:@selector(continueAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [continueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    continueBtn.layer.cornerRadius = 5;
    continueBtn.backgroundColor = RGBColor(252, 105, 67);
//    continueBtn.layer.shadowOffset = CGSizeMake(1, 1);
//    continueBtn.layer.shadowOpacity = 0.5;
//    continueBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(saveBtn.mas_bottom);
        make.left.equalTo(saveBtn.mas_right).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(saveBtn.mas_top);
        make.width.equalTo(saveBtn.mas_width);
    }];
    
    if (self.model) {
        [self updateSubViews];
    }
}

- (void)updateSubViews {
    WeakSelf;
    if (!self.readOnly) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-70);
        }];
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        }];
    }
}

#pragma mark 响应事件
// right navi
- (void)operationAvtion {
   
    CGPoint point = CGPointMake(ScreenWidth - 28, CGRectGetMaxY(self.navigationController.navigationBar.frame));
    WBPopOverView *popOverView=[[WBPopOverView alloc]initWithOrigin:point Width:180 Height:100 Direction:WBArrowDirectionTopRight];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    popOverView.layer.cornerRadius = 5;
    popOverView.layer.shadowOffset = CGSizeMake(1, 1);
    popOverView.layer.shadowOpacity = 0.5;
    popOverView.layer.shadowColor = [UIColor blackColor].CGColor;
    popOverView.dataList = @[@{@"title":@"删除", @"image":@"Vip_basicInfo_delet"},@{@"title":@"修改", @"image":@"Vip_basicInfo_edit"}];
    WeakSelf;
    popOverView.checkItem = ^(NSInteger index) {
        if (index) {
            [weakSelf editAction];
        } else {
            [weakSelf deleteAction];
        }
    };
    [popOverView popView];
}

// 编辑
- (void)editAction {
    self.readOnly = NO;
    [self updateSubViews];
    [self.tableView reloadData];
    
    if (!self.vipGradeList.count) {
        [self loadVIPGradeList];
    }
}

- (void)deleteAction {
//    api/VIP/DelVIP
    WeakSelf;
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
    [AFNetworkManager postNetworkWithUrl:@"api/VIP/DelVIP" parameters:@{@"GID":self.model.gID} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf.navigationController popToViewController:vc animated:YES];
                if (self.model) {
                    if (vc.dataOverload) {
                        vc.dataOverload();
                    }
                }
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];

}

- (void)headerImageAction {
    if (self.readOnly) {
//        SelectPhotoManager *photoManager =[[SelectPhotoManager alloc]init];
//        [photoManager startSelectPhotoWithImageName:@"选择头像"];
//        WeakSelf;
//        //选取照片成功
//        photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
//            weakSelf.headerImage = image;
//        };
        return;
    }
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /** 其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式 */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.headerImage  = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// 保存
- (void)saveAction {
    if (self.headerImage) {
        [self uploadImgByCodeFromContinue:NO];
    } else {
        [self uploadDataWithImageUrl:nil isFromContinue:NO];
    }
}

- (void)uploadImgByCodeFromContinue:(BOOL)isFromContinue {
    NSData * data = UIImageJPEGRepresentation(self.headerImage, 1.0);
    NSString *dataString = [data base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    //        api/RecvImage/UploadImgByCode
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/RecvImage/UploadImgByCode" parameters:@{@"DataBase64":dataString} succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                [weakSelf uploadDataWithImageUrl:dic[@"data"] isFromContinue:isFromContinue];
            } else {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)uploadDataWithImageUrl:(NSString *)imageUrl isFromContinue:(BOOL)isFromContinue {
    NSString *url;
    XYBasicViewController *vc;
    if (self.model) {
        // 修改
        url = @"api/VIP/EditVIP";
        vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
    } else {
        // 添加
        //        /api/VIP/AddVIP
        url = @"api/VIP/AddVIP";
        vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    }
    
    NSDictionary *parameters = [self parametersWithImageUrl:imageUrl];
    if (!parameters) {
        return;
    }
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:url parameters:parameters succeed:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"success"] boolValue]) {
                if (isFromContinue) {
                    [weakSelf loadData];
                } else {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    if (self.model) {
                        [self.model setValuesForKeysWithDictionary:parameters];
                    } else {
                        if (vc.dataOverload) {
                            vc.dataOverload();
                        }
                    }
                }
            } else {
                [XYProgressHUD showMessage:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:YES];
}

// 取消
- (void)cancelAction {
    self.readOnly = YES;
    [self loadData];
    [self updateSubViews];
    [self.tableView reloadData];
    
}

- (NSDictionary *)parametersWithImageUrl:(NSString *)imageUrl {
    /*
     VIP_HeadImg        会员照片    String        是    0-100
     VIP_Label        会员标签    String        是    0-500
     GID        会员GID    String        否    0-100
     */
    NSMutableDictionary *parameters = [XYVipBasicInfoModel parametersWithDataList:self.dataList];
    [parameters setValue:@"" forKey:@"VIP_RegSource"];

    if (!parameters) {
        return nil;
    }
    if (self.model) {
        [parameters setValue:self.model.gID forKey:@"GID"];
    }
    if (imageUrl) {
        [parameters setValue:imageUrl forKey:@"VIP_HeadImg"];
    }
    NSMutableArray *labelArray = [NSMutableArray array];
    for (XYVipLabelModel *model in self.labelList) {
        if (model.isSelected) {
            NSDictionary *dic = @{@"ItemColor":model.mL_ColorValue,@"ItemGID":model.mL_GID,@"ItemName":model.mL_Name};
            [labelArray addObject:dic];
        }
    }
    if (labelArray.count) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:labelArray options:kNilOptions error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [parameters setValue:jsonString forKey:@"VIP_Label"];
    }
    
    return parameters;
    
}

// 继续添加
- (void)continueAction {
    if (self.headerImage) {
        [self uploadImgByCodeFromContinue:YES];
    } else {
        [self uploadDataWithImageUrl:nil isFromContinue:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.dataList.count) {
        return 1;
    }
    return [self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.dataList.count) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataList.count) {
        return (self.labelList.count /3 +  (self.labelList.count % 3 ? 1:0)) * 56;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    headerView.contentView.backgroundColor = RGBColor(244, 245, 246);
    headerView.textLabel.font = [UIFont systemFontOfSize:16];
    headerView.textLabel.textColor = RGBColor(127, 127, 127);
    headerView.textLabel.text = @"";
    if (section == self.dataList.count) {
        headerView.textLabel.text = @"会员标签";
    }
    return headerView;
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

- (void)labelSelectAction:(UIButton *)btn {
    if (!self.readOnly) {
        XYVipLabelModel *model = self.labelList[btn.tag-100];
        model.isSelected = !model.isSelected;
        [self.tableView reloadData];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        "[{\"ItemColor\":\"#ff0000\",\"ItemGID\":\"01ef9160-edca-4a2f-b160-8c40a5efc4f1\",\"ItemName\":\"\U53bb\U53bb\U53bb\",\"isChecked\":true},{\"ItemColor\":\"#ff99cc\",\"ItemGID\":\"2877533d-09cc-45f4-9d54-8f067a31bb81\",\"ItemName\":\"\U4e0b\U4e2a\U6708\U4e70\U7684\",\"isChecked\":true},{\"ItemColor\":\"#00ff00\",\"ItemGID\":\"534e9efe-7e54-41ce-b95c-8a266390d166\",\"ItemName\":\"\U4ef7\U683c\U8d35\U7684\",\"isChecked\":true},{\"ItemColor\":\"#ff0000\",\"ItemGID\":\"63a93c10-16df-4b6b-8d80-28798cd2dda8\",\"ItemName\":\"\U4e91\U4e0a\U94fa\U6280\U672f\",\"isChecked\":true}]"
        for (int i = 0; i < self.labelList.count; i++) {
            XYVipLabelModel *model = self.labelList[i];
            UIButton *button = [cell.contentView viewWithTag:100 + i];
            if (!button) {
                button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.tag = 100 + i;
                [button addTarget:self action:@selector(labelSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                button.titleLabel.numberOfLines = 0;
                button.frame = CGRectMake(10 + ((ScreenWidth - 52)/3 + 16)*(i%3), 10 + 56 * (i/3), (ScreenWidth - 52)/3, 36);
                [self addBorderToLayer:button];
                [cell.contentView addSubview:button];
            }
            
            
            [button setTitle:model.mL_Name forState:(UIControlStateNormal)];
            button.selected = model.isSelected;
            
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
            
            
            button.backgroundColor = [UIColor whiteColor];

            if (button.selected) {
                button.backgroundColor = [UIColor colorWithHex:model.mL_ColorValue];
//                for (CAShapeLayer *border in button.layer.sublayers) {
//                    [border removeFromSuperlayer];
//                }
            }
        }
        return cell;
    }
    XYVipBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYVipBasicInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XYVipBasicInfoModel *model = self.dataList[indexPath.section][indexPath.row];
    if (!self.readOnly && [model.title isEqualToString:@"会员等级"]) {
        cell.vipGradeList = self.vipGradeList;
    }
    [cell setModel:model readOnly:self.readOnly];
    WeakSelf;
    cell.scan = ^{
        SLScanQCodeViewController * sqVC = [[SLScanQCodeViewController alloc]init];
        [sqVC setSendTask:^(NSString *string) {
            model.detail = string;
            [tableView reloadData];
        }];
        UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
        [weakSelf presentViewController:nVC animated:YES completion:nil];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataList.count) {
        return;
    }
    XYVipBasicInfoModel *model = self.dataList[indexPath.section][indexPath.row];
    if (!self.readOnly && !model.isWritable) {
        if ([model.title isEqualToString:@"开卡人员"]) {
            [XYProgressHUD showMessage:ToDo];
        }
    }
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
