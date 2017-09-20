//
//  zhSwitchButton.m
//  ThemeManager
//
//  Created by zhanghao on 2017/9/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhSwitchButton.h"

@implementation zhSwitchButton

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.adjustsImageWhenHighlighted = NO; // adjustsImageWhenHighlighted
        self.imageView.contentMode = UIViewContentModeCenter;
        [self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchDown];// UIControlEventTouchDown
        self.on = NO;
    }
    return self;
}

- (void)setOnImage:(UIImage *)onImage {
    [self setBackgroundImage:onImage forState:UIControlStateNormal];
}

- (void)setOffImage:(UIImage *)offImage {
    [self setBackgroundImage:offImage forState:UIControlStateSelected];
}

- (void)buttonClicked {
    self.on = !self.on;
    [self sendActionsForControlEvents:UIControlEventValueChanged]; // UIControlEventValueChanged
}

- (void)setOn:(BOOL)on {
    _on = on;
    self.selected = on;
}

@end
