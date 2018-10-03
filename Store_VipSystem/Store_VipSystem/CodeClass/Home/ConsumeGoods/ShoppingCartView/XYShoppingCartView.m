//
//  XYShoppingCartView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/24.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYShoppingCartView.h"

@interface XYShoppingCartView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *shoppingCartView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIButton *emptyButton;
@property (weak, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, strong)NSArray *datalist;
@property (nonatomic, strong)NSString *sectionString;
@property (nonatomic, copy)void(^emptyFinished)(void);

@end

@implementation XYShoppingCartView

- (UIView *)shoppingCartView {
    if (!_shoppingCartView) {
        UIView *shoppingCartView = [[UIView alloc] init];
        shoppingCartView.backgroundColor = [UIColor whiteColor];
        shoppingCartView.layer.cornerRadius = 6;
        shoppingCartView.userInteractionEnabled = YES;
        shoppingCartView.clipsToBounds = YES;
        [self.view addSubview:self.shoppingCartView=shoppingCartView];
    }
    return _shoppingCartView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.text = @"购物车";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.shoppingCartView addSubview:self.titleLabel=titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        //        cancleBtn.layer.cornerRadius = 8;
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.tag = 101;
        [cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.shoppingCartView addSubview:self.cancelButton = cancleBtn];
    }
    return _cancelButton;
}

- (UIButton *)emptyButton {
    if (_emptyButton == nil) {
        UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyButton.backgroundColor = [UIColor whiteColor];
        //        cancleBtn.layer.cornerRadius = 8;
        emptyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [emptyButton setTitle:@"清空" forState:UIControlStateNormal];
        [emptyButton setTitleColor:RGBColor(249, 104, 62) forState:UIControlStateNormal];
        emptyButton.tag = 102;
        [emptyButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.shoppingCartView addSubview:self.emptyButton = emptyButton];
    }
    return _emptyButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        tableView.showsVerticalScrollIndicator = false;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        tableView.tableFooterView = UIView.new;
        [self.shoppingCartView addSubview:self.tableView = tableView];
    }
    return _tableView;
}

- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 102) {
        // 清空
        for (XYCommodityModel *obj in self.datalist) {
            obj.count = 0;
        }
        self.datalist = nil;
        self.sectionString = [NSString stringWithFormat:@"%ld种商品，共%d件", self.datalist.count, 0];
        [self.tableView reloadData];
        if (self.emptyFinished) {
            self.emptyFinished();
        }
    } else {
        // 取消
        [self dismissView];
    }
}

- (instancetype)initWithDataList:(NSArray *)datalist emptyFinished:(void (^)(void))emptyFinished {
    if (self = [super init]) {
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.emptyFinished = emptyFinished;
        self.datalist = datalist;
        NSInteger count = 0;
        for (XYCommodityModel *obj in self.datalist) {
            count += obj.count;
        }
        self.sectionString = [NSString stringWithFormat:@"%ld种商品，共%ld件", self.datalist.count, count];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    WeakSelf;
    [self.shoppingCartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_centerY);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.shoppingCartView);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(80);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.cancelButton.mas_centerY);
        make.centerX.equalTo(weakSelf.shoppingCartView.mas_centerX);
        make.left.equalTo(weakSelf.cancelButton.mas_right);
    }];
    
    [self.emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.cancelButton);
        make.left.equalTo(weakSelf.titleLabel.mas_right);
        make.right.equalTo(weakSelf.shoppingCartView.mas_right);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cancelButton.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.shoppingCartView);
    }];
}

#pragma mark -TableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell = [cell initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    XYCommodityModel *model = self.datalist[indexPath.row];
    cell.textLabel.text = model.pM_Name;
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2lf   x%ld",model.pM_UnitPrice, model.count]];
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(0, [NSString stringWithFormat:@"%.2lf", model.pM_UnitPrice].length)];

    cell.detailTextLabel.attributedText = attributedStr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  60;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WeakSelf;
    [UIView animateWithDuration:.1 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.5];
    }];
    
}

- (void)dismissView {
    WeakSelf;
    [UIView animateWithDuration:.1 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0];
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
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
