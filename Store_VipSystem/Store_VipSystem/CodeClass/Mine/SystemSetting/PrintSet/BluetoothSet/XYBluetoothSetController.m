//
//  XYBluetoothSetController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBluetoothSetController.h"

@interface XYBluetoothSetController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (strong, nonatomic)NSArray *deviceArray;  /**< 蓝牙设备个数 */

@end

@implementation XYBluetoothSetController

- (void)loadData {
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    WeakSelf;
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        weakSelf.deviceArray = perpherals;
        [weakSelf.tableView reloadData];
    } failure:^(SEScanError error) {
        NSLog(@"error:%ld",(long)error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"蓝牙设置";
    [self loadData];
    [self setupUI];
}

- (void)setupUI {
    WeakSelf;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.tableFooterView = UIView.new;
    [self.view addSubview:self.tableView = tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(10);
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.bottom.equalTo(weakSelf.view).offset(-60);
    }];
    
    UIButton *scanBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [scanBT setTitle:@"扫描蓝牙" forState:(UIControlStateNormal)];
    [scanBT addTarget:self action:@selector(scanBTAction) forControlEvents:(UIControlEventTouchUpInside)];
    scanBT.backgroundColor = RGBColor(36, 137, 250);
    [self.view addSubview:scanBT];
    [scanBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)scanBTAction {
    [self loadData];
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    UIButton *imageBtn = [cell.contentView viewWithTag:102];
    UILabel *detailLabel = [cell.contentView viewWithTag:101];
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    if (!imageBtn) {
        imageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [imageBtn setImage:[UIImage imageNamed:@"bluetooth_disconnect"] forState:(UIControlStateNormal)];
        [imageBtn setImage:[UIImage imageNamed:@"bluetooth_connected"] forState:(UIControlStateSelected)];
        imageBtn.tag = 102;
        [cell.contentView addSubview:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
            make.right.equalTo(cell.contentView.mas_right);
            make.width.equalTo(imageBtn.mas_height);
        }];
        
        detailLabel = UILabel.new;
        detailLabel.tag = 101;
        detailLabel.text = @"点击连接";
        detailLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
            make.right.equalTo(imageBtn.mas_left);
            make.width.mas_equalTo(detailLabel.calculateWidth);
        }];
        
        titleLabel = UILabel.new;
        titleLabel.tag = 100;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
            make.right.equalTo(detailLabel.mas_left);
            make.left.mas_equalTo(cell.imageView.mas_right).offset(15);
        }];
        
    }
    CBPeripheral *peripherral = self.deviceArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"bluetooth_device"];
    titleLabel.text = peripherral.name;
    detailLabel.text = @"点击连接";
    imageBtn.selected = NO;
    if (peripherral.state == CBPeripheralStateConnected) {
        detailLabel.text = @"连接成功";
        imageBtn.selected = YES;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    WeakSelf;
    [[SEPrinterManager sharedInstance] connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
            [XYProgressHUD showMessage:@"连接失败"];
        } else {
            [XYProgressHUD showMessage:@"连接成功"];
            // 保存 peripherral
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 打印
- (HLPrinter *)getPrinter
{
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = @"测试电商";
    NSString *str1 = @"测试电商服务中心(销售单)";
    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    [printer appendText:str1 alignment:HLTextAlignmentCenter];
    [printer appendBarCodeWithInfo:@"RN3456789012"];
    [printer appendSeperatorLine];
    
    [printer appendTitle:@"时间:" value:@"2016-04-27 10:01:50" valueOffset:150];
    [printer appendTitle:@"订单:" value:@"4000020160427100150" valueOffset:150];
    [printer appendText:@"地址:深圳市南山区学府路东深大店" alignment:HLTextAlignmentLeft];
    
    [printer appendSeperatorLine];
    [printer appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
    CGFloat total = 0.0;
    NSDictionary *dict1 = @{@"name":@"铅笔测试一下哈哈",@"amount":@"5",@"price":@"2.0"};
    NSDictionary *dict2 = @{@"name":@"abcdefghijfdf",@"amount":@"1",@"price":@"1.0"};
    NSDictionary *dict3 = @{@"name":@"abcde笔记本啊啊",@"amount":@"3",@"price":@"3.0"};
    NSArray *goodsArray = @[dict1, dict2, dict3];
    for (NSDictionary *dict in goodsArray) {
        [printer appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    }
    
    [printer appendSeperatorLine];
    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
    [printer appendTitle:@"总计:" value:totalStr];
    [printer appendTitle:@"实收:" value:@"100.00"];
    NSString *leftStr = [NSString stringWithFormat:@"%.2f",100.00 - total];
    [printer appendTitle:@"找零:" value:leftStr];
    
    [printer appendSeperatorLine];
    
    [printer appendText:@"位图方式二维码" alignment:HLTextAlignmentCenter];
    [printer appendQRCodeWithInfo:@"www.baidu.com"];
    
    [printer appendSeperatorLine];
    [printer appendText:@"指令方式二维码" alignment:HLTextAlignmentCenter];
    [printer appendQRCodeWithInfo:@"www.baidu.com" size:10];
    
    [printer appendFooter:nil];
    [printer appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
    
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    
    return printer;
}

- (void)rightAction
{
    //方式一：
    HLPrinter *printer = [self getPrinter];
    NSData *mainData = [printer getFinalData];
    [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
        NSLog(@"写入结：%d---错误:%@",completion,error);
        if (!completion) {
            [XYProgressHUD showMessage:error];
        }
    }];
    
    //方式二：
    //    [_manager prepareForPrinter];
    //    [_manager appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    //    [_manager appendText:str1 alignment:HLTextAlignmentCenter];
    ////    [_manager appendBarCodeWithInfo:@"RN3456789012"];
    //    [_manager appendSeperatorLine];
    //
    //    [_manager appendTitle:@"时间:" value:@"2016-04-27 10:01:50" valueOffset:150];
    //    [_manager appendTitle:@"订单:" value:@"4000020160427100150" valueOffset:150];
    //    [_manager appendText:@"地址:深圳市南山区学府路东深大店" alignment:HLTextAlignmentLeft];
    //
    //    [_manager appendSeperatorLine];
    //    [_manager appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
    //    CGFloat total = 0.0;
    //    NSDictionary *dict1 = @{@"name":@"铅笔",@"amount":@"5",@"price":@"2.0"};
    //    NSDictionary *dict2 = @{@"name":@"橡皮",@"amount":@"1",@"price":@"1.0"};
    //    NSDictionary *dict3 = @{@"name":@"笔记本",@"amount":@"3",@"price":@"3.0"};
    //    NSArray *goodsArray = @[dict1, dict2, dict3];
    //    for (NSDictionary *dict in goodsArray) {
    //        [_manager appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
    //        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    //    }
    //
    //    [_manager appendSeperatorLine];
    //    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
    //    [_manager appendTitle:@"总计:" value:totalStr];
    //    [_manager appendTitle:@"实收:" value:@"100.00"];
    //    NSString *leftStr = [NSString stringWithFormat:@"%.2f",100.00 - total];
    //    [_manager appendTitle:@"找零:" value:leftStr];
    //
    //    [_manager appendFooter:nil];
    //
    ////    [_manager appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
    //
    //    [_manager printWithResult:nil];
    
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
