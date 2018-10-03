//
//  XYInvoicingGoodsFooterView.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/25.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYInvoicingGoodsFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign)BOOL isOpen;

@property (nonatomic, copy)void(^openGoodsView)(BOOL isOpen);

@property (nonatomic, copy)NSMutableAttributedString *attributedStr;

@end
