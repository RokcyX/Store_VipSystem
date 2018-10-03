//
//  XYProgressHUD.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/8/2.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYProgressHUD.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

@implementation XYProgressHUD

+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(XYProgressHUDStatus)status text:(NSString *)text {
    
    XYProgressHUD *HUD = [XYProgressHUD sharedHUD];
    HUD.bezelView.color = RGBAColor(0, 0, 0, 0.8);
    HUD.contentColor=[UIColor whiteColor];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    //蒙版显示 YES , NO 不显示
    //        HUD.dimBackground = YES;
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.label.textColor = [UIColor whiteColor];
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XYProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case XYProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Success.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            HUD.customView = sucView;
            [HUD hideAnimated:YES afterDelay:1.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        case XYProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Error.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            HUD.customView = errView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        case XYProgressHUDStatusLoading: {
            HUD.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
            
        case XYProgressHUDStatusWaitting: {
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Warn.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
            
        }
            break;
            
        case XYProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Info.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    XYProgressHUD *HUD = [XYProgressHUD sharedHUD];
    HUD.bezelView.color = RGBAColor(0, 0, 0, 0.8);
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.contentColor=[UIColor whiteColor];
    [HUD setMinSize:CGSizeZero];
    [HUD setMode:MBProgressHUDModeText];
    //    HUD.dimBackground = YES;
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [HUD.label sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYProgressHUD sharedHUD] setShowNow:NO];
        [[XYProgressHUD sharedHUD] hideAnimated:YES];
    });
}

+ (void)showWaiting:(NSString *)text {
    
    [self showStatus:XYProgressHUDStatusWaitting text:text];
}

+ (void)showError:(NSString *)text {
    
    [self showStatus:XYProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:XYProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:XYProgressHUDStatusLoading text:text];
}

+ (void)hideHUD {
    
    [[XYProgressHUD sharedHUD] setShowNow:NO];
    [[XYProgressHUD sharedHUD] hideAnimated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
