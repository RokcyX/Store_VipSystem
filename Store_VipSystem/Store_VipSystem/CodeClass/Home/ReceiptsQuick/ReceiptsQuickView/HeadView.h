//
//  HeadView.h
//  Calculator
//
//  Created by Wcaulpl on 2017/9/4.
//  Copyright © 2017年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

- (NSString *)text;
- (void)setText:(NSString *)text;

- (void)setString:(NSString *)string;

- (NSString *)string;

- (void)setCardNum:(NSString *)cardNum;
- (void)setBalance:(NSString *)balance;
- (void)setIntegral:(NSString *)integral;

- (void)setTitleHidden;
@end
