//
//  XYMineHeaderView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMineHeaderView : UIImageView

@property (nonatomic, copy)void(^chickAction)(NSInteger index);

@property (nonatomic, assign)NSInteger badge;

@end
