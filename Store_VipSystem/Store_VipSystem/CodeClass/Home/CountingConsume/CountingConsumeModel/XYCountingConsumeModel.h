//
//  XYCountingConsumeModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCountingConsumeModel : NSObject

@property (nonatomic , assign) NSInteger              mCA_InitTimes;
@property (nonatomic , copy) NSString              * sG_GID;
@property (nonatomic , copy) NSString              * pM_BigImg;
@property (nonatomic , copy) NSString              * mCA_OverTime;
@property (nonatomic , assign) NSInteger              mCA_HowMany;
@property (nonatomic , copy) NSString              * sGC_ClasName;
@property (nonatomic , copy) NSString              * sG_Code;
@property (nonatomic , assign) NSInteger              mCA_TotalCharge;
@property (nonatomic , assign) CGFloat              sG_Price;
@property (nonatomic , copy) NSString              * sG_Name;

@property (nonatomic , assign) NSInteger count;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

@end
