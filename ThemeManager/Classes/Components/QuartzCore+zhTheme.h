//
//  QuartzCore+zhTheme.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class zhThemePicker;

@interface CALayer (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_backgroundColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_borderColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_shadowColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_borderWidthPicker;

@end

@interface CAShapeLayer (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_fillColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_strokeColorPicker;

@end
