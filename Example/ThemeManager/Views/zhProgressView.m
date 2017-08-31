//
//  zhProgressView.m
//  zhProgressView
//
//  Created by zhanghao on 2017/6/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhProgressView.h"

@interface zhProgressView ()

@property (nonatomic, assign) CGFloat moveWidth;

@end

@implementation zhProgressView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont fontWithName:@"GillSans-SemiBold" size:27];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _moveWidth, self.frame.size.height)];
    [_fillColor set];
    [bezierPath fill];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    _moveWidth = progress * self.frame.size.width;
    
    float decimals = progress * 100;
    if (decimals > 100.00) decimals = 100.00;
    _textLabel.text = [NSString stringWithFormat:@"%0.2f%%", decimals];
    
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    [self setNeedsDisplay];
}

@end
