//
//  Supplementary+zhTheme.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "Supplementary+zhTheme.h"
#import "zhThemeUtilities.h"

@interface UINavigationBar ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_themeForExternalDict;

@end

@implementation UINavigationBar (zhThemeOverlay)

// overwrite `zh_themeUpdateForExternal`
- (void)zh_themeUpdateForExternal {
    [self.zh_themeForExternalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, zhThemeColorPicker *  _Nonnull picker, BOOL * _Nonnull stop) {
        if (picker.isAnimated) {
            [UIView animateWithDuration:ThemeManager.themeColorChangeInterval animations:^{
                [self zh_setOverlayViewBackgroundColor:picker.color];
            }];
        } else {
            [self zh_setOverlayViewBackgroundColor:picker.color];
        }
    }];
}

- (UIView *)zh_themeOverlayView {
    UIView *zhThemeOverlayView = objc_getAssociatedObject(self, _cmd);
    if (!zhThemeOverlayView) {
        zhThemeOverlayView = [[UIImageView alloc] init];
        CGFloat statusBarHeight = 20;
        if ([NSStringFromCGSize([UIScreen mainScreen].bounds.size) isEqualToString:@"{375, 812}"]) {
            statusBarHeight = 44; // iphone X
        }
        zhThemeOverlayView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
        zhThemeOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.subviews.firstObject insertSubview:zhThemeOverlayView atIndex:0];
        objc_setAssociatedObject(self, _cmd, zhThemeOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return zhThemeOverlayView;
}

- (void)zh_setOverlayViewBackgroundColor:(UIColor *)color {
    self.zh_themeOverlayView.backgroundColor = color;
}

- (zhThemeColorPicker *)zh_overlayColorPicker {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZh_overlayColorPicker:(zhThemeColorPicker *)zh_overlayColorPicker {
    if (!zh_overlayColorPicker) {
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.zh_themeOverlayView removeFromSuperview];
        objc_setAssociatedObject(self, @selector(zh_themeOverlayView), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.zh_themeForExternalDict removeObjectForKey:NSStringFromSelector(@selector(zh_setOverlayViewBackgroundColor:))];
        return;
    }
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    objc_setAssociatedObject(self, @selector(zh_overlayColorPicker), zh_overlayColorPicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zh_setOverlayViewBackgroundColor:zh_overlayColorPicker.color];
    [self.zh_themeForExternalDict setObject:zh_overlayColorPicker forKey:NSStringFromSelector(@selector(zh_setOverlayViewBackgroundColor:))];
}

@end

@implementation UITabBar (zhThemeOverlay)

- (UIView *)zh_themeOverlayView {
    UIView *zhThemeOverlayView = objc_getAssociatedObject(self, _cmd);
    if (!zhThemeOverlayView) {
        zhThemeOverlayView = [[UIView alloc] init];
        zhThemeOverlayView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.bounds.size.height);
        zhThemeOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:zhThemeOverlayView atIndex:0];
        objc_setAssociatedObject(self, _cmd, zhThemeOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return zhThemeOverlayView;
}

- (zhThemeColorPicker *)zh_overlayColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_overlayColorPicker:(zhThemeColorPicker *)zh_overlayColorPicker {
    zh_setThemePicker(zh_overlayColorPicker, self, @"zh_themeOverlayView.backgroundColor");
}

@end
