//
//  UIKit+zhTheme.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "Components+zhTheme.h"
#import "zhThemeUtilities.h"

/////////////////////////////// UIKit+zhTheme ///////////////////////////////

@implementation UIView (zhTheme)

- (zhThemeColorPicker *)zh_backgroundColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_backgroundColorPicker:(zhThemeColorPicker *)zh_backgroundColorPicker {
    zh_setThemePicker(zh_backgroundColorPicker, self, @"backgroundColor");
}

- (zhThemeColorPicker *)zh_tintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_tintColorPicker:(zhThemeColorPicker *)zh_tintColorPicker {
    zh_setThemePicker(zh_tintColorPicker, self, @"tintColor");
}

- (zhThemeNumberPicker *)zh_alphaPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_alphaPicker:(zhThemeNumberPicker *)zh_alphaPicker {
    zh_setThemePicker(zh_alphaPicker, self, @"alpha");
}

@end

@implementation UILabel (zhTheme)

- (zhThemeFontPicker *)zh_fontPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemeFontPicker *)zh_fontPicker {
    zh_setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemeColorPicker *)zh_textColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemeColorPicker *)zh_textColorPicker {
    zh_setThemePicker(zh_textColorPicker, self, @"textColor");
}

- (zhThemeColorPicker *)zh_shadowColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_shadowColorPicker:(zhThemeColorPicker *)zh_shadowColorPicker {
    zh_setThemePicker(zh_shadowColorPicker, self, @"shadowColor");
}

- (zhThemeColorPicker *)zh_highlightedTextColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_highlightedTextColorPicker:(zhThemeColorPicker *)zh_highlightedTextColorPicker {
    zh_setThemePicker(zh_highlightedTextColorPicker, self, @"highlightedTextColor");
}

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

- (zhThemeImagePicker *)zh_imagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_imagePicker:(zhThemeImagePicker *)zh_imagePicker {
    zh_setThemePicker(zh_imagePicker, self, @"image");
}

- (zhThemeImagePicker *)zh_highlightedImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_highlightedImagePicker:(zhThemeImagePicker *)zh_highlightedImagePicker {
    zh_setThemePicker(zh_highlightedImagePicker, self, @"highlightedImage");
}

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

- (zhThemeColorPicker *)zh_separatorColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_separatorColorPicker:(zhThemeColorPicker *)zh_separatorColorPicker {
    zh_setThemePicker(zh_separatorColorPicker, self, @"separatorColor");
}

@end

@implementation UIPageControl (zhTheme)

- (zhThemeColorPicker *)zh_pageIndicatorTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_pageIndicatorTintColorPicker:(zhThemeColorPicker *)zh_pageIndicatorTintColorPicker {
    zh_setThemePicker(zh_pageIndicatorTintColorPicker, self, @"pageIndicatorTintColor");
}

- (zhThemeColorPicker *)zh_currentPageIndicatorTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_currentPageIndicatorTintColorPicker:(zhThemeColorPicker *)zh_currentPageIndicatorTintColorPicker {
    zh_setThemePicker(zh_currentPageIndicatorTintColorPicker, self, @"currentPageIndicatorTintColor");
}

@end

@implementation UIProgressView (zhTheme)

- (zhThemeColorPicker *)zh_progressTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_progressTintColorPicker:(zhThemeColorPicker *)zh_progressTintColorPicker {
    zh_setThemePicker(zh_progressTintColorPicker, self, @"progressTintColor");
}

- (zhThemeColorPicker *)zh_trackTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_trackTintColorPicker:(zhThemeColorPicker *)zh_trackTintColorPicker {
    zh_setThemePicker(zh_trackTintColorPicker, self, @"trackTintColor");
}

- (zhThemeImagePicker *)zh_progressImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_progressImagePicker:(zhThemeImagePicker *)zh_progressImagePicker {
    zh_setThemePicker(zh_progressImagePicker, self, @"progressImage");
}

- (zhThemeImagePicker *)zh_trackImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_trackImagePicker:(zhThemeImagePicker *)zh_trackImagePicker {
    zh_setThemePicker(zh_trackImagePicker, self, @"trackImage");
}

@end

@implementation UITextField (zhTheme)

- (zhThemeFontPicker *)zh_fontPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemeFontPicker *)zh_fontPicker {
    zh_setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemeColorPicker *)zh_textColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemeColorPicker *)zh_textColorPicker {
    zh_setThemePicker(zh_textColorPicker, self, @"textColor");
}

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

- (zhThemeFontPicker *)zh_fontPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_fontPicker:(zhThemeFontPicker *)zh_fontPicker {
    zh_setThemePicker(zh_fontPicker, self, @"font");
}

- (zhThemeColorPicker *)zh_textColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_textColorPicker:(zhThemeColorPicker *)zh_textColorPicker {
    zh_setThemePicker(zh_textColorPicker, self, @"textColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UISearchBar (zhTheme)

- (zhThemeColorPicker *)zh_barTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemeColorPicker *)zh_barTintColorPicker {
    zh_setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (void)zh_setKeyboardAppearance:(NSDictionary<NSString *,NSNumber *> *)dict {
    zh_setThemeEnumerations(self, @selector(setKeyboardAppearance:), dict);
}

@end

@implementation UIToolbar (zhTheme)

- (zhThemeColorPicker *)zh_barTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemeColorPicker *)zh_barTintColorPicker {
    zh_setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

@end

@implementation UITabBar (zhTheme)

- (zhThemeColorPicker *)zh_barTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemeColorPicker *)zh_barTintColorPicker {
    zh_setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (zhThemeImagePicker *)zh_backgroundImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_backgroundImagePicker:(zhThemeImagePicker *)zh_backgroundImagePicker {
    zh_setThemePicker(zh_backgroundImagePicker, self, @"backgroundImage");
}

- (zhThemeImagePicker *)zh_shadowImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_shadowImagePicker:(zhThemeImagePicker *)zh_shadowImagePicker {
    zh_setThemePicker(zh_shadowImagePicker, self, @"shadowImage");
}

- (zhThemeImagePicker *)zh_selectionIndicatorImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_selectionIndicatorImagePicker:(zhThemeImagePicker *)zh_selectionIndicatorImagePicker {
    zh_setThemePicker(zh_selectionIndicatorImagePicker, self, @"selectionIndicatorImage");
}

@end

@implementation UIBarItem (zhTheme)

- (zhThemeImagePicker *)zh_imagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_imagePicker:(zhThemeImagePicker *)zh_imagePicker {
    zh_setThemePicker(zh_imagePicker, self, @"image");
}

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    zh_setThemeTextAttributesWithState(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end

@implementation UIBarButtonItem (zhTheme)

- (zhThemeColorPicker *)zh_tintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_tintColorPicker:(zhThemeColorPicker *)zh_tintColorPicker {
    zh_setThemePicker(zh_tintColorPicker, self, @"tintColor");
}

@end

@implementation UITabBarItem (zhTheme)

- (zhThemeImagePicker *)zh_selectedImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_selectedImagePicker:(zhThemeImagePicker *)zh_selectedImagePicker {
    zh_setThemePicker(zh_selectedImagePicker, self, @"selectedImage");
}

- (zhThemeColorPicker *)zh_badgeColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_badgeColorPicker:(zhThemeColorPicker *)zh_badgeColorPicker {
    zh_setThemePicker(zh_badgeColorPicker, self, @"badgeColor");
}

@end

@implementation UINavigationBar (zhTheme)

- (zhThemeColorPicker *)zh_barTintColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_barTintColorPicker:(zhThemeColorPicker *)zh_barTintColorPicker {
    zh_setThemePicker(zh_barTintColorPicker, self, @"barTintColor");
}

- (zhThemeImagePicker *)zh_shadowImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_shadowImagePicker:(zhThemeImagePicker *)zh_shadowImagePicker {
    zh_setThemePicker(zh_shadowImagePicker, self, @"shadowImage");
}

- (zhThemeImagePicker *)zh_backIndicatorImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_backIndicatorImagePicker:(zhThemeImagePicker *)zh_backIndicatorImagePicker {
    zh_setThemePicker(zh_backIndicatorImagePicker, self, @"backIndicatorImage");
}

- (zhThemeImagePicker *)zh_backIndicatorTransitionMaskImagePicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_backIndicatorTransitionMaskImagePicker:(zhThemeImagePicker *)zh_backIndicatorTransitionMaskImagePicker {
    zh_setThemePicker(zh_backIndicatorTransitionMaskImagePicker, self, @"backIndicatorTransitionMaskImage");
}

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

/////////////////////////////// QuartzCore+zhTheme ///////////////////////////////

@implementation CALayer (zhTheme)

- (zhThemeColorPicker *)zh_backgroundColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_backgroundColorPicker:(zhThemeColorPicker *)zh_backgroundColorPicker {
    zh_setThemePicker(zh_backgroundColorPicker, self, @"backgroundColor");
}

- (zhThemeColorPicker *)zh_borderColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_borderColorPicker:(zhThemeColorPicker *)zh_borderColorPicker {
    zh_setThemePicker(zh_borderColorPicker, self, @"borderColor");
}

- (zhThemeColorPicker *)zh_shadowColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_shadowColorPicker:(zhThemeColorPicker *)zh_shadowColorPicker {
    zh_setThemePicker(zh_shadowColorPicker, self, @"shadowColor");
}

- (zhThemeNumberPicker *)zh_borderWidthPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_borderWidthPicker:(zhThemeNumberPicker *)zh_borderWidthPicker {
    zh_setThemePicker(zh_borderWidthPicker, self, @"borderWidth");
}

@end

@implementation CAShapeLayer (zhTheme)

- (zhThemeColorPicker *)zh_fillColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_fillColorPicker:(zhThemeColorPicker *)zh_fillColorPicker {
    zh_setThemePicker(zh_fillColorPicker, self, @"fillColor");
}

- (zhThemeColorPicker *)zh_strokeColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_strokeColorPicker:(zhThemeColorPicker *)zh_strokeColorPicker {
    zh_setThemePicker(zh_strokeColorPicker, self, @"strokeColor");
}

@end
