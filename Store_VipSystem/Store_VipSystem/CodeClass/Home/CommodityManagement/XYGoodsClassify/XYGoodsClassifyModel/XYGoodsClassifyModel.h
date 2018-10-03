//
//  XYGoodsClassifyModel.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/21.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYGoodsClassifyModel : NSObject

@property (nonatomic , copy) NSString              * sM_Name;
@property (nonatomic , copy) NSString              * pT_Name;
@property (nonatomic , copy) NSString              * sM_ID;
@property (nonatomic , copy) NSString              * cY_GID;
@property (nonatomic , copy) NSString              * pT_UpdateTime;
@property (nonatomic , copy) NSString              * pT_Parent;
@property (nonatomic , copy) NSString              * pT_Creator;
@property (nonatomic , copy) NSString              * pT_Remark;
@property (nonatomic , copy) NSString              * gID;
@property (nonatomic , assign) NSInteger              pT_SynType;
@property (nonatomic , assign) BOOL             isSelected;
@property (nonatomic , assign) BOOL             isOpen;
@property (nonatomic , strong) NSMutableArray              *subList;

+ (NSMutableArray *)modelConfigureWithArray:(NSArray *)diclist;

@end
