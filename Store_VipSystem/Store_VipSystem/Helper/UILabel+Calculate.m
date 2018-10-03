//
//  UILabel+Calculate.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/15.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "UILabel+Calculate.h"

@implementation UILabel (Calculate)

- (CGFloat)calculateWidth {
    NSDictionary *dic = @{NSFontAttributeName:self.font};  //指定字号
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(0,15)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

@end
