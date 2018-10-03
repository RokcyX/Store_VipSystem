//
//  VerticalSegmentedControlTableViewCell.h
//  VerticalSegmentedControl-Demo
//
//  Created by Vincent on 2/25/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYVerticalSegmentedControlView : UIView

- (void)setSegmentTitle:(NSString *)title selected:(BOOL)selected;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void(^selectedView)(NSInteger section);
@property (nonatomic, copy)void(^longPressView)(NSIndexPath *indexPath);

@property (weak, nonatomic)UIView *lineView;

@property (weak, nonatomic) UIView *rightLine;

@end
