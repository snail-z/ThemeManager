//
//  zhThemePicker.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ThemePickerWithKey(key) [zhThemePicker pickerWithKey:key]
#define ThemePickerWithDict(dict) [zhThemePicker pickerWithDict:dict]

@interface zhThemePicker : NSObject

/// Through the `key` initialized.
+ (instancetype)pickerWithKey:(NSString *)pKey;

/// Through the `dictionary` initialized.
+ (instancetype)pickerWithDict:(NSDictionary *)pDict;

/// Used to set the UIImage renderingMode
- (zhThemePicker * (^)(UIImageRenderingMode renderingMode))imageRenderingMode;

/// default is NO. if YES, When color change there will be a transition animation.
- (zhThemePicker * (^)(BOOL animated))animated;

@end

@interface zhThemePicker (CurrentTheme )

/// The color value in the current theme style.
- (UIColor *)themeColor;

/// The image value in the current theme style.
- (UIImage *)themeImage;

/// The font value in the current theme style.
- (UIFont *)themeFont;

/// The alpha / borderWidth /... value in the current theme style.
- (NSNumber *)themeDouble;

@end
