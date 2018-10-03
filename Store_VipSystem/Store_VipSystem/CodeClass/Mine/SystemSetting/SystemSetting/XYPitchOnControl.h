//
//  XYPitchOnControl.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/12.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PitchOnHeight 50

@interface XYPitchOnControl : UIView

@property (nonatomic, strong)NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) dispatch_block_t selectControl;

@end
