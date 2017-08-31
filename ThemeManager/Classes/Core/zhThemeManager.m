//
//  zhThemeManager.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeManager.h"
#import "zhThemeFiles.h"
#import <objc/runtime.h>

NSNotificationName const zhThemeUpdateNotification = @"com.zh.theme.update.notification";
NSString *const zhThemeStorageStyleKey = @"zhTheme_storageCurrentStyleKey";

@implementation zhThemeManager

+ (instancetype)sharedManager {
    static zhThemeManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeManager alloc] init];
        instance.changeThemeColorAnimationDuration = 0.25;
    });
    return instance;
}

- (void)reloadTheme {
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (BOOL)isCurrentThemeEqual:(zhThemeStyleName)themeStyle {
    return [self.currentStyle isEqualToString:themeStyle];
}

- (void)updateThemeStyle:(zhThemeStyleName)style {
    if (!style || [self isCurrentThemeEqual:style]) return;
    [[NSUserDefaults standardUserDefaults] setObject:style forKey:zhThemeStorageStyleKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (zhThemeStyleName)currentStyle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *themeStyle = [userDefaults stringForKey:zhThemeStorageStyleKey];
    if (themeStyle) {
        return themeStyle;
    }
    return self.defaultStyle;;
}

@end

@implementation zhThemeManager (Files)

- (NSString *)defaultColorFile {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDefaultColorFile:(NSString *)defaultColorFile {
    objc_setAssociatedObject(self, @selector(defaultColorFile), defaultColorFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)defaultImageFile {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDefaultImageFile:(NSString *)defaultImageFile {
    objc_setAssociatedObject(self, @selector(defaultImageFile), defaultImageFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateThemeColorFile:(NSString *)newColorFile {
    [zhThemeFiles.defaultManager setValue:newColorFile forKey:@"colorFile"];
    [self reloadTheme];
}

- (void)updateThemeImageFile:(NSString *)newImageFile {
    [zhThemeFiles.defaultManager setValue:newImageFile forKey:@"imageFile"];
    [self reloadTheme];
}

- (void)setThemeImageResources:(NSString *)resourcesPath {
    [zhThemeFiles.defaultManager setValue:resourcesPath forKey:@"imageResourcesPath"];
}

@end
