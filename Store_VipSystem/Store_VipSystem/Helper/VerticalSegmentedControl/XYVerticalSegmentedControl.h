//
//  VerticalSegmentedControl.h
//  VerticalSegmentedControl-Demo
//
//  Created by Vincent on 2/25/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYVerticalSegmentedControl : UIView

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) UITableViewCellAccessoryType    accessoryType;

@property (nonatomic, copy)NSInteger (^countForSection)(void);
@property (nonatomic, copy)NSString *(^titleForSection)(NSInteger section);
@property (nonatomic, copy)BOOL (^isSelectedForSection)(NSInteger section);
@property (nonatomic, assign)CGFloat sectionHeight;
@property (nonatomic, copy)void(^selectedSection)(NSInteger section);

@property (nonatomic, copy)UIView *(^viewForHeaderInSection)(NSInteger section);

@property (nonatomic, copy)UIView *(^viewForFooterInSection)(NSInteger section);


@property (nonatomic, copy)NSInteger (^countForRow)(NSInteger section);
@property (nonatomic, copy)NSString *(^titleForRow)(NSIndexPath *indexPath);
@property (nonatomic, copy)BOOL (^isSelectedForRow)(NSIndexPath *indexPath);
@property (nonatomic, assign)CGFloat rowHeight;
@property (nonatomic, copy)void(^selectedRow)(NSIndexPath *indexPath);
@property (nonatomic, copy)void(^longPressRow)(NSIndexPath *indexPath);

- (void)setTitleForSection:(NSString *(^)(NSInteger section))titleForSection isSelectedForSection:(BOOL (^)(NSInteger section))isSelectedForSection;

- (void)setTitleForRow:(NSString *(^)(NSIndexPath *indexPath))titleForRow isSelectedForRow:(BOOL (^)(NSIndexPath *indexPath))isSelectedForRow;

@property(nonatomic, strong)UIColor *sectionColor; // 默认白
@property(nonatomic, strong)UIColor *rowColor; // 默认灰

@property (nonatomic, assign)BOOL selelctShow;

- (void)reloadData;

@end
