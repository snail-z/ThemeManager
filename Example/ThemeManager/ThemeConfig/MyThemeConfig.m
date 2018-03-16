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
    NSString *defColorPath = [[NSBundle mainBundle] pathForResource:@"zhTheme_Color" ofType:@"plist"];
    NSString *defImagePath = [[NSBundle mainBundle] pathForResource:@"zhTheme_Image" ofType:@"plist"];
    
    zhThemeDefaultConfiguration *defaultConfiguration = [[zhThemeDefaultConfiguration alloc] init];
    defaultConfiguration.colorFilePath = defColorPath;
    defaultConfiguration.imageFilePath = defImagePath;
    defaultConfiguration.style = ThemeDay;
    
    ThemeManager.defaultConfiguration = defaultConfiguration;
    ThemeManager.themeColorChangeInterval = 0.25;
    
//    // 配置状态栏
//    NSDictionary *d = @{ThemeDay : @(UIStatusBarStyleLightContent),
//                        ThemeNight : @(UIStatusBarStyleDefault),
//                        Theme1 : @(UIStatusBarStyleLightContent),
//                        Theme2 : @(UIStatusBarStyleLightContent),
//                        Theme3 : @(UIStatusBarStyleLightContent)};
//    [[UIApplication sharedApplication] zh_setStatusBarStyle:d];
}

@end
