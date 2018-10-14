//
//  XYConsumeGoodsController.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYConsumeGoodsController.h"
#import "XYVerticalSegmentedControl.h"
#import "XYHomeBasicView.h"
#import "SLScanQCodeViewController.h"
#import "XYCommodityViewCell.h"
#import "XYGoodsClassifyModel.h"
#import "XYShoppingCartFootView.h"
#import "XYShoppingCartView.h"
#import "XYInvoicingViewController.h"

@interface XYConsumeGoodsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)XYHomeBasicView *basicView;
@property (nonatomic, weak)XYVerticalSegmentedControl *verticalSegmentedControl;
@property (nonatomic, weak)XYShoppingCartFootView *shopCarView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *parameters;
@property (nonatomic, assign)NSInteger pageTotal;
@property (nonatomic, strong)NSMutableArray *datalist;
@property (nonatomic, strong)NSMutableArray *dataALLlist;

@property (nonatomic, strong)NSArray *classifylist;
@property (nonatomic, assign)BOOL isAll;

@property (nonatomic, strong)NSMutableArray *layers;

@end

@implementation XYConsumeGoodsController

- (void)loadData {
    //    /api/ProductManger/QueryDataList
    WeakSelf;
    [AFNetworkManager postNetworkWithUrl:@"api/ProductManger/QueryDataList" parameters:self.parameters succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.pageTotal = [dic[@"data"][@"PageTotal"] integerValue];
            if ([dic[@"data"][@"PageIndex"] integerValue] == 1) {
                weakSelf.datalist = [XYCommodityModel modelConfigureWithArray:dic[@"data"][@"DataList"] alldataList:self.dataALLlist];
            } else {
                [weakSelf.datalist addObjectsFromArray:[XYCommodityModel modelConfigureWithArray:dic[@"data"][@"DataList"] alldataList:self.dataALLlist]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (weakSelf.datalist.count) {
                    if ([self.parameters[@"PageIndex"] integerValue] == 1) {
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                    }
                } else {
                    [XYProgressHUD showMessage:@"暂无数据"];
                }
            });
        }
    } failure:^(NSError *error) {
        
    } showMsg:[self.parameters[@"PageIndex"] integerValue] == 1 ? YES : NO];
    
}

- (void)loadAllProductTypeList {
    WeakSelf;
    self.isAll = YES;
    [AFNetworkManager postNetworkWithUrl:@"api/ProductTypeManager/QueryAllProductTypeBySM_ID" parameters:nil succeed:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            weakSelf.classifylist = [XYGoodsClassifyModel modelConfigureWithArray:dic[@"data"]];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.classifylist.count) {
                [XYProgressHUD showMessage:@"暂无数据"];
            } else {
                weakSelf.verticalSegmentedControl.countForSection = ^NSInteger{
                    return weakSelf.classifylist.count + 1;
                };
                weakSelf.verticalSegmentedControl.countForRow = ^NSInteger(NSInteger section) {
                    if (section) {
                        XYGoodsClassifyModel *model = weakSelf.classifylist[section-1];
                        if (model.isOpen) {
                            return model.subList.count;
                        }
                    }
                    return 0;
                };
                [weakSelf.verticalSegmentedControl setTitleForSection:^NSString *(NSInteger section) {
                    if (!section) {
                        return @"全部商品";
                    }
                    return [weakSelf.classifylist[section-1] pT_Name];
                } isSelectedForSection:^BOOL(NSInteger section) {
                    if (!section) {
                        return weakSelf.isAll;
                    }
                    return [weakSelf.classifylist[section-1] isSelected];
                }];
                
                [weakSelf.verticalSegmentedControl setTitleForRow:^NSString *(NSIndexPath *indexPath) {
                    return [[weakSelf.classifylist[indexPath.section-1] subList][indexPath.row] pT_Name];
                } isSelectedForRow:^BOOL(NSIndexPath *indexPath) {
                    return [[weakSelf.classifylist[indexPath.section-1] subList][indexPath.row] isSelected];
                }];
                
                [weakSelf.verticalSegmentedControl reloadData];
            }
        });
    } failure:^(NSError *error) {
        
    } showMsg:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self setFootViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataALLlist = [NSMutableArray array];
    self.title = @"商品消费";
//    if ([LoginModel judgeAuthorityWithString:self.title]) {
        [self loadAllProductTypeList];
        
        self.parameters = @{
                            @"PageIndex":@1,
                            @"PageSize":KPageSize,
                            @"DataType":@2
                            }.mutableCopy;
        [self loadData];
        [self setupUI];
        
        WeakSelf;
        self.dataOverload = ^{
            [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
            [weakSelf loadData];
        };
        
        // 下拉刷新
        self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf.parameters setValue:@1 forKey:@"PageIndex"];
            [weakSelf loadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        
        // 上拉加载more
        
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            NSInteger pageIndex = [weakSelf.parameters[@"PageIndex"] integerValue];
            if (pageIndex < weakSelf.pageTotal) {
                [weakSelf.parameters setValue:@(pageIndex+1) forKey:@"PageIndex"];
                [weakSelf loadData];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
//    }
}

// 扫描
- (void)scanAction {
    SLScanQCodeViewController * sqVC = [[SLScanQCodeViewController alloc]init];
    WeakSelf;
    [sqVC setSendTask:^(NSString *string) {
        [weakSelf.parameters setValue:string forKey:@"PM_Code"];
        weakSelf.basicView.searchField.text = string;
        [weakSelf firstLoadData];
    }];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];
}

// 搜索
- (void)searchDataAcion:(UITextField *)textField {
    [self.parameters setValue:textField.text forKey:@"PM_Code"];
    [self firstLoadData];
}

- (void)firstLoadData {
    [self.parameters setValue:@1 forKey:@"PageIndex"];
    [self loadData];
}

- (XYVerticalSegmentedControl *)verticalSegmentedControl {
    if (!_verticalSegmentedControl) {
        XYVerticalSegmentedControl *verticalSegmentedControl = [[XYVerticalSegmentedControl alloc] init];
        WeakSelf;
        verticalSegmentedControl.selectedSection = ^(NSInteger section) {
            if (!section) {
                weakSelf.isAll = YES;
                for (XYGoodsClassifyModel *obj in weakSelf.classifylist) {
                    if (obj.isOpen && obj.subList.count) {
                        for (XYGoodsClassifyModel *subObj in obj.subList) {
                            subObj.isSelected = NO;
                        }
                    }
                    obj.isSelected = NO;
                    obj.isOpen = NO;
                }
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
                [weakSelf firstLoadData];
                [weakSelf.verticalSegmentedControl reloadData];
                return ;
            }
            weakSelf.isAll = NO;
            XYGoodsClassifyModel *model = weakSelf.classifylist[section-1];
            if (model.isSelected) {
                weakSelf.isAll = YES;
                model.isSelected = NO;
                model.isOpen = NO;
                for (XYGoodsClassifyModel *obj in model.subList) {
                    obj.isSelected = NO;
                }
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
            } else {
                for (XYGoodsClassifyModel *obj in weakSelf.classifylist) {
                    if (obj.isOpen && obj.subList.count) {
                        for (XYGoodsClassifyModel *subObj in obj.subList) {
                            subObj.isSelected = NO;
                        }
                    }
                    obj.isSelected = NO;
                    obj.isOpen = NO;
                }
                model.isSelected = YES;
                model.isOpen = YES;
                [weakSelf.parameters setValue:model.gID forKey:@"PT_GID"];
            }
            [weakSelf firstLoadData];
            [weakSelf.verticalSegmentedControl reloadData];
        };
        
        verticalSegmentedControl.selectedRow = ^(NSIndexPath *indexPath) {
            XYGoodsClassifyModel *model = weakSelf.classifylist[indexPath.section-1];
            model.isSelected = NO;
            XYGoodsClassifyModel *subModel = model.subList[indexPath.row];
            if (subModel.isSelected) {
                weakSelf.isAll = YES;
                subModel.isSelected = NO;
                [weakSelf.parameters setValue:@"" forKey:@"PT_GID"];
            } else {
                for (XYGoodsClassifyModel *obj in model.subList) {
                    obj.isSelected = NO;
                }
                subModel.isSelected = YES;
                [weakSelf.parameters setValue:subModel.gID forKey:@"PT_GID"];
            }
            [weakSelf firstLoadData];
        };
        [self.view addSubview:self.verticalSegmentedControl=verticalSegmentedControl];
    }
    return _verticalSegmentedControl;
}

- (void)setupUI {
    XYHomeBasicView *basicView = [[XYHomeBasicView alloc] init];
    self.view = self.basicView = basicView;
    WeakSelf;
    [basicView.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:(UIControlEventTouchUpInside)];
    basicView.searchField.placeholder = @"请输入商品编号";
    [basicView.searchField addTarget:self action:@selector(searchDataAcion:) forControlEvents:(UIControlEventEditingChanged)];
    
    [self.verticalSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.basicView.searchField.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XYCommodityViewCell class] forCellReuseIdentifier:@"XYCommodityViewCell"];
    [self.basicView addSubview:self.tableView=tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.verticalSegmentedControl.mas_right);
        make.right.equalTo(weakSelf.basicView);
        make.top.equalTo(weakSelf.verticalSegmentedControl.mas_top);
        make.bottom.equalTo(weakSelf.verticalSegmentedControl.mas_bottom);
    }];
    
    XYShoppingCartFootView *shopCarView = [[XYShoppingCartFootView alloc] init];
    shopCarView.shoppingCartShow = ^{
        [weakSelf shoppingCartShow];
    };
    shopCarView.invoicingAmount = ^{
        [weakSelf InvoicingViewShow];
    };
    [self.basicView addSubview:self.shopCarView=shopCarView];
    [shopCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.basicView);
        make.height.mas_equalTo(60);
        make.top.equalTo(weakSelf.tableView.mas_bottom);
    }];
}

- (void)shoppingCartShow {
    NSMutableArray *array = [NSMutableArray array];
    for (XYCommodityModel *obj in self.dataALLlist) {
        if (obj.count) {
            [array addObject:obj];
        }
    }
    WeakSelf;
    XYShoppingCartView *shoppingView = [[XYShoppingCartView alloc] initWithDataList:array emptyFinished:^{
        weakSelf.shopCarView.goodsNum = 0;
        weakSelf.shopCarView.amountString = @"0.00";
        [weakSelf.tableView reloadData];
    }];
    [self presentViewController:shoppingView animated:YES completion:nil];

}

- (void)InvoicingViewShow {
    NSMutableArray *array = [NSMutableArray array];
    for (XYCommodityModel *obj in self.dataALLlist) {
        if (obj.count) {
            [array addObject:obj];
        }
    }
    if (!array.count) {
        [XYProgressHUD showMessage:@"请选择商品"];
        return;
    }
    XYInvoicingViewController *invoicVc = [[XYInvoicingViewController alloc] init];
    invoicVc.isConsume = YES;
    invoicVc.goodslist = array;
    [self.navigationController pushViewController:invoicVc animated:YES];
}

#pragma mark tableView dataSouce delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYCommodityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYCommodityViewCell" forIndexPath:indexPath];
    WeakSelf;
    cell.addToShoppingCart = ^(XYCommodityViewCell *currentCell) {
//        if (weakSelf.layer) {
//            return NO;
//        }
        [weakSelf startAnimationWithCell:currentCell];
        return YES;
    };
    cell.model = self.datalist[indexPath.row];
    
    return cell;
}

- (NSMutableArray *)layers {
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

-(void)startAnimationWithCell:(XYCommodityViewCell *)currCell {
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:currCell]];
    CGRect rectInSuperView = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CALayer *layer = [CALayer layer];
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.bounds = currCell.commodityImageView.bounds;
    [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
    layer.opacity = 1;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    layer.position = rectInSuperView.origin;
    layer.contents = (__bridge id)currCell.commodityImageView.image.CGImage;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(rectInSuperView) - 20, CGRectGetMaxY(rectInSuperView) - 20)];
    [path addQuadCurveToPoint:CGPointMake(40, CGRectGetMidY(self.shopCarView.frame)) controlPoint:CGPointMake(150, 20)];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    NSString *key = @"group".orderCode;
    [layer addAnimation:groups forKey:key];
    [self.layers addObject:@{key:layer}];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *layer;
    for (NSDictionary *dic in self.layers) {
        CALayer *subLayer = dic.allValues.firstObject ;
        if ([subLayer animationForKey:dic.allKeys.firstObject] == anim) {
            layer = subLayer;
        }
    }
    [self setFootViewModel];
    [layer removeFromSuperlayer];
    [self.layers removeObject:layer];
    layer = nil;
}

- (void)setFootViewModel {
    NSInteger goodsNum = 0;
    CGFloat amount = 0.00;
    for (XYCommodityModel *obj in self.dataALLlist) {
        goodsNum += obj.count;
        amount += (obj.count * obj.pM_UnitPrice);
    }
    self.shopCarView.goodsNum = goodsNum;
    self.shopCarView.amountString = [NSString stringWithFormat:@"%.2lf", amount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
