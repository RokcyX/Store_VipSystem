//
//  XYVipBasicInfoController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYAddGoodsController.h"
#import "XYAddGoodsCell.h"
#import <UIButton+WebCache.h>
#import "SLScanQCodeViewController.h"
#import "XYHandoffLabelView.h"

@interface XYAddGoodsController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (nonatomic, strong)NSArray *labelList;
//@property (nonatomic, strong)NSArray *vipGradeList;
@property (nonatomic, weak)XYHandoffLabelView *handofflView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UIButton *headerImageBtn;
@property (nonatomic, strong)XYGoodsClassifyController *classiVc;

@end

@implementation XYAddGoodsController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setHeaderImage:(UIImage *)headerImage {
    self.handofflView.headerImage = headerImage;
    if (headerImage) {
        [self.headerImageBtn setImage:headerImage forState:(UIControlStateNormal)];
    } else {
        NSString *imageName = @"commodity_goods_placeholder";
        if (self.handofflView.selectedIndex == 2) {
            imageName = @"commodity_gifts_placeholder";
        } else if (self.handofflView.selectedIndex == 1) {
            imageName = @"commodity_serviceGoods_placeholder";
        }
        [self.headerImageBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    }

}

- (void)loadData {
    NSString *imageName = @"commodity_goods_placeholder";
    if (self.handofflView.selectedIndex == 2) {
        imageName = @"commodity_gifts_placeholder";
    } else if (self.handofflView.selectedIndex == 1) {
        imageName = @"commodity_serviceGoods_placeholder";
    }
    if (!self.handofflView.dataList.count) {
        self.headerImage = nil;
        NSString *strPath = [[NSBundle mainBundle] pathForResource:@"VipBasicInfo" ofType:@"geojson"];
        NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *parseDic = [AFNetworkManager parseJSONStringToNSDictionary:parseJason];
        NSDictionary *dic = parseDic[@"GoodsInfo"];
        if (self.handofflView.selectedIndex == 2) {
            dic = parseDic[@"GiftsInfo"];
        } else if (self.handofflView.selectedIndex == 1) {
            dic = parseDic[@"ServiceInfo"];
        }
        for (NSString *key in dic.allKeys) {
            if (key.integerValue > self.handofflView.dataList.count) {
                [self.handofflView.dataList insertObject:[XYAddGoodsModel modelConfigureWithArray:dic[key] commodityModel:self.model] atIndex:self.handofflView.dataList.count];
            } else {
                [self.handofflView.dataList insertObject:[XYAddGoodsModel modelConfigureWithArray:dic[key] commodityModel:self.model] atIndex:key.integerValue-1];
            }
        }
    }
    
    [self.tableView reloadData];
                
    [self.headerImageBtn sd_setImageWithURL:[NSURL URLWithString:self.model.pM_BigImg] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:imageName]];
    if (self.handofflView.headerImage) {
        [self.headerImageBtn setImage:self.handofflView.headerImage forState:(UIControlStateNormal)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(244, 245, 246);
    self.title = @"添加商品";
    if (self.model) {
        self.title = @"商品编辑";
    } else {
//        [self loadVIPGradeList];
    }
    [self loadData];
//    [self loadMemberLabelList];
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
//    XYAddGoodsModel *model = self.dataList[1][1];
//    for (XYVipGradeModel *vipGrade in self.vipGradeList) {
//        if ([model.detail isEqualToString:vipGrade.vG_Name] && ![model.updateValue isEqualToString:vipGrade.gID]) {
//            model.updateValue = vipGrade.gID;
//            XYVipBasicInfoModel *model1 = self.dataList[2][0];
//            model1.detail = @(vipGrade.vG_CardAmount).stringValue;
//            XYVipBasicInfoModel *model2 = self.dataList[2][1];
//            model2.detail = @(vipGrade.vG_InitialAmount).stringValue;
//            XYVipBasicInfoModel *model3 = self.dataList[2][2];
//            model3.detail = @(vipGrade.vG_InitialIntegral).stringValue;
//            [self.tableView reloadData];
//              
//        }
//    }
}

- (XYHandoffLabelView *)handofflView {
    if (!_handofflView) {
        WeakSelf;
        XYHandoffLabelView *handofflView = [[XYHandoffLabelView alloc] init];
//        if (!self.model) {
            handofflView.selectedItem = ^(NSInteger item) {
                [weakSelf loadData];
            };
//        } else {
            handofflView.selectedIndex = self.model.pM_IsService;
//        }
        [self.view addSubview:self.handofflView=handofflView];
    }
    return _handofflView;
}

- (void)setupUI {
    WeakSelf;
    [self.handofflView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYAddGoodsCell class] forCellReuseIdentifier:@"XYAddGoodsCell"];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.tableView=tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.handofflView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-70);
    }];
    
    UIButton *headerImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    headerImageBtn.frame = CGRectMake(ScreenWidth - 100, 0, 100, 100);
    headerImageBtn.backgroundColor = [UIColor whiteColor];
    headerImageBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    NSString *imageName = @"commodity_goods_placeholder";
    if (self.handofflView.selectedIndex == 2) {
        imageName = @"commodity_gifts_placeholder";
    } else if (self.handofflView.selectedIndex == 1) {
        imageName = @"commodity_serviceGoods_placeholder";
    }
    [headerImageBtn sd_setImageWithURL:[NSURL URLWithString:self.model.pM_BigImg] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:imageName]];
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
}

#pragma mark 响应事件

- (void)headerImageAction {
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
    if (self.handofflView.headerImage) {
        [self uploadImgByCodeFromContinue:NO];
    } else {
        [self uploadDataWithImageUrl:nil isFromContinue:NO];
    }
}

- (void)uploadImgByCodeFromContinue:(BOOL)isFromContinue {
    NSData * data = UIImageJPEGRepresentation(self.handofflView.headerImage, 1.0);
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
    XYBasicViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    if (self.model) {
        // 修改 /api/ProductManger/EditProduct
        url = @"api/ProductManger/EditProduct";
        vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
    } else {
        // 添加
        //        /api/ProductManger/Addproduct
        url = @"api/ProductManger/Addproduct";
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
                    [weakSelf.handofflView emptyData];
                    [weakSelf loadData];
                    weakSelf.classiVc = nil;
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
                [XYProgressHUD showSuccess:dic[@"msg"]];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

// 取消
- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDictionary *)parametersWithImageUrl:(NSString *)imageUrl {
    /*
     VIP_HeadImg        会员照片    String        是    0-100
     VIP_Label        会员标签    String        是    0-500
     GID        会员GID    String        否    0-100
     */
    NSMutableDictionary *parameters = [XYAddGoodsModel parametersWithDataList:self.handofflView.dataList];
    if (!parameters) {
        return nil;
    }
    [parameters setValue:@(self.handofflView.selectedIndex).stringValue forKey:@"PM_IsService"];
    if (self.model) {
        [parameters setValue:self.model.gID forKey:@"GID"];
    }
    
    [parameters setValue:imageUrl ? imageUrl : @"/img/product.png" forKey:@"PM_BigImg"];
    [parameters setValue:@"4" forKey:@"VIP_RegSource"];

    
    return parameters;
    
}

// 继续添加
- (void)continueAction {
    if (self.handofflView.headerImage) {
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
    return self.handofflView.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.handofflView.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYAddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYAddGoodsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedRule = ^(NSInteger index) {
        XYAddGoodsModel *obj = self.handofflView.dataList[indexPath.section][indexPath.row+1];
        obj.isWritable = 0;
        if (index == 2) {
            obj.isWritable = 1;
        }
        [tableView reloadData];
    };
    XYAddGoodsModel *model = self.handofflView.dataList[indexPath.section][indexPath.row];
    cell.model = model;
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
    XYAddGoodsModel *model = self.handofflView.dataList[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"商品折扣"]) {
        if (model.updateValue.boolValue) {
            model.updateValue = @"0";
        } else {
            model.updateValue = @"1";
        }
        for (XYAddGoodsModel *obj in self.handofflView.dataList[indexPath.section]) {
            if ([obj.title isEqualToString:@"特价折扣"] || [obj.title isEqualToString:@"最低折扣"]) {
                obj.isWritable = model.updateValue.boolValue;
            }
        }
    }
    if ([model.title isEqualToString:@"商品分类"] || [model.title isEqualToString:@"礼品分类"]) {
        if (!self.classiVc) {
            self.classiVc = [[XYGoodsClassifyController alloc] init];
        }
        WeakSelf;
        [self.navigationController pushViewController:self.classiVc animated:YES];
        self.classiVc.pT_Name = model.detail;
        self.classiVc.finishedSelected = ^(XYGoodsClassifyModel *classi) {
            model.detail = classi.pT_Name;
            model.updateValue = classi.gID;
            XYAddGoodsModel *lastModel = [weakSelf.handofflView.dataList.lastObject lastObject];
            if (classi.pT_SynType) {
                lastModel.isWritable = 1;
                lastModel.detail=@"同步";
                lastModel.updateValue=@"1";
            } else {
                lastModel.isWritable = 0;
                lastModel.detail=@"不同步";
                lastModel.updateValue=@"0";
            }
            [tableView reloadData];
        };
    }
    [tableView reloadData];
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
