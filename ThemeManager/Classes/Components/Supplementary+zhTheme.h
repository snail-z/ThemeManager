//
//  Supplementary+zhTheme.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhThemePicker;

@interface UINavigationBar (zhThemeOverlay)

/// You can by `zh_overlayColorPicker` change the navigation bar background color. will better support animation.
@property (nullable, nonatomic, strong) zhThemePicker *zh_overlayColorPicker;

@end

@interface UITabBar (zhThemeOverlay)

/// You can by `zh_overlayColorPicker` change the tab bar background color. will better support animation.
@property (nullable, nonatomic, strong) zhThemePicker *zh_overlayColorPicker;

@end
