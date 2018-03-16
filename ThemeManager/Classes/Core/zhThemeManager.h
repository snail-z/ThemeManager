//
//  zhThemeManager.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *zhThemeStyleName NS_EXTENSIBLE_STRING_ENUM;

@interface zhThemeDefaultConfiguration : NSObject

@property (nonatomic, strong) NSString *colorFilePath;
@property (nonatomic, strong) NSString *imageFilePath;
@property (nonatomic, strong) zhThemeStyleName style;

@end

@interface zhThemeManager : NSObject

@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, NSDictionary *> *colorLibraries;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, NSDictionary *> *imageLibraries;
@property (nonatomic, strong, readonly, nullable) id pathOfImageSources;  

@property (nonatomic, strong, readonly) zhThemeStyleName currentStyle; // Current theme style.

+ (instancetype)sharedManager;

- (BOOL)isEqualCurrentStyle:(zhThemeStyleName)style;

/// Default NO, log by NSLog.
@property (nonatomic, assign) BOOL debugLogEnabled;

/// Debug log controlled by "debugLogEnabled".
- (void)debugLog:(nullable NSString *)description, ...;

/// The transition duration when theme background colors change. default is 0.25s
@property (nonatomic, assign) NSTimeInterval themeColorChangeInterval;

// Set the default configuration for your theme. When the updated file is invalid, will be used it.
@property (nonatomic, strong) zhThemeDefaultConfiguration *defaultConfiguration;

// If set it. next start your app. will use `style`. default configuration `style` will not be used.
- (void)updateThemeStyle:(zhThemeStyleName)style; // You can customize your theme style name. change it will change the overall theme, this will post `zhThemeUpdateNotification`, you can observe this notification to customize your theme. (your config file name, must keep the same with it.)

// Update your theme color file path.
- (void)updateThemeColorFilePath:(NSString *)path; // If set it. default configuration `colorFilePath` will not be used.

// Update your theme image file path.
- (void)updateThemeImageFilePath:(NSString *)path; // If set it. default configuration `imageFilePath` will not be used.

// If set it, will get resource images from this directory. if set nil, get resource images from your app.
- (void)setThemeImageResourcesPath:(NSString *)path; // support reads from your custom bundle. automatic check @2x/@3x images.

/// Reload Theme (will post `zhThemeUpdateNotification`)
- (void)reloadTheme;

@end

#define ThemeManager [zhThemeManager sharedManager]

UIKIT_EXTERN NSNotificationName const zhThemeUpdateNotification; // Theme styles change of notification.

NS_ASSUME_NONNULL_END
