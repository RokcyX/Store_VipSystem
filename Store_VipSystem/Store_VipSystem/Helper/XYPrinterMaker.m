//
//  XYPrinterMaker.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/28.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYPrinterMaker.h"

@implementation XYPrintHeader

@end

@implementation XYPrinterMaker

static XYPrinterMaker *sInstance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedMaker {
    dispatch_once(&onceToken, ^{
        sInstance= [[self alloc] init];
        NSLog(@"dispatch once");
        
    });
    return sInstance;
    
}

+ (void)destroy {
    sInstance=nil;
    onceToken=0l;
}

- (XYPrintHeader *)header {
    if (!_header) {
        _header = [[XYPrintHeader alloc] init];
    }
    return _header;
}

- (NSMutableArray *)bodylist {
    if (!_bodylist) {
        _bodylist = [NSMutableArray array];
    }
    return _bodylist;
}

- (NSMutableArray *)paymentlist {
    if (!_paymentlist) {
        _paymentlist = [NSMutableArray array];
    }
    return _paymentlist;
}

- (NSData *)printerValueKeys {
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = @"欢迎光临";
    [printer appendText:title alignment:HLTextAlignmentCenter];
    [printer appendNewLine];
    
    [printer appendTitle:@"收银员:" value:self.header.name valueOffset:150];
    [printer appendTitle:@"结账日期:" value:self.header.date valueOffset:150];
    [printer appendTitle:@"流水单号:" value:self.header.order valueOffset:150];
    
    [printer appendSeperatorLine];
    if (self.bodylist.count) {
        for (int i = 0; i < self.bodylist.count; i++) {
            [printer appendArrayText:self.bodylist[i] isTitle:!i];
        }
        [printer appendSeperatorLine];
    }
    
    if (self.paymentlist.count) {
        for (NSDictionary *dic in self.paymentlist) {
            [printer appendTitle:dic[@"title"] value:dic[@"detail"]];
        }
        [printer appendSeperatorLine];
    }
    
    [printer appendTitle:@"打印时间:" value:[[NSDate date] stringWithFormatter:@"yyyy-MM-dd hh:mm:ss"]];
    
    [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    
    return printer.getFinalData;
}


+ (XYBasicViewController *)getCurrentVC
{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        } else{
            break;
        }
    }
    
    if ([vc isKindOfClass:[XYBasicViewController class]]) {
        return vc;
    }
    
    return nil;
}

+ (void)print {
    // 最后 一个 视图 接收信号
    XYBasicViewController *result = [self getCurrentVC];
    if (result) {
        if (result.dataOverload) {
            result.dataOverload();
        }
    }
    
    if ([XYPrinterMaker sharedMaker].isPrint) {
        if (![[SEPrinterManager sharedInstance] isConnected]) {
            [self connectLastPeripheral];
        } else {
            [self printFinalData];
        }
    }
}

+ (void)connectLastPeripheral {
    [[SEPrinterManager sharedInstance] autoConnectLastPeripheralTimeout:10 completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [self printFinalData];
        NSLog(@"成功");
    }];
}

+ (void)printFinalData {
    NSData *printData = [[XYPrinterMaker sharedMaker] printerValueKeys];
    [XYPrinterMaker destroy];
    
    [[SEPrinterManager sharedInstance] sendPrintData:printData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
        NSLog(@"写入结：%d---错误:%@",completion,error);
        if (!completion) {
            [XYProgressHUD showMessage:error];
        }
    }];
}

@end
