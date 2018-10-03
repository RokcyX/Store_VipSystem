//
//  WBPopOverView.h
//  pop_test
//
//  Created by tuhui－03 on 16/5/19.
//  Copyright © 2016年 tuhui－03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger,WBArrowDirection){
    //箭头位置
    WBArrowDirectionLeftTop=1,//左上
    WBArrowDirectionLeftCenter,//左中
    WBArrowDirectionLeftBottom,//左下
    WBArrowDirectionRightTop,//右上
    WBArrowDirectionRightCenter,//右中
    WBArrowDirectionRightBottom,//右下
    WBArrowDirectionTopLeft,//上左
    WBArrowDirectionTopCenter,//上中
    WBArrowDirectionTopRight,//上右
    WBArrowDirectionBottomLeft,//下左
    WBArrowDirectionBottomCenter,//下中
    WBArrowDirectionBottomRight,//下右

};

@interface WBPopOverView : UIView
@property (nonatomic, strong) UIView *backView;

-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(WBArrowDirection)direction;//初始化
@property (nonatomic, strong)NSArray *dataList;
-(void)popView;//弹出视图
-(void)dismiss;//隐藏视图

@property (nonatomic, copy)void(^checkItem)(NSInteger index);

@end
