//
//  UIKit+zhTheme.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhThemePicker;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_backgroundColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_tintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_alphaPicker;

@end

@interface UILabel (zhTheme)

// zh_fontPicker- Only supported by `ThemePickerWithDict(dict)` Settings. use the `ThemePickerWithKey(key)` is invalid.
@property (nonatomic, strong) zhThemePicker *zh_fontPicker;
@property (nonatomic, strong) zhThemePicker *zh_textColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_shadowColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_highlightedTextColorPicker;

@end

@interface UIButton (zhTheme)

- (void)zh_setTitleColorPicker:(zhThemePicker *)picker forState:(UIControlState)state;
- (void)zh_setImagePicker:(zhThemePicker *)picker forState:(UIControlState)state;
- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forState:(UIControlState)state;

@end

@interface UIImageView (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_imagePicker;
@property (nonatomic, strong) zhThemePicker *zh_highlightedImagePicker; // When `highlighted` set YES is valid.
- (instancetype)zh_initWithImagePicker:(zhThemePicker *)picker;
- (instancetype)zh_initWithImagePicker:(zhThemePicker *)picker highlightedImagePicker:(zhThemePicker *)highlightedPicker;

@end

@interface UITableView (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_separatorColorPicker;

@end

@interface UIPageControl (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_pageIndicatorTintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_currentPageIndicatorTintColorPicker;

@end

@interface UIProgressView (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_progressTintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_trackTintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_progressImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_trackImagePicker;

@end

@interface UITextField (zhTheme)

// zh_fontPicker- Only supported by `ThemePickerWithDict(dict)` Settings. use the `ThemePickerWithKey(key)` is invalid.
@property (nonatomic, strong) zhThemePicker *zh_fontPicker;
@property (nonatomic, strong) zhThemePicker *zh_textColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_placeholderTextColorPicker;
/*
 Example:
 NSDictionary *dict = @{ThemeStyle1 : @(UIKeyboardAppearanceDefault),
                        ThemeStyle2 : @(UIKeyboardAppearanceDark)};
 [self.textField zh_setKeyboardAppearance:dict];
 */
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UITextView (zhTheme)

// zh_fontPicker- Only supported by `ThemePickerWithDict(dict)` Settings. use the `ThemePickerWithKey(key)` is invalid.
@property (nonatomic, strong) zhThemePicker *zh_fontPicker;
@property (nonatomic, strong) zhThemePicker *zh_textColorPicker;
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UISearchBar (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_barTintColorPicker;
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UIToolbar (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_barTintColorPicker;

@end

@interface UITabBar (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_barTintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_backgroundImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_shadowImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_selectionIndicatorImagePicker;

@end

@interface UIBarItem (zhTheme)

@property (nonatomic, strong, nonnull) zhThemePicker *zh_imagePicker;

/// Currently only support NSForegroundColorAttributeName / NSFontAttributeName.
- (void)zh_setTitleTextPickerAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state;

@end

@interface UIBarButtonItem (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_tintColorPicker;

@end

@interface UITabBarItem (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_selectedImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_badgeColorPicker;

@end

@interface UINavigationBar (zhTheme)

@property (nonatomic, strong) zhThemePicker *zh_barTintColorPicker;
@property (nonatomic, strong) zhThemePicker *zh_shadowImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_backIndicatorImagePicker;
@property (nonatomic, strong) zhThemePicker *zh_backIndicatorTransitionMaskImagePicker;
- (void)zh_setBackgroundImagePicker:(zhThemePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics;

/// Currently only support NSForegroundColorAttributeName / NSFontAttributeName.
- (void)zh_setTitleTextAttributes:(nullable NSDictionary<NSString *, id> *)titleTextAttributes;

@end

@interface UIApplication (zhTheme)

/// app info.plist - when `View controller-based status bar appearance` item set to N0 is valid.
- (void)zh_setStatusBarStyle:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

NS_ASSUME_NONNULL_END

