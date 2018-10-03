//
//  XYTextView.m
//  Store_VipSystem
//
//  Created by Wcaulpl on 2018/9/13.
//  Copyright © 2018年 Wcaulpl. All rights reserved.
//

#import "XYTextView.h"

@interface XYTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation XYTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        self.delegate = self;
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.placeholderLabel=placeholderLabel];
        WeakSelf;
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(weakSelf).offset(10);
            make.left.equalTo(weakSelf.mas_left).offset(10);
        }];
    }
    return _placeholderLabel;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

@end
