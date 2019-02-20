//
//  zhThemeOperator.m
//  ThemeManager_Example
//
//  Created by zhanghao on 2019/2/19.
//  Copyright © 2019年 snail-z. All rights reserved.
//

#import "zhThemeOperator.h"

NSString *AppThemeLight = @"DAY";
NSString *AppThemeNight = @"NIGHT";
NSString *AppThemeStyle1 = @"STYLE1";
NSString *AppThemeStyle2 = @"STYLE2";
NSString *AppThemeStyle3 = @"STYLE3";

@implementation zhThemeOperator

+ (void)themeConfiguration {
    zhThemeManager *manager = [zhThemeManager sharedManager];
    manager.debugLogEnabled = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ThemeInfo" ofType:@"plist"];
    manager.themeInfoFilePath = path;
    
    NSString *aKey = [self getThemeStyleKey];
    if (!aKey) aKey = AppThemeLight;
    [manager updateThemeStyle:aKey];
}

+ (void)changeThemeDayOrNight {
    NSString *styleKey = [ThemeManager.style isEqualToString:AppThemeLight] ? AppThemeNight : AppThemeLight;
    [self changeThemeStyleWithKey:styleKey];
}

+ (void)changeThemeStyleWithKey:(NSString *)styleKey {
    [ThemeManager updateThemeStyle:styleKey];
    [self saveThemeStyleKey:styleKey];
}

static NSString *const StorageAppThemeStyleKey = @"storage.app.ThemeStyleKey";

+ (void)saveThemeStyleKey:(NSString *)styleKey {
    if (!styleKey) return;
    [[NSUserDefaults standardUserDefaults] setObject:styleKey forKey:StorageAppThemeStyleKey];
}

+ (NSString *)getThemeStyleKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:StorageAppThemeStyleKey];
}

@end
