//
//  XYHomeViewCell.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYHomeFuncView.h"
@interface XYHomeViewCell : UITableViewCell

- (void)setImages:(NSArray *)images titles:(NSArray *)titles isBtn:(BOOL)isBtn;

@property (nonatomic, copy)void(^chickAction)(NSInteger index);

@end
