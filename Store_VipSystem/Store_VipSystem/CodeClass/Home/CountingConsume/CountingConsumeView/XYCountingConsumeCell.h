//
//  XYCountingConsumeCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCountingConsumeModel.h"

@interface XYCountingConsumeCell : UITableViewCell

@property (nonatomic, weak)XYCountingConsumeModel *model;

@property (nonatomic, copy)void(^countHasChanged)(void);

@end
