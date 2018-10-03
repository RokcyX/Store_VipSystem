//
//  XYCustomerServiceModel.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYCustomerServiceModel.h"

@implementation XYCustomerServiceModel

+ (NSDictionary *)parDic {
    return @{@"SU_Telephone"  :      @"联系电话",
             @"SU_QQCode"      :  @"QQ号码",
             @"SU_WeChat"    :    @"微信号码"
//             @"AG_ComplaintPhone"   :     @"投诉电话",
//             @"SU_WeChatImageUrl"    :    @"微信扫描图片"
             };
}

+ (NSArray *)modelConfigureDic:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *parDic = [self parDic];
    for (NSString *key in parDic.allKeys) {
        if ([dic[key] length]) {
            XYCustomerServiceModel *model = [[XYCustomerServiceModel alloc] init];
            model.imageName = [key stringByAppendingString:@"_servic_icon"];
            model.detail = dic[key];
            model.title = parDic[key];
            [array addObject:model];
        }
    }
    return array;
}

@end
