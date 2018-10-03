//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendTask)(NSString *string);

@interface SLScanQCodeViewController : UIViewController

@property(nonatomic, copy)SendTask sendTask;

- (void)setSendTask:(SendTask)sendTask;
@end
