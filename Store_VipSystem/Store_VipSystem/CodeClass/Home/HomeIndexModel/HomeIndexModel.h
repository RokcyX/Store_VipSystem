//
//  HomeIndexModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/5.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataList :NSObject
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * aG_GID;
@property (nonatomic , copy) NSString              * noticeRelation;
@property (nonatomic , assign) BOOL              isEject;
@property (nonatomic , copy) NSString              * creatorGID;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) NSInteger              readTimes;
@property (nonatomic , copy) NSString              * creator;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              popState;
@property (nonatomic , copy) NSString              * releaseTime;

@end

@interface NoticeList :NSObject
@property (nonatomic , assign) NSInteger              pageTotal;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy) NSString              * statisticsInfo;
@property (nonatomic , copy) NSArray<DataList *>              * dataList;
@property (nonatomic , assign) NSInteger              dataCount;
@property (nonatomic , assign) NSInteger              pageIndex;

@end

@interface GridData :NSObject
@property (nonatomic , copy) NSString              * month_Total;
@property (nonatomic , copy) NSString              * today_AddMber;
@property (nonatomic , copy) NSString              * yestoday_Total;
@property (nonatomic , copy) NSString              * yestoday_AddMber;
@property (nonatomic , copy) NSString              * month_Recharge;
@property (nonatomic , copy) NSString              * month_AddMber;
@property (nonatomic , copy) NSString              * yestoday_Sale;
@property (nonatomic , copy) NSString              * month_Sale;
@property (nonatomic , copy) NSString              * today_Total;
@property (nonatomic , copy) NSString              * today_Sale;
@property (nonatomic , copy) NSString              * yestoday_Recharge;
@property (nonatomic , copy) NSString              * today_Recharge;

@end

@interface GetPast12Sales :NSObject
@property (nonatomic , assign) NSInteger              sA_AllMembersCount;
@property (nonatomic , copy) NSString              * orderdate;
@property (nonatomic , copy) NSString              * sA_ToDaySales;
@property (nonatomic , copy) NSString              * month;
@property (nonatomic , assign) NSInteger              totalVIP;
@property (nonatomic , copy) NSString              * totalRecharge;
@property (nonatomic , copy) NSString              * totalprice;
@property (nonatomic , copy) NSString              * sA_ThisMonthSales;
@property (nonatomic , copy) NSString              * totalCC;

@end

@interface WelcomData :NSObject
@property (nonatomic , assign) NSInteger              sA_AllMembersCount;// 会员总数
@property (nonatomic , copy) NSString              * orderdate;
@property (nonatomic , copy) NSString              * sA_ToDaySales;// 今日销售额
@property (nonatomic , copy) NSString              * month;
@property (nonatomic , assign) NSInteger              totalVIP;
@property (nonatomic , copy) NSString              * totalRecharge;
@property (nonatomic , copy) NSString              * totalprice;
@property (nonatomic , copy) NSString              * sA_ThisMonthSales; //本月销售额
@property (nonatomic , copy) NSString              * totalCC;

@end

@interface HomeIndexModel : NSObject

@property (nonatomic , strong) NoticeList              * noticeList;//公告
@property (nonatomic , strong) GridData              * gridData;//首页表格数据
@property (nonatomic , copy) NSArray<GetPast12Sales *>              * getPast12Sales;//近6个月销售额增长趋势
@property (nonatomic , copy) NSString              * getPast12VIP;
@property (nonatomic , strong) WelcomData              * welcomData; // 首页数据

+ (instancetype)modelConfigureDic:(NSDictionary *)dic;

@end

