//
//  zhThemeManager.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ThemeManager [zhThemeManager sharedManager]

typedef NSString *zhThemeStyleName NS_EXTENSIBLE_STRING_ENUM;

@interface zhThemeManager : NSObject

+ (instancetype)sharedManager;

- (void)reloadTheme;

- (BOOL)isCurrentThemeEqual:(zhThemeStyleName)themeStyle;

/// The transition duration when theme background colors change. default is 0.25s
@property (nonatomic, assign) NSTimeInterval changeThemeColorAnimationDuration;

/// Current theme style.
@property (nonatomic, strong, readonly) zhThemeStyleName currentStyle;

/// you can customize your theme style name. change it to change the global theme, this will post `zhThemeUpdateNotification`, you can observe this notification to customize your theme. (your config file or dictionary the key, must keep the same with it.)
@property (nonatomic, strong) NSString *defaultStyle;

/// If set it. next time start your app. will use `new Style`. default style will not be used.
- (void)updateThemeStyle:(zhThemeStyleName)style;

@end

@interface zhThemeManager (Files) // must set full path.

// The file type support `json` and `plist`. ☟
/// Set your theme color default file.
@property (nonnull, nonatomic, strong) NSString *defaultColorFile;
/// Set your theme image default file.
@property (nonnull, nonatomic, strong) NSString *defaultImageFile;

/// If set it. next time start your app. will use `newColorFile`. color starter file will not be used.
- (void)updateThemeColorFile:(nullable NSString *)newColorFile;
/// If set it. next time start your app. will use `newImageFile`. image starter file will not be used.
- (void)updateThemeImageFile:(nullable NSString *)newImageFile;

////////////////////// image resources //////////////////////
/// If set it, will get resource images from this directory. if set nil, get resource images from your app.
- (void)setThemeImageResources:(nullable NSString *)resourcesPath; // support reads from your custom bundle. automatic check @2x/@3x images.

@end

/// Theme styles change of notification.
UIKIT_EXTERN NSNotificationName const zhThemeUpdateNotification;

NS_ASSUME_NONNULL_END
