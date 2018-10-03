//
//  XYParameterSetCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYParameterSetModel.h"

@interface XYParameterSetCell : UICollectionViewCell

@property (nonatomic, weak)XYParameterSetModel *model;

@property (nonatomic, copy)void(^selectItem)(XYParameterSetModel *selectModel);

@end
