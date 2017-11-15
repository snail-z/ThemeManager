//
//  zhTestView.m
//  ThemeManager_Example
//
//  Created by zhanghao on 2017/11/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhTestView.h"

@implementation zhTestView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _aImgView = [UIImageView new];
        _aImgView.image = [UIImage imageNamed:@"style1_me"];
        _aImgView.layer.borderColor = [UIColor cyanColor].CGColor;
        _aImgView.layer.borderWidth = 1;
        [self addSubview:_aImgView];
        
        _aLabel = [UILabel new];
        _aLabel.text = @"I'm a label";
        _aLabel.textColor = [UIColor whiteColor];
        _aLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:24];
        _aLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_aLabel];
        
        _aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aButton.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:24];
        [_aButton setTitle:@"Click me" forState:UIControlStateNormal];
        _aButton.layer.borderColor = [UIColor cyanColor].CGColor;
        _aButton.layer.borderWidth = 1;
        _aButton.layer.cornerRadius = 4;
        [self addSubview:_aButton];
    }
    return self;
}

- (void)subviewsLayout:(CGSize)imgSize {
    _aImgView.size = imgSize;
    _aImgView.centerX = self.width / 2;
    _aImgView.centerY = _aImgView.height / 2 + 10;
    
    _aLabel.size = CGSizeMake(self.width, 30);
    _aLabel.centerX = self.width / 2;
    _aLabel.centerY = self.height / 2;
    
    _aButton.size = CGSizeMake(170, 50);
    _aButton.centerX = self.width / 2;
    _aButton.bottom = self.height - 10;
}

- (void)setLabelBackgroundColor:(UIColor *)bgColor
               buttonTitleColor:(UIColor *)titleColor
                       andState:(NSInteger)state
                          image:(UIImage *)image
                        imgSize:(CGSize)imgSize {
    
    _aLabel.backgroundColor = bgColor;
    [_aButton setTitleColor:titleColor forState:UIControlStateNormal];
    _aImgView.image = image;
    [self subviewsLayout:imgSize];
    
    NSLog(@"输出imgsize=============> %@", NSStringFromCGSize(imgSize));
    NSLog(@"输出state=============> %lu", state);
}

@end
