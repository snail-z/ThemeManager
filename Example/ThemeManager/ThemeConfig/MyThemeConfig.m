//
//  zhThemeConfigs.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "MyThemeConfig.h"

@implementation MyThemeConfig

+ (void)config {
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"zhTheme_Color" ofType:@"plist"];
    ThemeManager.defaultColorFile = path1;
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"zhTheme_Image" ofType:@"plist"];
    ThemeManager.defaultImageFile = path2;
    
    ThemeManager.defaultStyle = ThemeDay;
    
    ThemeManager.changeThemeColorAnimationDuration = 0.35;
    
    // 配置状态栏
    NSDictionary *d = @{ThemeDay : @(UIStatusBarStyleLightContent),
                        ThemeNight : @(UIStatusBarStyleDefault),
                        Theme1 : @(UIStatusBarStyleLightContent),
                        Theme2 : @(UIStatusBarStyleLightContent),
                        Theme3 : @(UIStatusBarStyleLightContent)};
    [[UIApplication sharedApplication] zh_setStatusBarStyle:d];
}

@end
