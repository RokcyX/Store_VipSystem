//
//  XYCommodityViewCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/19.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCommodityModel.h"

@interface XYCommodityViewCell : UITableViewCell

@property (nonatomic, copy)BOOL(^addToShoppingCart)(XYCommodityViewCell *currentCell);

@property (nonatomic, weak, readonly)UIImageView *commodityImageView;

@property (nonatomic, weak)XYCommodityModel *model;

@end
