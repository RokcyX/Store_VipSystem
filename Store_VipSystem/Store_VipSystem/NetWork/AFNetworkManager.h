//
//  AFNetwotkManager.h
//  ClothingSystem
//
//  Created by Wcaulpl on 2017/7/25.
//  Copyright © 2017年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYProgressHUD.h"

@interface AFNetworkManager : NSObject

+ (void)postNetworkWithUrl:(NSString *)url parameters:(NSDictionary *)parameters succeed:(void (^)(NSDictionary *dic))succeed failure:(void (^)(NSError *error))failure showMsg:(BOOL)showMsg;

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)jsonString;

+(BOOL)availableNetwork;

@end
