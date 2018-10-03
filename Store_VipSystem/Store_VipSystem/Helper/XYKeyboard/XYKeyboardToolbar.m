//
//  SLToolbar.m
//  WashCircle
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 SLlinker. All rights reserved.
//

#import "XYKeyboardToolbar.h"

@interface XYKeyboardToolbar ()

@property(nonatomic, weak)UIBarButtonItem *cancelBarButton;
@property(nonatomic, weak)UIBarButtonItem *confirmBarButton;

@end

@implementation XYKeyboardToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelTouchUpInside:)] ;
        
        UIBarButtonItem *confirmBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmTouchUpInside:)];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
        
        self.items = @[cancelBarButton, spaceItem, spaceItem, confirmBarButton];
        self.cancelBarButton = cancelBarButton;
        self.confirmBarButton = confirmBarButton;
    }
    return self;
}

- (void)cancelTouchUpInside:(UIBarButtonItem *)barButtonitem {
    if (self.finished) {
        self.finished(NO);
    }
}

- (void)confirmTouchUpInside:(UIBarButtonItem *)barButtonitem {
    if (self.finished) {
        self.finished(YES);
    }
}

+ (XYKeyboardToolbar *)defaultToolbar {
    static XYKeyboardToolbar *toolbar = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        toolbar = [[XYKeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
//    });
    //    toolbar.barStyle = UIBarStyleDefault;
    return toolbar;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
