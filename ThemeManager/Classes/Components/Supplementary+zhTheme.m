//
//  Supplementary+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/29.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "Supplementary+zhTheme.h"
#import "NSObject+zhTheme.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_themeCustomObjects;

@end

@implementation UINavigationBar (zhThemeOverlay)

// overwrite `zh_themeUpdateForCustomObjects`
- (void)zh_themeUpdateForCustomObjects {
    [self.zh_themeCustomObjects enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, zhThemePicker *  _Nonnull picker, BOOL * _Nonnull stop) {
        if ([[picker valueForKey:@"isAnimated"] boolValue]) {
            [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                [self zh_setOverlayViewBackgroundColor:picker.themeColor];
            }];
        } else {
            [self zh_setOverlayViewBackgroundColor:picker.themeColor];
        }
    }];
}

- (UIView *)zh_overlayView {
    UIView *overlayView = objc_getAssociatedObject(self, _cmd);
    if (!overlayView) {
        overlayView = [[UIView alloc] init];
        CGFloat height = [NSStringFromCGSize([UIScreen mainScreen].bounds.size) isEqualToString:@"{375, 812}"] ? 44 : 20;
        overlayView.frame = CGRectMake(0, -height, UIScreen.mainScreen.bounds.size.width, height);
        overlayView.userInteractionEnabled = NO;
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:overlayView];
        objc_setAssociatedObject(self, _cmd, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return overlayView;
}

- (void)zh_setOverlayViewBackgroundColor:(UIColor *)color {
    self.layer.backgroundColor = color.CGColor;
    self.zh_overlayView.backgroundColor = color;
}

- (zhThemePicker *)zh_overlayColorPicker {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZh_overlayColorPicker:(zhThemePicker *)zh_overlayColorPicker {
    if (!zh_overlayColorPicker) {
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.zh_overlayView removeFromSuperview];
        objc_setAssociatedObject(self, @selector(zh_overlayView), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.zh_themeCustomObjects removeObjectForKey:NSStringFromSelector(@selector(zh_setOverlayViewBackgroundColor:))];
        return;
    }
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    objc_setAssociatedObject(self, @selector(zh_overlayColorPicker), zh_overlayColorPicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zh_setOverlayViewBackgroundColor:zh_overlayColorPicker.themeColor];
    [self.zh_themeCustomObjects setObject:zh_overlayColorPicker forKey:NSStringFromSelector(@selector(zh_setOverlayViewBackgroundColor:))];
}

@end

@implementation UITabBar (zhThemeOverlay)

- (UIView *)zh_overlayView {
    UIView *overlayView = objc_getAssociatedObject(self, _cmd);
    if (!overlayView) {
        overlayView = [[UIView alloc] init];
        overlayView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.bounds.size.height);
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:overlayView atIndex:0];
        objc_setAssociatedObject(self, _cmd, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return overlayView;
}

- (zhThemePicker *)zh_overlayColorPicker {
    return zh_getThemePicker(self, _cmd);
}

- (void)setZh_overlayColorPicker:(zhThemePicker *)zh_overlayColorPicker {
    zh_setThemePicker(zh_overlayColorPicker, self, @"zh_overlayView.backgroundColor");
}

@end
