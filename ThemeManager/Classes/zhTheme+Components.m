//
//  zhTheme+Components.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/27.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#include <objc/runtime.h>
#import "zhTheme+Components.h"
#import "zhThemePicker.h"

typedef NSMutableDictionary<NSString *, zhThemePicker *> zhThemePickerSets;

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableOrderedSet *zhThemeUpdateCallbackSets;
@property (nonatomic, strong, readonly) zhThemePickerSets *zhThemeUpdateProperties;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, zhThemePickerSets *> *zhThemeUpdateStateMethods;

@end

@implementation NSObject (zhTheme)

- (BOOL)zh_themeNotificationTagged {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)zh_setThemeNotificationTagged:(BOOL)tagged {
    objc_setAssociatedObject(self, @selector(zh_themeNotificationTagged), @(tagged), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString *,id> *)zh_themeAddListener:(const void *)key sel:(SEL)aSelector {
    NSMutableDictionary<NSString *, id> *dictionary = objc_getAssociatedObject(self, key);
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:zhThemeUpdateNotification object:nil];
        [self zh_setThemeNotificationTagged:YES];
    }
    return dictionary;
}

- (NSMutableDictionary<NSString *, id> *)zhThemeUpdateProperties {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themePropertiesCallback)];
}

- (NSMutableDictionary<NSString *, id> *)zhThemeUpdateStateMethods {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeStateMethodsCallback)];
}

- (void)zh_themePropertiesCallback {
    [self.zhThemeUpdateProperties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
        if ([picker isKindOfClass:[zhThemeColorPicker class]]) {
            id value = [(zhThemeColorPicker*)picker color];
            if ([self isKindOfClass:[CALayer class]]) {
                value = (__bridge id _Nullable)[value CGColor];
            }
            if ([(zhThemeColorPicker *)picker isAnimated]) {
                [UIView animateWithDuration:ThemeManager.transitionInterval animations:^{
                    [self setValue:value forKeyPath:propertyName];
                }];
            } else {
                [self setValue:value forKeyPath:propertyName];
            }
        } else {
            [self setValue:[self _getThemePickerValue:picker] forKeyPath:propertyName];
        }
    }];
}

- (void)zh_themeStateMethodsCallback {
    [self.zhThemeUpdateStateMethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,zhThemePicker *> * _Nonnull dictionary, BOOL * _Nonnull stop) {
        NSInteger state = [key integerValue];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
            SEL aSelector = NSSelectorFromString(selName);
            void(*msgSend)(id, SEL, id, NSInteger) = (void *)[self methodForSelector:aSelector];
            if ([picker isKindOfClass:[zhThemeColorPicker class]]) {
                id value = [(zhThemeColorPicker*)picker color];
                if ([(zhThemeColorPicker *)picker isAnimated]) {
                    [UIView animateWithDuration:ThemeManager.transitionInterval animations:^{
                        msgSend(self, aSelector, value, state);
                    }];
                } else {
                    msgSend(self, aSelector, value, state);
                }
            } else {
                msgSend(self, aSelector, [self _getThemePickerValue:picker], state);
            }
        }];
    }];
}

- (zhThemePicker *)zh_getThemePickerWithKey:(const void *)aKey {
    return objc_getAssociatedObject(self, aKey);
}

- (void)zh_setThemePicker:(zhThemePicker *)picker withKey:(NSString *)propertyName {
    if (!picker || !propertyName) return;
    NSString *pickerName = [NSString stringWithFormat:@"zh_%@Picker", propertyName];
    objc_setAssociatedObject(self, NSSelectorFromString(pickerName), picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([picker isKindOfClass:[zhThemeColorPicker class]] &&
        [self isKindOfClass:[CALayer class]]) {
        id value = (__bridge id)([(zhThemeColorPicker *)picker color].CGColor);
        [self setValue:value forKeyPath:propertyName];
    } else {
        id value = [self _getThemePickerValue:picker];
        [self setValue:value forKeyPath:propertyName];
    }
    [self.zhThemeUpdateProperties setObject:picker forKey:propertyName];
}

-(void)zh_setThemePicker:(zhThemePicker *)picker selector:(SEL)aSelector withState:(NSInteger)state {
    if (!picker || ![self respondsToSelector:aSelector]) return;
    id value = [self _getThemePickerValue:picker];
    IMP imp = [self methodForSelector:aSelector];
    void(*msgSend)(id, SEL, id, NSInteger) = (void*)imp;
    msgSend(self, aSelector, value, state);
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    zhThemePickerSets *dictionary = [self.zhThemeUpdateStateMethods objectForKey:stateKey];
    if (!dictionary) dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:picker forKey:NSStringFromSelector(aSelector)];
    [self.zhThemeUpdateStateMethods setObject:dictionary forKey:stateKey];
}

- (id)_getThemePickerValue:(zhThemePicker *)picker {
    if ([picker isKindOfClass:[zhThemeImagePicker class]]) {
        return [(zhThemeImagePicker *)picker image];
    } else if ([picker isKindOfClass:[zhThemeFontPicker class]]) {
        return [(zhThemeFontPicker *)picker font];
    } else if ([picker isKindOfClass:[zhThemeNumberPicker class]]) {
        return [(zhThemeNumberPicker *)picker number];
    } else if ([picker isKindOfClass:[zhThemeTextPicker class]]) {
        return [(zhThemeTextPicker *)picker text];
    } else if ([picker isKindOfClass:[zhThemeColorPicker class]]) {
        return [(zhThemeColorPicker *)picker color];
    } 
    return nil;
}

#pragma mark - CallbackSets

- (NSMutableOrderedSet *)zhThemeUpdateCallbackSets {
    id callbackSets = objc_getAssociatedObject(self, _cmd);
    if (!callbackSets) {
        callbackSets = [NSMutableOrderedSet orderedSet];
        objc_setAssociatedObject(self, _cmd, callbackSets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zh_themeOrderedSetsCallback) name:zhThemeUpdateNotification object:nil];
        [self zh_setThemeNotificationTagged:YES];
    }
    return callbackSets;
}

- (void)zh_themeUpdateCallback:(void (^)(id _Nonnull))block {
    if (!block) return;
    [self.zhThemeUpdateCallbackSets addObject:[block copy]];
    block(self);
}

- (void)zh_themeOrderedSetsCallback {
    for (void (^block)(id _Nonnull) in self.zhThemeUpdateCallbackSets) {
        block(self);
    }
}

@end

@implementation NSObject (zhThemeSwizzling)

+ (void)load {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_x_Max) {
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(zh_themeDealloc);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)zh_themeDealloc {
    if ([self zh_themeNotificationTagged]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:zhThemeUpdateNotification object:nil];
    }
    return [self zh_themeDealloc];
}

@end

UIImage* zhTheme_getImageFromColor(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#define PROPERTYPICKER_IMPL(PROPERTY) \
- (zhThemePicker *)zh_ ## PROPERTY ## Picker { \
return [self zh_getThemePickerWithKey:@selector(zh_ ## PROPERTY ## Picker)]; \
} \
- (void)setZh_ ## PROPERTY ## Picker:(zhThemePicker *)zh_ ## PROPERTY ## Picker { \
[self zh_setThemePicker:zh_ ## PROPERTY ## Picker withKey:(@#PROPERTY)];\
}

/////////////////////////////// UIKit+QuartzCore ///////////////////////////////

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
    [self zh_setThemePicker:picker selector:@selector(setTitleColor:forState:) withState:state];
}

- (void)zh_setImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state {
    [self zh_setThemePicker:picker selector:@selector(setImage:forState:) withState:state];
}

- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forState:(UIControlState)state {
    [self zh_setThemePicker:picker selector:@selector(setBackgroundImage:forState:) withState:state];
}

- (void)zh_setBackgroundColorPicker:(zhThemeColorPicker *)picker forState:(UIControlState)state {
    [self zh_setThemePicker:picker selector:@selector(_set_zhThemeBackgroundColor:forState:) withState:state];
}

- (void)_set_zhThemeBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:zhTheme_getImageFromColor(backgroundColor) forState:state];
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
    const void *aKey = NSSelectorFromString(@"zh__placeholderLabel.textColorPicker");
    return (zhThemeColorPicker *)[self zh_getThemePickerWithKey:aKey];
}

- (void)setZh_placeholderTextColorPicker:(zhThemeColorPicker *)zh_placeholderTextColorPicker {
    [self zh_setThemePicker:zh_placeholderTextColorPicker withKey:@"_placeholderLabel.textColor"];
}

@end

@implementation UITextView (zhTheme)

PROPERTYPICKER_IMPL(font)
PROPERTYPICKER_IMPL(textColor)

@end

@implementation UISearchBar (zhTheme)

PROPERTYPICKER_IMPL(barTintColor)

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
    [self zh_setThemePicker:picker selector:@selector(_set_zhThemeBackgroundColor:forBarMetrics:) withState:barMetrics];
}

- (void)_set_zhThemeBackgroundColor:(UIColor *)backgroundColor forBarMetrics:(UIBarMetrics)barMetrics {
    [self setBackgroundImage:zhTheme_getImageFromColor(backgroundColor) forBarMetrics:barMetrics];
}

- (void)zh_setBackgroundImagePicker:(zhThemeImagePicker *)picker forBarMetrics:(UIBarMetrics)barMetrics {
    [self zh_setThemePicker:picker selector:@selector(setBackgroundImage:forBarMetrics:) withState:barMetrics];
}

@end

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
