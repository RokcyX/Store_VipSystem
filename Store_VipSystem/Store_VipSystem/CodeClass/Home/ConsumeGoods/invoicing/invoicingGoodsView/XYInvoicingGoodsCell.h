//
//  XYInvoicingGoodsCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCommodityModel.h"

@interface XYInvoicingGoodsCell : UITableViewCell

@property (nonatomic, weak)XYCommodityModel *model;

@property (nonatomic, copy) dispatch_block_t changeDiscount;

@end
