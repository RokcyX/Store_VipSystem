//
//  AFNetwotkManager.m
//  ClothingSystem
//
//  Created by Wcaulpl on 2017/7/25.
//  Copyright © 2017年 Wcaulpl. All rights reserved.
//

#import "AFNetworkManager.h"
#import "AFNetworking.h"

#define JSONResponse  0
//#define JSONResponse  1
//#define BaseUrl @"http://dj.zhiluo.net/"
#define BaseUrl @"http://pc.yunvip123.com/"

@implementation AFNetworkManager

+ (void)postNetworkWithUrl:(NSString *)url parameters:(NSDictionary *)parameters succeed:(void (^)(NSDictionary *dic))succeed failure:(void (^)(NSError *error))failure showMsg:(BOOL)showMsg {
    // 网络检测
    if (![self availableNetwork]) {
        [XYProgressHUD showMessage:@"网络未连接"];
        return;
    }
    
    url = [BaseUrl stringByAppendingString:url];
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //发送网络请求(请求方式为POST)
    AFHTTPResponseSerializer *response;
    if (JSONResponse ) {
        AFJSONResponseSerializer *jsonresponse = [AFJSONResponseSerializer serializer];
        jsonresponse.removesKeysWithNullValues = YES;
        response = jsonresponse;
    } else {
        response = [AFHTTPResponseSerializer serializer];
    }
    manager.responseSerializer = response;
    //如果报接受类型不一致请替换一致text/html或别的
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", @"text/javascript", nil];
    NSLog(@"%@", url);
    if (showMsg) {
        [XYProgressHUD showLoading:@"加载中..."];
    }
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self retuenResponseObject:responseObject succeed:succeed showMsg:showMsg];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self returnError:error failure:failure showMsg:showMsg];
    }];
}



+ (void)retuenResponseObject:(id)responseObject succeed:(void (^)(NSDictionary *))succeed showMsg:(BOOL)showMsg {
    NSDictionary *dic = responseObject;
    if (!JSONResponse) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [string stringByReplacingOccurrencesOfString:@"00:00:00" withString:@""];
//        "PS_PrintTimes": "[{\"PT_Code\":\"\",\"PT_Times\":0}]",
//        "PS_PrintTimes": "[{\"PT_Code\": "",\"PT_Times\":0}]",
        string = [string stringByReplacingOccurrencesOfString:@"\\\":null" withString:@"\\\":\\\"\\\""];
        string = [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        dic = [self parseJSONStringToNSDictionary:string];
    }
    if (showMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![dic[@"success"] boolValue]) {
                [XYProgressHUD showSuccess:dic[@"msg"]];
            } else {
                [[XYProgressHUD sharedHUD] setShowNow:NO];
                [[XYProgressHUD sharedHUD] hideAnimated:YES];
            }
        });
    }
    
    if ([dic[@"code"] isKindOfClass:[NSString class]])
        if ([dic[@"code"] isEqualToString:@"LoginTimeout"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ApplicationRootVC([XYAppDelegate rootViewController]);
        });
    }
//    if ([dic[@"success"] boolValue]) {
        if (succeed && responseObject != NULL) {
            succeed(dic);
        }
//    }
}

+ (void)returnError:(NSError *)error failure:(void (^)(NSError *))failure showMsg:(BOOL)showMsg {
    if (failure) {
        failure(error);
    }
    if (showMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XYProgressHUD showError:@"网络出错"];
        });
    }
    
}

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)jsonString {
    if (!jsonString) {
        return nil;
    }
    NSData *JSONData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

+ (BOOL)availableNetwork {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

@end
