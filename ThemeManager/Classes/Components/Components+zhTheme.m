//
//  UIKit+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "Components+zhTheme.h"
#import "NSObject+zhTheme.h"
#import <objc/runtime.h>

#define ZH_PICKER_PROPERTYIMPL(PROPERTY) \
- (zhThemePicker *)zh_ ## PROPERTY ## Picker { \
return zh_getThemePicker(self, @selector(zh_ ## PROPERTY ## Picker)); \
}\
- (void)setZh_ ## PROPERTY ## Picker:(zhThemePicker *)zh_ ## PROPERTY ## Picker { \
zh_setThemePicker(zh_ ## PROPERTY ## Picker, self, (@#PROPERTY)); \
}

/////////////////////////////// UIKit+zhTheme ///////////////////////////////

@implementation UIView (zhTheme)

ZH_PICKER_PROPERTYIMPL(backgroundColor);
ZH_PICKER_PROPERTYIMPL(tintColor)
ZH_PICKER_PROPERTYIMPL(alpha)

@end

@implementation UILabel (zhTheme)

ZH_PICKER_PROPERTYIMPL(font)
ZH_PICKER_PROPERTYIMPL(textColor)
ZH_PICKER_PROPERTYIMPL(shadowColor)
ZH_PICKER_PROPERTYIMPL(highlightedTextColor)

@end

@implementation UIButton (zhTheme)

- (void)zh_setTitleColorPicker:(zhThemePicker *)picker forState:(UIControlState)state {
    zh_makeThemeStatePicker(self, @selector(setTitleColor:forState:), picker, state);
}

- (void)zh_setImagePicker:(zhThemePicker *)picker forState:(UIControlState)state {
    zh_makeThemeStatePicker(self, @selector(setImage:forState:), picker, state);
}

- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forState:(UIControlState)state {
    zh_makeThemeStatePicker(self, @selector(setBackgroundImage:forState:), picker, state);
}

@end

@implementation UIImageView (zhTheme)

ZH_PICKER_PROPERTYIMPL(image)
ZH_PICKER_PROPERTYIMPL(highlightedImage)

- (instancetype)zh_initWithImagePicker:(zhThemePicker *)picker {
    UIImageView *imageView = [self init];
    imageView.zh_imagePicker = picker;
    return imageView;
}

- (instancetype)zh_initWithImagePicker:(zhThemePicker *)picker highlightedImagePicker:(zhThemePicker *)highlightedPicker {
    UIImageView *imageView = [self init];
    imageView.zh_imagePicker = picker;
    imageView.zh_highlightedImagePicker = highlightedPicker;
    return imageView;
}

@end

@implementation UITableView (zhTheme)

ZH_PICKER_PROPERTYIMPL(separatorColor)

@end

@implementation UIPageControl (zhTheme)

ZH_PICKER_PROPERTYIMPL(pageIndicatorTintColor)
ZH_PICKER_PROPERTYIMPL(currentPageIndicatorTintColor)

@end

@implementation UIProgressView (zhTheme)

ZH_PICKER_PROPERTYIMPL(progressTintColor)
ZH_PICKER_PROPERTYIMPL(trackTintColor)
ZH_PICKER_PROPERTYIMPL(progressImage)
ZH_PICKER_PROPERTYIMPL(trackImage)

@end

@implementation UITextField (zhTheme)

ZH_PICKER_PROPERTYIMPL(font)
ZH_PICKER_PROPERTYIMPL(textColor)

- (zhThemePicker *)zh_placeholderTextColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_placeholderTextColorPicker:(zhThemePicker *)zh_placeholderTextColorPicker {
    zh_setThemePicker(zh_placeholderTextColorPicker, self, @"_placeholderLabel.textColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_makeThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UITextView (zhTheme)

ZH_PICKER_PROPERTYIMPL(font)
ZH_PICKER_PROPERTYIMPL(textColor)

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_makeThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UISearchBar (zhTheme)

ZH_PICKER_PROPERTYIMPL(barTintColor)

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_makeThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UIToolbar (zhTheme)

ZH_PICKER_PROPERTYIMPL(barTintColor)

@end

@implementation UITabBar (zhTheme)

ZH_PICKER_PROPERTYIMPL(barTintColor)
ZH_PICKER_PROPERTYIMPL(backgroundImage)
ZH_PICKER_PROPERTYIMPL(shadowImage)
ZH_PICKER_PROPERTYIMPL(selectionIndicatorImage)

@end

@implementation UIBarItem (zhTheme)

ZH_PICKER_PROPERTYIMPL(image)

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    zh_makeThemeStateTextAttributes(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end

@implementation UIBarButtonItem (zhTheme)

ZH_PICKER_PROPERTYIMPL(tintColor)

@end

@implementation UITabBarItem (zhTheme)

ZH_PICKER_PROPERTYIMPL(selectedImage)
ZH_PICKER_PROPERTYIMPL(badgeColor)

@end

@implementation UINavigationBar (zhTheme)

ZH_PICKER_PROPERTYIMPL(barTintColor)
ZH_PICKER_PROPERTYIMPL(shadowImage)
ZH_PICKER_PROPERTYIMPL(backIndicatorImage)
ZH_PICKER_PROPERTYIMPL(backIndicatorTransitionMaskImage)

- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics {
    zh_makeThemeStatePicker(self, @selector(setBackgroundImage:forBarMetrics:), picker, barMetrics);
}

- (void)zh_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    zh_makeThemeTextAttributes(self, @selector(setTitleTextAttributes:), titleTextAttributes);
}

@end

@implementation UIApplication (zhTheme)

- (void)zh_setStatusBarStyle:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_makeThemeEnumerations(self, @selector(setStatusBarStyle:), dict);
}

@end

/////////////////////////////// QuartzCore+zhTheme ///////////////////////////////

@implementation CALayer (zhTheme)

ZH_PICKER_PROPERTYIMPL(backgroundColor)
ZH_PICKER_PROPERTYIMPL(borderColor)
ZH_PICKER_PROPERTYIMPL(shadowColor)
ZH_PICKER_PROPERTYIMPL(borderWidth)

@end

@implementation CAShapeLayer (zhTheme)

ZH_PICKER_PROPERTYIMPL(fillColor)
ZH_PICKER_PROPERTYIMPL(strokeColor)

@end
