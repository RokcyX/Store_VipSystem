//
//  XYHandoffLabelView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/20.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHandoffLabelView : UIView
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, copy)void(^selectedItem)(NSInteger item);

@property (nonatomic, strong)UIImage *headerImage;

@property (nonatomic, strong)NSMutableArray *dataList;

- (void)emptyData;


@end
