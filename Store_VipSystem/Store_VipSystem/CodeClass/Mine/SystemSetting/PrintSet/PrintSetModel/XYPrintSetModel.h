//
//  XYPrintSetModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintTimes :NSObject

@property (nonatomic , copy) NSString              * pT_Code;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              pT_Times;

@end

@interface XYPrintSetModel : NSObject

@property (nonatomic , copy) NSString              * pS_GID;
@property (nonatomic , assign) NSInteger              pS_IsPreview;
@property (nonatomic , copy) NSString              * pS_PrintTimes;
@property (nonatomic , assign) NSInteger              pS_PaperType;
@property (nonatomic , copy) NSString              * pS_SMGID;
@property (nonatomic , assign) NSInteger              pS_IsEnabled;
@property (nonatomic , copy) NSString              * pS_StylusPrintingName;
@property (nonatomic , copy) NSString              * pS_PrinterName;
@property (nonatomic , copy) NSArray<PrintTimes *>              * printTimesList;
@property (nonatomic , copy) NSArray<PrintTimes *>              * paramPrintTimes;
@property (nonatomic , copy) NSString              * pS_CYGID;

@property (nonatomic , strong) NSMutableDictionary        * parameters;

+ (instancetype)modelConfigureDic:(NSDictionary *)dic;
- (void)setDictionary:(NSDictionary *)dic;
@end
