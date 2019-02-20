//
//  zhThemePicker.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface zhThemePicker : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

// The following two methods should be handed to the subclass call.
+ (instancetype)pickerWithKey:(NSString *)pKey;
+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict;

@end

#define ThemePickerColorKey(key) [zhThemeColorPicker pickerWithKey:key]
#define ThemePickerColorSets(dict) [zhThemeColorPicker pickerWithDictionary:dict]

@interface zhThemeColorPicker : zhThemePicker

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemeColorPicker *(^)(BOOL isAnimated))animated;

@property (nonatomic, assign, readonly) BOOL isAnimated;

- (nullable UIColor *)color; // The color value in the current theme style.

@end

#define ThemePickerImageKey(key) [zhThemeImagePicker pickerWithKey:key]
#define ThemePickerImageSets(dict) [zhThemeImagePicker pickerWithDictionary:dict]

@interface zhThemeImagePicker : zhThemePicker

// Used to set whether to enable UIImage cache. default is NO.
- (zhThemeImagePicker *(^)(BOOL imageCacheEnabled))cacheEnabled;

/// Used to set the UIImage renderingMode
- (zhThemeImagePicker *(^)(UIImageRenderingMode imageRenderingMode))renderingMode;

/// Used to set the UIImage imageCapInsets
- (zhThemeImagePicker *(^)(UIEdgeInsets imageCapInsets))resizableCapInsets;

@property (nonatomic, assign, readonly) BOOL imageCacheEnabled;
@property (nonatomic, assign, readonly) UIImageRenderingMode imageRenderingMode;
@property (nonatomic, assign, readonly) UIEdgeInsets imageCapInsets;

- (nullable UIImage *)image; // The color value in the current theme style.

@end

#define ThemePickerFontSets(dict) [zhThemeFontPicker pickerWithDictionary:dict]

@interface zhThemeFontPicker : zhThemePicker

- (nullable UIFont *)font; // The font value in the current theme style.

@end

#define ThemePickerTextSets(dict) [zhThemeTextPicker pickerWithDictionary:dict]

@interface zhThemeTextPicker : zhThemePicker

- (nullable NSString *)text; // The text value in the current theme style.

@end

#define ThemePickerNumberSets(dict) [zhThemeNumberPicker pickerWithDictionary:dict]

@interface zhThemeNumberPicker : zhThemePicker // CGFloat / NSInteger ...

- (nullable NSNumber *)number; // The alpha / borderWidth /... value in the current theme style.

@end

NS_ASSUME_NONNULL_END
