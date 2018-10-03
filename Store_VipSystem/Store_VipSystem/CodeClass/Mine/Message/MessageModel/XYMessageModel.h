//
//  XYMessageModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/23.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMessageModel : NSObject

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

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;


@end
