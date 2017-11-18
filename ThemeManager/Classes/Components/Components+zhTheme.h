//
//  UIKit+zhTheme.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
@class
zhThemeColorPicker,
zhThemeImagePicker,
zhThemeFontPicker,
zhThemeNumberPicker,
zhThemeTextPicker;

NS_ASSUME_NONNULL_BEGIN

/////////////////////////////// UIKit+zhTheme ///////////////////////////////

@interface UIView (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_backgroundColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_tintColorPicker;
@property (nonatomic, strong) zhThemeNumberPicker *zh_alphaPicker;

@end

@interface UILabel (zhTheme)

/// zh_fontPicker- Only supported by Through the dictionary Settings. use other method is invalid.
@property (nonatomic, strong) zhThemeFontPicker *zh_fontPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_textColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_shadowColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_highlightedTextColorPicker;

@end

@interface UIButton (zhTheme)

- (void)zh_setTitleColorPicker:(zhThemeColorPicker *)picker forState:(UIControlState)state;
- (void)zh_setImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state;
- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state;
- (void)zh_setBackgroundColorPicker:(zhThemeColorPicker *)picker forState:(UIControlState)state;

@end

@interface UIImageView (zhTheme)

@property (nonatomic, strong) zhThemeImagePicker *zh_imagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_highlightedImagePicker; // When `highlighted` set YES is valid.
- (instancetype)zh_initWithImagePicker:(zhThemeImagePicker *)picker;
- (instancetype)zh_initWithImagePicker:(zhThemeImagePicker *)picker highlightedImagePicker:(zhThemeImagePicker *)highlightedPicker;

@end

@interface UITableView (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_separatorColorPicker;

@end

@interface UIPageControl (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_pageIndicatorTintColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_currentPageIndicatorTintColorPicker;

@end

@interface UIProgressView (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_progressTintColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_trackTintColorPicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_progressImagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_trackImagePicker;

@end

@interface UITextField (zhTheme)

/// zh_fontPicker- Only supported by Through the dictionary Settings. use other method is invalid.
@property (nonatomic, strong) zhThemeFontPicker *zh_fontPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_textColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_placeholderTextColorPicker;
/**
 Example:
 NSDictionary *dict = @{ThemeStyle1 : @(UIKeyboardAppearanceDefault),
                        ThemeStyle2 : @(UIKeyboardAppearanceDark)};
 [self.textField zh_setKeyboardAppearance:dict];
 */
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UITextView (zhTheme)

/// zh_fontPicker- Only supported by Through the dictionary Settings. use other method is invalid.
@property (nonatomic, strong) zhThemeFontPicker *zh_fontPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_textColorPicker;
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UISearchBar (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_barTintColorPicker;
- (void)zh_setKeyboardAppearance:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

@interface UIToolbar (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_barTintColorPicker;

@end

@interface UITabBar (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_barTintColorPicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_backgroundImagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_shadowImagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_selectionIndicatorImagePicker;

@end

@interface UIBarItem (zhTheme)

@property (nonatomic, strong, nonnull) zhThemeImagePicker *zh_imagePicker;

/// Currently only support NSForegroundColorAttributeName / NSFontAttributeName.
- (void)zh_setTitleTextPickerAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state;

@end

@interface UIBarButtonItem (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_tintColorPicker;

@end

@interface UITabBarItem (zhTheme)

@property (nonatomic, strong) zhThemeImagePicker *zh_selectedImagePicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_badgeColorPicker;

@end

@interface UINavigationBar (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_barTintColorPicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_shadowImagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_backIndicatorImagePicker;
@property (nonatomic, strong) zhThemeImagePicker *zh_backIndicatorTransitionMaskImagePicker;

- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics;
- (void)zh_setBackgroundColorPicker:(zhThemeColorPicker *)picker forBarMetrics:(UIBarMetrics)barMetrics;

/// Currently only support NSForegroundColorAttributeName / NSFontAttributeName.
- (void)zh_setTitleTextAttributes:(nullable NSDictionary<NSString *, id> *)titleTextAttributes;

@end

@interface UIApplication (zhTheme)

/// app info.plist - when `View controller-based status bar appearance` item set to N0 is valid.
- (void)zh_setStatusBarStyle:(nullable NSDictionary<NSString *, NSNumber *> *)dict;

@end

/////////////////////////////// QuartzCore+zhTheme ///////////////////////////////

@interface CALayer (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_backgroundColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_borderColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_shadowColorPicker;
@property (nonatomic, strong) zhThemeNumberPicker *zh_borderWidthPicker;

@end

@interface CAShapeLayer (zhTheme)

@property (nonatomic, strong) zhThemeColorPicker *zh_fillColorPicker;
@property (nonatomic, strong) zhThemeColorPicker *zh_strokeColorPicker;

@end

NS_ASSUME_NONNULL_END
