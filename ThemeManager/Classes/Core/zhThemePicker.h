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

typedef NS_ENUM(NSInteger, zhThemeValueType) {
    zhThemeValueTypeColor = 0,
    zhThemeValueTypeImage,
    zhThemeValueTypeFont,
    zhThemeValueTypeText,
    zhThemeValueTypeNumber
};

@interface zhThemePicker : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, assign, readonly) zhThemeValueType valueType;

+ (instancetype)pickerWithKey:(NSString *)pKey;
+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict;

@end

#define ThemeColorPickerWithKey(key) [zhThemeColorPicker pickerWithKey:key]
#define ThemeColorPickerWithDictionary(dict) [zhThemeColorPicker pickerWithDictionary:dict]

@interface zhThemeColorPicker : zhThemePicker

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemeColorPicker *(^)(BOOL isAnimated))animated;

@property (nonatomic, assign, readonly) BOOL isAnimated;

- (nullable UIColor *)color; // The color value in the current theme style.

@end

#define ThemeImagePickerWithKey(key) [zhThemeImagePicker pickerWithKey:key]
#define ThemeImagePickerWithDictionary(dict) [zhThemeImagePicker pickerWithDictionary:dict]

@interface zhThemeImagePicker : zhThemePicker

/// Used to set the UIImage renderingMode
- (zhThemeImagePicker *(^)(UIImageRenderingMode imageRenderingMode))renderingMode;

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemeImagePicker *(^)(UIEdgeInsets imageCapInsets))resizableCapInsets;

@property (nonatomic, assign, readonly) UIImageRenderingMode imageRenderingMode;
@property (nonatomic, assign, readonly) UIEdgeInsets imageCapInsets;

- (nullable UIImage *)image; // The color value in the current theme style.

@end

#define ThemeFontPickerWithDictionary(dict) [zhThemeFontPicker pickerWithDictionary:dict]

@interface zhThemeFontPicker : zhThemePicker

- (nullable UIFont *)font; // The font value in the current theme style.

@end

#define ThemeTextPickerWithDictionary(dict) [zhThemeTextPicker pickerWithDictionary:dict]

@interface zhThemeTextPicker : zhThemePicker

- (nullable NSString *)text; // The text value in the current theme style.

@end

#define ThemeNumberPickerWithDictionary(dict) [zhThemeNumberPicker pickerWithDictionary:dict]

@interface zhThemeNumberPicker : zhThemePicker // CGFloat / NSInteger

- (NSNumber *)number; // The alpha / borderWidth /... value in the current theme style.

@end

NS_ASSUME_NONNULL_END
