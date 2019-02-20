//
//  zhThemeManager.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Theme styles change of notification.
UIKIT_EXTERN NSNotificationName const zhThemeUpdateNotification;

@interface zhThemeManager : NSObject

+ (instancetype)sharedManager;

/// Whether to enable debug logs . default is NO.
@property (nonatomic, assign) BOOL debugLogEnabled;

/// The transition duration when theme background colors change. default is 0.25s
@property (nonatomic, assign) NSTimeInterval transitionInterval;

/// Set the image resource path. if set nil, will be loaded from the main bundle.
@property (nonatomic, strong, nullable) NSString *imageResourcePath;

/// Update the theme configuration file path.
@property (nonatomic, strong) NSString *themeInfoFilePath;

/// The key is the current theme style.
@property (nonatomic, strong, readonly, nullable) NSString *style;

/// You can customize your theme style name. changing it will change the whole theme, this will post `zhThemeUpdateNotification`. Your config file name, must keep the same with 'styleKey'.
- (void)updateThemeStyle:(NSString *)styleKey;

/// Clear all cache libraries.
- (void)clearAllLibraries;

/// Get configuration color/image table by theme style.
- (nullable NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *)librariesForKey:(NSString *)styleKey;

/// Get the style libraries path by the the theme style.
- (nullable NSString *)pathForKey:(NSString *)styleKey;

/// Get the color by aKey.
- (nullable UIColor *)colorForKey:(NSString *)aKey;

/// Get the cache color by aKey.
- (nullable UIColor *)cacheColorForKey:(NSString *)aKey;

/// Get the image by aKey.
- (nullable UIImage *)imageForKey:(NSString *)aKey;

/// Get the cache image by aKey.
- (nullable UIImage *)cacheImageForKey:(NSString *)aKey;

@end

#define ThemeManager [zhThemeManager sharedManager]

NS_ASSUME_NONNULL_END
