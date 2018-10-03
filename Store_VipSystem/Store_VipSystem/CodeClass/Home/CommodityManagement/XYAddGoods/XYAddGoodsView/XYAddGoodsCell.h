//
//  XYVipBasicInfoCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAddGoodsModel.h"
//#import "XYVipGradeModel.h"

@interface XYAddGoodsCell : UITableViewCell

@property (nonatomic, strong)XYAddGoodsModel *model;

@property (nonatomic, weak)NSArray *vipGradeList;
@property (nonatomic, copy)void(^scan)(void);
@property (nonatomic, copy)void(^selectedRule)(NSInteger index);
- (void)isBecomeFirstResponder;
@end
