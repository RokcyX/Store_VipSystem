//
//  XYHomeHeaderView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHomeHeaderView : UIView

@property (nonatomic, strong) NSArray * listArray;

@property (nonatomic, copy)void(^clickItem)(NSInteger index);

@end
