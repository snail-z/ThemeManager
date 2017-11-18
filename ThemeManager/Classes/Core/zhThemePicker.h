//
//  zhThemeImagePicker.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhThemeManager.h"

typedef NS_ENUM(NSInteger, zhThemeValueType) {
    zhThemeValueTypeColor = 0,
    zhThemeValueTypeImage,
    zhThemeValueTypeFont,
    zhThemeValueTypeNumber,
    zhThemeValueTypeText
};

@interface zhThemePicker : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, assign, readonly) zhThemeValueType valueType;

@end

#define TMColorWithKey(key) [zhThemeColorPicker pickerColorWithKey:key]
#define TMColorWithDict(dict) [zhThemeColorPicker pickerColorWithDict:dict]

@interface zhThemeColorPicker : zhThemePicker

+ (instancetype)pickerColorWithKey:(NSString *)pKey;
+ (instancetype)pickerColorWithDict:(NSDictionary *)pDict;

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemeColorPicker *(^)(BOOL isAnimated))animated;

@property (nonatomic, assign, readonly) BOOL isAnimated;

- (UIColor *)color; // The color value in the current theme style.

@end

#define TMImageWithKey(key) [zhThemeImagePicker pickerImageWithKey:key]
#define TMImageWithDict(dict) [zhThemeImagePicker pickerImageWithDict:dict]

@interface zhThemeImagePicker : zhThemePicker

+ (instancetype)pickerImageWithKey:(NSString *)pKey;
+ (instancetype)pickerImageWithDict:(NSDictionary *)pDict;

/// Used to set the UIImage renderingMode
- (zhThemeImagePicker *(^)(UIImageRenderingMode imageRenderingMode))renderingMode;

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemeImagePicker *(^)(UIEdgeInsets imageCapInsets))resizableCapInsets;

@property (nonatomic, assign, readonly) UIImageRenderingMode imageRenderingMode;
@property (nonatomic, assign, readonly) UIEdgeInsets imageCapInsets;

- (UIImage *)image; // The color value in the current theme style.

@end

#define TMFontWithDict(dict) [zhThemeFontPicker pickerFontWithDict:dict]

@interface zhThemeFontPicker : zhThemePicker

+ (instancetype)pickerFontWithDict:(NSDictionary *)pDict;

- (UIFont *)font; // The font value in the current theme style.

@end

#define TMNumberWithDict(dict) [zhThemeNumberPicker pickerNumberWithDict:dict]

@interface zhThemeNumberPicker : zhThemePicker // CGFloat / NSInteger

+ (instancetype)pickerNumberWithDict:(NSDictionary *)pDict;

- (NSNumber *)number; // The alpha / borderWidth /... value in the current theme style.

@end

#define TMTextWithDict(dict) [zhThemeTextPicker pickerTextWithDict:dict]

@interface zhThemeTextPicker : zhThemePicker

+ (instancetype)pickerTextWithDict:(NSDictionary *)pDict;

- (NSString *)text; // The text value in the current theme style.

@end
