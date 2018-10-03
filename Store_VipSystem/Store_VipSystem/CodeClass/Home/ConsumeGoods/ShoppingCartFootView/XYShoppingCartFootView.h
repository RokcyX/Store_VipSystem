//
//  ShoppingCartFootView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/24.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYShoppingCartFootView : UIView

@property (nonatomic, copy)NSString *amountString;

@property (nonatomic, assign)NSInteger goodsNum;

@property (nonatomic, copy)void(^invoicingAmount)(void);
@property (nonatomic, copy)void(^shoppingCartShow)(void);


@end
