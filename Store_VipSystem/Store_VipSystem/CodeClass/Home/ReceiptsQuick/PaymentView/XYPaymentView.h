//
//  SLAlertController.h
//  washsystem
//
//  Created by Wcaulpl on 2017/6/7.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMemberManageModel.h"

@interface XYPaymentView : UIViewController

@property (nonatomic, assign)BOOL isReceipts;

@property (nonatomic, copy)NSString *priceString;

@property (nonatomic, strong)NSMutableDictionary *parameters; // 支付订单参数

@property (nonatomic, copy)NSString *payUrl; // 支付Url

- (instancetype)initWithTitlePrice:(NSString *)price;

@property (nonatomic, copy) dispatch_block_t jointPayBlock;

@property (nonatomic, copy) void(^paySuccessBlock)(NSData *printData);


@end
