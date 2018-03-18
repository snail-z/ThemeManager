//
//  zhAppDelegate+ThemeConfig.m
//  ThemeManager_Example
//
//  Created by zhanghao on 2018/3/18.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "zhAppDelegate+ThemeConfig.h"

@implementation zhAppDelegate (ThemeConfig)

- (void)themeConfig {
    NSString *defColorPath = [[NSBundle mainBundle] pathForResource:@"ThemeColor" ofType:@"plist"];
    NSString *defImagePath = [[NSBundle mainBundle] pathForResource:@"ThemeImage" ofType:@"plist"];
    
    NSLog(@"defImagePath is: %@", defImagePath);
    
    NSString *paf = [NSBundle mainBundle].bundlePath;
    NSLog(@"paf is: %@", paf);
    
    zhThemeDefaultConfiguration *defaultConfiguration = [[zhThemeDefaultConfiguration alloc] init];
    defaultConfiguration.colorFilePath = defColorPath;
    defaultConfiguration.imageFilePath = defImagePath;
    defaultConfiguration.style = ThemeDay;
    
    ThemeManager.defaultConfiguration = defaultConfiguration;
    ThemeManager.themeColorChangeInterval = 0.25;
    ThemeManager.debugLogEnabled = YES;
    
    // 配置状态栏
    NSDictionary *d = @{ThemeDay : @(UIStatusBarStyleLightContent),
                        ThemeNight : @(UIStatusBarStyleDefault),
                        Theme1 : @(UIStatusBarStyleLightContent),
                        Theme2 : @(UIStatusBarStyleLightContent),
                        Theme3 : @(UIStatusBarStyleLightContent)};
    [[UIApplication sharedApplication] zh_setStatusBarStyle:d];
}

@end
