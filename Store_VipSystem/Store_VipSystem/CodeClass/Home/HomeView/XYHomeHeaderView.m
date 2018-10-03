//
//  XYHomeHeaderView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/4.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYHomeHeaderView.h"
#import "XYHomeFuncView.h"
#import "JHHorizontalPageFlowlayout.h"
@interface XYHomeHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation XYHomeHeaderView 

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    self.pageControl.numberOfPages = listArray.count/8 + (listArray.count%8 > 0 ? 1 : 0);
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidSubViews];
    }
    return self;
}

- (void)bulidSubViews {
    
    JHHorizontalPageFlowlayout *layout = [[JHHorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:4];
    [layout setColumnSpacing:10 rowSpacing:20 edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 23) collectionViewLayout:layout];
    [self addSubview:self.collectionView=collectionView];
    collectionView.bounces = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    WeakSelf;
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(23);
//    }];
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    // 设置当前所在页数
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [pageControl setValue:[UIImage imageNamed:@"home_pag_currentImage"] forKeyPath:@"_currentPageImage"];
    [pageControl setValue:[UIImage imageNamed:@"home_page_image"] forKeyPath:@"_pageImage"];
    [self addSubview:self.pageControl=pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(50);
    }];
}

#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    NSLog(@"offsetX=%f", offsetX);
    self.pageControl.currentPage = offsetX>0.8 ? 1 : 0;
    NSLog(@"%ld", self.pageControl.currentPage);
}

#pragma mark--UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    XYHomeFuncView *funcView = [cell.contentView viewWithTag:102];
    if (!funcView) {
        funcView = [[XYHomeFuncView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame))];
        funcView.tag = 102;
        funcView.iconView.contentMode = UIViewContentModeScaleAspectFit;
        funcView.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [cell.contentView addSubview:funcView];
    }
    funcView.iconView.image = [UIImage imageNamed:self.listArray[indexPath.item][@"image"]];
    funcView.titleLabel.text = self.listArray[indexPath.item][@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld组的第%ld个", indexPath.section, indexPath.item);
    if (self.clickItem) {
        self.clickItem(indexPath.item);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
