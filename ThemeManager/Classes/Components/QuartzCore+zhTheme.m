//
//  QuartzCore+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "QuartzCore+zhTheme.h"
#import "NSObject+zhTheme.h"

@implementation CALayer (zhTheme)

- (zhThemePicker *)zh_backgroundColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_backgroundColorPicker:(zhThemePicker *)zh_backgroundColorPicker {
    setThemeCGPicker(zh_backgroundColorPicker, self, @"backgroundColor");
}

- (zhThemePicker *)zh_borderColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_borderColorPicker:(zhThemePicker *)zh_borderColorPicker {
    setThemeCGPicker(zh_borderColorPicker, self, @"borderColor");
}

- (zhThemePicker *)zh_shadowColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_shadowColorPicker:(zhThemePicker *)zh_shadowColorPicker {
    setThemeCGPicker(zh_shadowColorPicker, self, @"shadowColor");
}

- (zhThemePicker *)zh_borderWidthPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_borderWidthPicker:(zhThemePicker *)zh_borderWidthPicker {
    setThemePicker(zh_borderWidthPicker, self, @"borderWidth");
}

@end

@implementation CAShapeLayer (zhTheme)

- (zhThemePicker *)zh_fillColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_fillColorPicker:(zhThemePicker *)zh_fillColorPicker {
    setThemeCGPicker(zh_fillColorPicker, self, @"fillColor");
}

- (zhThemePicker *)zh_strokeColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_strokeColorPicker:(zhThemePicker *)zh_strokeColorPicker {
    setThemeCGPicker(zh_strokeColorPicker, self, @"strokeColor");
}

@end

