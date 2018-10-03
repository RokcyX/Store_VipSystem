//
//  XYVipBasicInfoCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYVipBasicInfoModel.h"
#import "XYVipGradeModel.h"
@interface XYVipBasicInfoCell : UITableViewCell
- (void)setModel:(XYVipBasicInfoModel *)model readOnly:(BOOL)readOnly;
@property (nonatomic, weak)NSArray *vipGradeList;
@property (nonatomic, copy)void(^scan)(void);
@end
