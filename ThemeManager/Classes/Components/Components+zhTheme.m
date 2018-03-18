//
//  Components+zhTheme.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "Components+zhTheme.h"
#import "zhThemeUtilities.h"

#define PROPERTYPICKER_IMPL(PROPERTY) \
- (zhThemePicker *)zh_ ## PROPERTY ## Picker { \
return zh_getThemePicker(self, @selector(zh_ ## PROPERTY ## Picker)); \
} \
- (void)setZh_ ## PROPERTY ## Picker:(zhThemePicker *)zh_ ## PROPERTY ## Picker { \
zh_setThemePicker(zh_ ## PROPERTY ## Picker, self, (@#PROPERTY)); \
}

/////////////////////////////// UIKit+zhTheme ///////////////////////////////

@implementation UIView (zhTheme)

PROPERTYPICKER_IMPL(backgroundColor)
PROPERTYPICKER_IMPL(tintColor)
PROPERTYPICKER_IMPL(alpha)

@end

@implementation UILabel (zhTheme)

PROPERTYPICKER_IMPL(font)
PROPERTYPICKER_IMPL(textColor)
PROPERTYPICKER_IMPL(highlightedTextColor)
PROPERTYPICKER_IMPL(shadowColor)

@end

@implementation UIButton (zhTheme)

- (void)zh_setTitleColorPicker:(zhThemeColorPicker *)picker forState:(UIControlState)state {
    zh_setThemePickerWithState(self, @selector(setTitleColor:forState:), picker, state);
}

- (void)zh_setImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state {
    zh_setThemePickerWithState(self, @selector(setImage:forState:), picker, state);
}

- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state {
    zh_setThemePickerWithState(self, @selector(setBackgroundImage:forState:), picker, state);
}

- (void)zh_setBackgroundColorPicker:(zhThemeColorPicker *)picker forState:(UIControlState)state {
    zh_setThemePickerWithState(self, @selector(_set_zhThemeBackgroundColor:forState:), picker, state);
}

- (void)_set_zhThemeBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:zh_themeImageFromColor(backgroundColor) forState:state];
}

@end

@implementation UIImageView (zhTheme)

PROPERTYPICKER_IMPL(image)
PROPERTYPICKER_IMPL(highlightedImage)

- (instancetype)zh_initWithImagePicker:(zhThemeImagePicker *)picker {
    UIImageView *imageView = [self init];
    imageView.zh_imagePicker = picker;
    return imageView;
}

- (instancetype)zh_initWithImagePicker:(zhThemeImagePicker *)picker highlightedImagePicker:(zhThemeImagePicker *)highlightedPicker {
    UIImageView *imageView = [self init];
    imageView.zh_imagePicker = picker;
    imageView.zh_highlightedImagePicker = highlightedPicker;
    return imageView;
}

@end

@implementation UITableView (zhTheme)

PROPERTYPICKER_IMPL(separatorColor)

@end

@implementation UIPageControl (zhTheme)

PROPERTYPICKER_IMPL(pageIndicatorTintColor)
PROPERTYPICKER_IMPL(currentPageIndicatorTintColor)

@end

@implementation UIProgressView (zhTheme)

PROPERTYPICKER_IMPL(progressTintColor)
PROPERTYPICKER_IMPL(trackTintColor)
PROPERTYPICKER_IMPL(progressImage)
PROPERTYPICKER_IMPL(trackImage)

@end

@implementation UITextField (zhTheme)

PROPERTYPICKER_IMPL(font)
PROPERTYPICKER_IMPL(textColor)

- (zhThemeColorPicker *)zh_placeholderTextColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_placeholderTextColorPicker:(zhThemeColorPicker *)zh_placeholderTextColorPicker {
    zh_setThemePicker(zh_placeholderTextColorPicker, self, @"_placeholderLabel.textColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UITextView (zhTheme)

PROPERTYPICKER_IMPL(font)
PROPERTYPICKER_IMPL(textColor)

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}


@end

@implementation UISearchBar (zhTheme)

PROPERTYPICKER_IMPL(barTintColor)

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UIToolbar (zhTheme)

PROPERTYPICKER_IMPL(barTintColor)

@end

@implementation UITabBar (zhTheme)

PROPERTYPICKER_IMPL(barTintColor)
PROPERTYPICKER_IMPL(backgroundImage)
PROPERTYPICKER_IMPL(shadowImage)
PROPERTYPICKER_IMPL(selectionIndicatorImage)

@end

@implementation UIBarItem (zhTheme)

PROPERTYPICKER_IMPL(image)

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    zh_setThemeTextAttributesWithState(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end

@implementation UIBarButtonItem (zhTheme)

PROPERTYPICKER_IMPL(tintColor)

@end

@implementation UITabBarItem (zhTheme)

PROPERTYPICKER_IMPL(selectedImage)
PROPERTYPICKER_IMPL(badgeColor)

@end

@implementation UINavigationBar (zhTheme)

PROPERTYPICKER_IMPL(barTintColor)
PROPERTYPICKER_IMPL(shadowImage)
PROPERTYPICKER_IMPL(backIndicatorImage)
PROPERTYPICKER_IMPL(backIndicatorTransitionMaskImage)

- (void)zh_setBackgroundColorPicker:(zhThemeImagePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics {
    zh_setThemePickerWithState(self, @selector(_set_zhThemeBackgroundColor:forBarMetrics:), picker, barMetrics);
}

- (void)_set_zhThemeBackgroundColor:(UIColor *)backgroundColor forBarMetrics:(UIBarMetrics)barMetrics {
    [self setBackgroundImage:zh_themeImageFromColor(backgroundColor) forBarMetrics:barMetrics];
}

- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics {
    zh_setThemePickerWithState(self, @selector(setBackgroundImage:forBarMetrics:), picker, barMetrics);
}

- (void)zh_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    zh_setThemeTextAttributes(self, @selector(setTitleTextAttributes:), titleTextAttributes);
}

@end

@implementation UIApplication (zhTheme)

- (void)zh_setStatusBarStyle:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setStatusBarStyle:), dict);
}

@end

@implementation UISegmentedControl (zhTheme)

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    zh_setThemeTextAttributesWithState(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end

/////////////////////////////// QuartzCore+zhTheme ///////////////////////////////

@implementation CALayer (zhTheme)

PROPERTYPICKER_IMPL(backgroundColor)
PROPERTYPICKER_IMPL(borderColor)
PROPERTYPICKER_IMPL(shadowColor)
PROPERTYPICKER_IMPL(borderWidth)

@end

@implementation CAShapeLayer (zhTheme)

PROPERTYPICKER_IMPL(fillColor)
PROPERTYPICKER_IMPL(strokeColor)

@end
