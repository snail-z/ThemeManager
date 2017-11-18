//
//  zhThemeManager.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ThemeManager [zhThemeManager sharedManager]

typedef NSString *zhThemeStyleName NS_EXTENSIBLE_STRING_ENUM;

UIKIT_EXTERN NSNotificationName const zhThemeUpdateNotification; // Theme styles change of notification.

@interface zhThemeManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSDictionary *> *colorLibraries;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSDictionary *> *imageLibraries;
@property (nonatomic, strong, readonly) id imageSources;  // path or bundle

+ (instancetype)sharedManager;

/// The transition duration when theme background colors change. default is 0.25s
@property (nonatomic, assign) NSTimeInterval themeColorChangeInterval;

/// Default NO, log by NSLog.
@property (nonatomic, assign) BOOL debugLogEnabled;

/// Debug log controlled by "debugLogEnabled".
- (void)debugLog:(nullable NSString *)description, ...;

/// Reload Theme (will post `zhThemeUpdateNotification`)
- (void)reloadTheme;

/// Whether the same with theme current style.
- (BOOL)isEqualCurrentThemeStyle:(zhThemeStyleName)themeStyle;

/// Current theme style.
@property (nonatomic, strong, readonly) zhThemeStyleName currentStyle;

/// Set theme default style.
- (void)setDefaultThemeStyle:(zhThemeStyleName)defaultStyle; // You can customize your theme style name. change it to change the global theme, this will post `zhThemeUpdateNotification`, you can observe this notification to customize your theme. (your config file or dictionary the key, must keep the same with it.)

/// If set it. next start your app. will use `style`. default style will not be used.
- (void)updateThemeStyle:(zhThemeStyleName)style;

/// The file type support `json` and `plist`. (must set full path) ☟

/// Set theme default color file.
- (void)setDefaultThemeColorFile:(NSString *)defaultColorFile;

/// If set it. next start your app. will use `newColorFile`. default color file will not be used.
- (void)updateThemeColorFile:(nullable NSString *)newColorFile;

/// Set theme default image file.
- (void)setDefaultThemeImageFile:(NSString *)defaultImageFile;

/// If set it. next start your app. will use `newImageFile`. default image file will not be used.
- (void)updateThemeImageFile:(nullable NSString *)newImageFile;

/// If set it, will get resource images from this directory. if set nil, get resource images from your app.
- (void)setThemeImageResources:(nullable NSString *)resourcesPath; // support reads from your custom bundle. automatic check @2x/@3x images.

@end

NS_ASSUME_NONNULL_END
