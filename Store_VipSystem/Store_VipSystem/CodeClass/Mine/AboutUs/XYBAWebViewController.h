//
//  XYBAWebViewController.h
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/11.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYBasicViewController.h"

@interface XYBAWebViewController : XYBasicViewController

- (void)ba_web_loadURLString:(NSString *)URLString;

- (void)ba_web_loadHTMLString:(NSString *)htmlString;

@end
