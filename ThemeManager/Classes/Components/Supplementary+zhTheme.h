//
//  Supplementary+zhTheme.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhThemeColorPicker;

@interface UINavigationBar (zhThemeOverlay)

/// You can by `zh_overlayColorPicker` change the navigation bar background color. will better support animation.
@property (nullable, nonatomic, strong) zhThemeColorPicker *zh_overlayColorPicker;

@end

@interface UITabBar (zhThemeOverlay)

/// You can by `zh_overlayColorPicker` change the tab bar background color. will better support animation.
@property (nullable, nonatomic, strong) zhThemeColorPicker *zh_overlayColorPicker;

@end
