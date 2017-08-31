//
//  UIKit+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIKit+zhTheme.h"
#import "NSObject+zhTheme.h"

@implementation UIView (zhTheme)

- (zhThemePicker *)zh_backgroundColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_backgroundColorPicker:(zhThemePicker *)zh_backgroundColorPicker {
    setThemePicker(zh_backgroundColorPicker, self, @"backgroundColor");
}

- (zhThemePicker *)zh_tintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_tintColorPicker:(zhThemePicker *)zh_tintColorPicker {
    setThemePicker(zh_tintColorPicker, self, @"tintColor");
}

- (zhThemePicker *)zh_alphaPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_alphaPicker:(zhThemePicker *)zh_alphaPicker {
    setThemePicker(zh_alphaPicker, self, @"alpha");
}

@end

@implementation UILabel (zhTheme)

- (zhThemePicker *)zh_fontPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemePicker *)zh_fontPicker {
    setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemePicker *)zh_textColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemePicker *)zh_textColorPicker {
    setThemePicker(zh_textColorPicker, self, @"textColor");
}

- (zhThemePicker *)zh_shadowColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_shadowColorPicker:(zhThemePicker *)zh_shadowColorPicker {
    setThemePicker(zh_shadowColorPicker, self, @"shadowColor");
}

- (zhThemePicker *)zh_highlightedTextColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_highlightedTextColorPicker:(zhThemePicker *)zh_highlightedTextColorPicker {
    setThemePicker(zh_highlightedTextColorPicker, self, @"highlightedTextColor");
}

@end

@implementation UIButton (zhTheme)

- (void)zh_setTitleColorPicker:(zhThemePicker *)picker forState:(UIControlState)state {
    makeThemeStatePicker(picker, self, @selector(setTitleColor:forState:), state);
}

- (void)zh_setImagePicker:(zhThemePicker *)picker forState:(UIControlState)state {
    makeThemeStatePicker(picker, self, @selector(setImage:forState:), state);
}

- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forState:(UIControlState)state {
    makeThemeStatePicker(picker, self, @selector(setBackgroundImage:forState:), state);
}

@end

@implementation UIImageView (zhTheme)

- (zhThemePicker *)zh_imagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_imagePicker:(zhThemePicker *)zh_imagePicker {
    setThemePicker(zh_imagePicker, self, @"image");
}

- (zhThemePicker *)zh_highlightedImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_highlightedImagePicker:(zhThemePicker *)zh_highlightedImagePicker {
    setThemePicker(zh_highlightedImagePicker, self, @"highlightedImage");
}

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

- (zhThemePicker *)zh_separatorColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_separatorColorPicker:(zhThemePicker *)zh_separatorColorPicker {
    setThemePicker(zh_separatorColorPicker, self, @"separatorColor");
}

@end

@implementation UIPageControl (zhTheme)

- (zhThemePicker *)zh_pageIndicatorTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_pageIndicatorTintColorPicker:(zhThemePicker *)zh_pageIndicatorTintColorPicker {
    setThemePicker(zh_pageIndicatorTintColorPicker, self, @"pageIndicatorTintColor");
}

- (zhThemePicker *)zh_currentPageIndicatorTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_currentPageIndicatorTintColorPicker:(zhThemePicker *)zh_currentPageIndicatorTintColorPicker {
    setThemePicker(zh_currentPageIndicatorTintColorPicker, self, @"currentPageIndicatorTintColor");
}

@end

@implementation UIProgressView (zhTheme)

- (zhThemePicker *)zh_progressTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_progressTintColorPicker:(zhThemePicker *)zh_progressTintColorPicker {
    setThemePicker(zh_progressTintColorPicker, self, @"progressTintColor");
}

- (zhThemePicker *)zh_trackTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_trackTintColorPicker:(zhThemePicker *)zh_trackTintColorPicker {
    setThemePicker(zh_trackTintColorPicker, self, @"trackTintColor");
}

- (zhThemePicker *)zh_progressImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_progressImagePicker:(zhThemePicker *)zh_progressImagePicker {
    setThemePicker(zh_progressImagePicker, self, @"progressImage");
}

- (zhThemePicker *)zh_trackImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_trackImagePicker:(zhThemePicker *)zh_trackImagePicker {
    setThemePicker(zh_trackImagePicker, self, @"trackImage");
}

@end

@implementation UITextField (zhTheme)

- (zhThemePicker *)zh_fontPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemePicker *)zh_fontPicker {
    setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemePicker *)zh_textColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemePicker *)zh_textColorPicker {
    setThemePicker(zh_textColorPicker, self, @"textColor");
}

- (zhThemePicker *)zh_placeholderTextColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_placeholderTextColorPicker:(zhThemePicker *)zh_placeholderTextColorPicker {
    setThemePicker(zh_placeholderTextColorPicker, self, @"_placeholderLabel.textColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    makeThemeEnumDictionary(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UITextView (zhTheme)

- (zhThemePicker *)zh_fontPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemePicker *)zh_fontPicker {
    setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemePicker *)zh_textColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemePicker *)zh_textColorPicker {
    setThemePicker(zh_textColorPicker, self, @"textColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    makeThemeEnumDictionary(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UISearchBar (zhTheme)

- (zhThemePicker *)zh_barTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemePicker *)zh_barTintColorPicker {
    setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    makeThemeEnumDictionary(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UIToolbar (zhTheme)

- (zhThemePicker *)zh_barTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemePicker *)zh_barTintColorPicker {
    setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

@end

@implementation UITabBar (zhTheme)

- (zhThemePicker *)zh_barTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemePicker *)zh_barTintColorPicker {
    setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (zhThemePicker *)zh_backgroundImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_backgroundImagePicker:(zhThemePicker *)zh_backgroundImagePicker {
    setThemePicker(zh_backgroundImagePicker, self, @"backgroundImage");
}

- (zhThemePicker *)zh_shadowImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_shadowImagePicker:(zhThemePicker *)zh_shadowImagePicker {
    setThemePicker(zh_shadowImagePicker, self, @"shadowImage");
}

- (zhThemePicker *)zh_selectionIndicatorImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_selectionIndicatorImagePicker:(zhThemePicker *)zh_selectionIndicatorImagePicker {
    setThemePicker(zh_selectionIndicatorImagePicker, self, @"selectionIndicatorImage");
}

@end

@implementation UIBarItem (zhTheme)

- (zhThemePicker *)zh_imagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_imagePicker:(zhThemePicker *)zh_imagePicker {
    setThemePicker(zh_imagePicker, self, @"image");
}

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    makeThemeStateAttributes(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end

@implementation UIBarButtonItem (zhTheme)

- (zhThemePicker *)zh_tintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_tintColorPicker:(zhThemePicker *)zh_tintColorPicker {
    setThemePicker(zh_tintColorPicker, self, @"tintColor");
}

@end

@implementation UITabBarItem (zhTheme)

- (zhThemePicker *)zh_selectedImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_selectedImagePicker:(zhThemePicker *)zh_selectedImagePicker {
    setThemePicker(zh_selectedImagePicker, self, @"selectedImage");
}

- (zhThemePicker *)zh_badgeColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_badgeColorPicker:(zhThemePicker *)zh_badgeColorPicker {
    setThemePicker(zh_badgeColorPicker, self, @"badgeColor");
}

@end

@implementation UINavigationBar (zhTheme)

- (zhThemePicker *)zh_barTintColorPicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemePicker *)zh_barTintColorPicker {
    setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (zhThemePicker *)zh_shadowImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_shadowImagePicker:(zhThemePicker *)zh_shadowImagePicker {
    setThemePicker(zh_shadowImagePicker, self, @"shadowImage");
}

- (zhThemePicker *)zh_backIndicatorImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_backIndicatorImagePicker:(zhThemePicker *)zh_backIndicatorImagePicker {
    setThemePicker(zh_backIndicatorImagePicker, self, @"backIndicatorImage");
}

- (zhThemePicker *)zh_backIndicatorTransitionMaskImagePicker {
    return getThemePicker(self, _cmd);
}

- (void)setZh_backIndicatorTransitionMaskImagePicker:(zhThemePicker *)zh_backIndicatorTransitionMaskImagePicker {
    setThemePicker(zh_backIndicatorTransitionMaskImagePicker, self, @"backIndicatorTransitionMaskImage");
}

- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics {
    makeThemeStatePicker(picker, self, @selector(setBackgroundImage:forBarMetrics:), barMetrics);
}

- (void)zh_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    makeThemeAttributes(self, @selector(setTitleTextAttributes:), titleTextAttributes);
}

@end

@implementation UIApplication (zhTheme)

- (void)zh_setStatusBarStyle:(NSDictionary<NSString *,NSNumber *> *)dict {
    makeThemeEnumDictionary(self, @selector(setStatusBarStyle:), dict);
}

@end
