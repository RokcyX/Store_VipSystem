//
//  WBPopOverView.m
//  pop_test
//
//  Created by tuhui－03 on 16/5/19.
//  Copyright © 2016年 tuhui－03. All rights reserved.
//

#import "WBPopOverView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface WBPopOverView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UITableView *tableView;


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) WBArrowDirection direction;

@end

@implementation WBPopOverView

-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(WBArrowDirection)direction
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        //背景颜色为无色
        self.backgroundColor=[UIColor clearColor];
        
        //定义显示视图的参数
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        
        self.backView=[[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.backView.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
        [self addSubview:self.backView];
      
        [self buildView];
    }

    return self;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [self.tableView reloadData];
}

- (void)buildView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame), CGRectGetHeight(self.backView.frame)) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.backView addSubview:self.tableView=tableView];
}

#pragma mark tableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataList[indexPath.row];
    if ([dic.allKeys containsObject:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    }
    cell.textLabel.text =dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.checkItem) {
        self.checkItem(indexPath.row);
    }
    [self dismiss];
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    if (_direction==WBArrowDirectionLeftTop) {
        
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
    }
    else if (_direction==WBArrowDirectionLeftCenter)
    {
    
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
    
    }
    else if (_direction==WBArrowDirectionLeftBottom)
    {

        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRightTop)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRightCenter)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRightBottom)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionTopLeft)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionTopCenter)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
    }
    else if (_direction==WBArrowDirectionTopRight)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionBottomLeft)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
    else if (_direction==WBArrowDirectionBottomCenter)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
    else if (_direction==WBArrowDirectionBottomRight)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
   
    CGContextClosePath(context);
    [self.backView.backgroundColor setFill];
    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
 

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.backView]) {
        [self dismiss];
    }
}

-(void)popView
{
    NSArray *result=[self.backView subviews];
    for (UIView *view in result) {
        
        view.hidden=YES;
        
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    
    
    if (_direction==WBArrowDirectionLeftTop) {
        self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y-20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
        
    }
    else if (_direction==WBArrowDirectionLeftCenter)
    {
        self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y-self.height/2, self.width,self. height);

        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
    }
    else if (_direction==WBArrowDirectionLeftBottom)
    {
        self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+5, self.origin.y-self.height+20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
    }
    else if (_direction==WBArrowDirectionRightTop)
    {
        self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y-20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRightCenter)
    {
        self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y-self.height/2, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRightBottom)
    {
        self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-5, self.origin.y-self.height+20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionTopLeft)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-20, self.origin.y+5, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionTopCenter)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y+5, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionTopRight)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+20, self.origin.y+5, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionBottomLeft)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-20, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionBottomCenter)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionBottomRight)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width+20, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }

}

-(void)dismiss{
    
    NSArray *result=[self.backView subviews];
    for (UIView *view in result) {
        
        [view removeFromSuperview];

    }
    
         //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
                 
        }
    }];
     


}

@end

