//
//  VerticalSegmentedControl.m
//  VerticalSegmentedControl-Demo
//
//  Created by Vincent on 2/25/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import "XYVerticalSegmentedControl.h"
#import "XYVerticalSegmentedControlView.h"

@interface XYVerticalSegmentedControl () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation XYVerticalSegmentedControl
#pragma mark - APIs

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionColor = [UIColor whiteColor];
        self.rowColor = RGBColor(247, 248, 249);
        [self buildViews];
//        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return self;
}


#pragma mark - Private Methods
- (void)buildViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = UIView.new;
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self addSubview:self.tableView = tableView];
    self.sectionHeight = self.rowHeight = 50.f;
    WeakSelf;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf);
    }];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    self.tableView.rowHeight = rowHeight;
    [self.tableView reloadData];
}

- (void)setSectionHeight:(CGFloat)sectionHeight {
    _sectionHeight = sectionHeight;
    self.tableView.sectionHeaderHeight = sectionHeight;
    [self.tableView reloadData];
    
}

- (void)setTitleForRow:(NSString *(^)(NSIndexPath *))titleForRow isSelectedForRow:(BOOL (^)(NSIndexPath *))isSelectedForRow {
    self.titleForRow = titleForRow;
    self.isSelectedForRow = isSelectedForRow;
}

- (void)setTitleForSection:(NSString *(^)(NSInteger))titleForSection isSelectedForSection:(BOOL (^)(NSInteger))isSelectedForSection {
    self.titleForSection = titleForSection;
    self.isSelectedForSection = isSelectedForSection;
}

#pragma mark - Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.countForSection) {
        return self.countForSection();
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.countForRow) {
        return self.countForRow(section);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(section);
    }
    UITableViewHeaderFooterView *heaaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    XYVerticalSegmentedControlView *verSeg = [heaaderView viewWithTag:101];
    if (!verSeg) {
        verSeg = [[XYVerticalSegmentedControlView alloc] init];
        verSeg.tag = 101;
        WeakSelf;
        [heaaderView.contentView addSubview:verSeg];
        [verSeg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(heaaderView.contentView);
        }];
    }
    verSeg.backgroundColor = self.sectionColor;
    verSeg.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    verSeg.selectedView = self.selectedSection;
    if (self.titleForSection && self.isSelectedForSection) {
        [XYAppDelegate.window endEditing:YES];
        [verSeg setSegmentTitle:self.titleForSection(section) selected:self.isSelectedForSection(section)];
    }
    return heaaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewForFooterInSection) {
        return self.sectionHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(section);
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.accessoryType = self.accessoryType;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    XYVerticalSegmentedControlView *verSeg = [cell.contentView viewWithTag:101];
    UIView *rightLine = [cell viewWithTag:102];
    UIButton *checkBtn = [cell.contentView viewWithTag:103];
    if (!verSeg) {
        verSeg = [[XYVerticalSegmentedControlView alloc] init];
        verSeg.tag = 101;
        verSeg.lineView.hidden = YES;
        [cell.contentView addSubview:verSeg];
        [verSeg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell.contentView);
        }];
        
        rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = RGBColor(222, 222, 222);
        rightLine.tag = 102;
        [cell addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(cell);
            make.width.mas_equalTo(1);
        }];
        
        checkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        checkBtn.tag = 103;
        [checkBtn setImage:[UIImage imageNamed:@"check_box_circle_normal"] forState:(UIControlStateNormal)];
        [checkBtn setImage:[UIImage imageNamed:@"check_box_circle_selected"] forState:(UIControlStateSelected)];
        checkBtn.hidden = YES;
        checkBtn.userInteractionEnabled = NO;
        checkBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 5);
        [cell.contentView addSubview:checkBtn];
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(cell.contentView);
            make.width.mas_equalTo(35);
        }];
    }
    verSeg.backgroundColor = self.rowColor;
    verSeg.indexPath = indexPath;
    verSeg.longPressView = self.longPressRow;
    NSString *title = @"";
    BOOL isSelected = NO;
    if (self.titleForRow && self.isSelectedForRow) {
        title = self.titleForRow(indexPath);
    }
    if (self.titleForRow && self.isSelectedForRow) {
        isSelected = self.isSelectedForRow(indexPath);
    }
    [verSeg setSegmentTitle:title selected:isSelected];
    if (self.selelctShow) {
        [verSeg setSegmentTitle:title selected:NO];
    }
    rightLine.hidden = isSelected;
    verSeg.rightLine.hidden = YES;
    checkBtn.hidden = !self.selelctShow;
    checkBtn.selected = isSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [XYAppDelegate.window endEditing:YES];
    if (self.selectedRow) {
        self.selectedRow(indexPath);
    }
    [tableView reloadData];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [XYAppDelegate.window endEditing:YES];
}

@end
