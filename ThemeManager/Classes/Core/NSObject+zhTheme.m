//
//  NSObject+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zhTheme.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_pickers;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_CGpickers;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_attributes;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_enumDicts;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_customPickers;

@end

@implementation NSObject (zhTheme)

NSMutableDictionary<NSString *,id> * addListener(NSObject *object, const void *key, SEL aSelector) {
    NSMutableDictionary<NSString *, id> *dictionary = objc_getAssociatedObject(object, key);
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(object, key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:object selector:aSelector name:zhThemeUpdateNotification object:nil];
    }
    return dictionary;
}

- (NSMutableDictionary<NSString *,id> *)zh_pickers {
    return addListener(self, _cmd, @selector(zhThemeUpdate));
}

- (NSMutableDictionary<NSString *,id> *)zh_CGpickers {
    return addListener(self, _cmd, @selector(zhThemeCGUpdate));
}

- (NSMutableDictionary<NSString *,id> *)zh_enumDicts {
    return addListener(self, _cmd, @selector(zhThemeUpdateEnumType));
}

- (NSMutableDictionary<NSString *,id> *)zh_attributes {
    return addListener(self, _cmd, @selector(zhThemeUpdateTextAttributes));
}

- (NSMutableDictionary<NSString *,id> *)zh_customPickers {
    return addListener(self, _cmd, @selector(zhThemeUpdateCustomize));
}

- (void)zhThemeUpdate {
    [self.zh_pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary<NSString *, zhThemePicker *> *dictionary = obj;
            NSInteger state = [key integerValue];
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
                id value = getPickerValue(picker, selName);
                if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                    [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                        performSelectorWithObjAndInteger(self, NSSelectorFromString(selName), value, state);
                    }];
                } else {
                    performSelectorWithObjAndInteger(self, NSSelectorFromString(selName), value, state);
                }
            }];
        } else if ([obj isKindOfClass:[zhThemePicker class]]) {
            zhThemePicker *picker = obj;
            id value = getPickerValue(picker, key);
            if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                    [self setValue:value forKeyPath:key];
                }];
            } else {
                [self setValue:value forKeyPath:key];
            }
        }
    }];
}

- (void)zhThemeCGUpdate {
    [self.zh_CGpickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            zhThemePicker *picker = (zhThemePicker *)obj;
            CGColorRef colorRef = picker.themeColor.CGColor;
            if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                    [self setValue:(__bridge id _Nullable)(colorRef) forKeyPath:key];
                }];
            } else {
                [self setValue:(__bridge id _Nullable)(colorRef) forKeyPath:key];
            }
        }
    }];
}

- (void)zhThemeUpdateEnumType {
    [self.zh_enumDicts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            id value = [(NSDictionary *)obj objectForKey:ThemeManager.currentStyle];
            performSelectorWithInteger(self, NSSelectorFromString(key), [value integerValue]);
            if ([key.lowercaseString rangeOfString:@"keyboard"].location != NSNotFound) {
                performSelector(self, NSSelectorFromString(@"reloadInputViews"));
            }
        }
    }];
}

- (void)zhThemeUpdateTextAttributes {
    [self.zh_attributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) { // obj is NSDictionary type.
        if (scanInt(key)) {
            NSDictionary<NSString *, NSDictionary *> *dictionary = (NSDictionary *)object;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSString *, id> * _Nonnull dict, BOOL * _Nonnull stop) {
                __block NSMutableDictionary *textAttr = [dict mutableCopy];
                [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[zhThemePicker class]]) {
                        textAttr[key] = getPickerValue(obj, key);
                    }
                }];
                performSelectorWithObjAndInteger(self, NSSelectorFromString(selName), textAttr, [key integerValue]);
            }];
        } else {
            __block NSMutableDictionary *textAttr = [object mutableCopy];
            [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[zhThemePicker class]]) {
                    textAttr[key] = getPickerValue(obj, key);
                }
            }];
            performSelectorWithObj(self, NSSelectorFromString(key), textAttr);
        }
    }];
}

- (void)zhThemeUpdateCustomize {
    [self.zh_customPickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            id value = getPickerValue(obj, key);
            performSelectorWithObj(self, NSSelectorFromString(key), value);
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray<zhThemePicker *> *array = (NSArray<zhThemePicker *> *)obj;
            id value1 = getPickerValue(array.firstObject, key);
            id value2 = getPickerValue(array.lastObject, key);
            performSelectorWithObjAndObj(self, NSSelectorFromString(key), value1, value2);
        }
    }];
}

bool scanInt(NSString *string) {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

id getThemePicker(NSObject *object, const void *key) {
    return objc_getAssociatedObject(object, key);
}

// for picker. properties
void setThemePicker(zhThemePicker *picker, NSObject *object, NSString *propertyName) {
    NSString *pickerName = [NSString stringWithFormat:@"zh_%@Picker", propertyName];
    objc_setAssociatedObject(object, NSSelectorFromString(pickerName), picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    id value = getPickerValue(picker, propertyName);
    [object setValue:value forKeyPath:propertyName];
    NSMutableDictionary *pickers = [object valueForKey:@"zh_pickers"];
    [pickers setObject:picker forKey:propertyName];
}

// for CA picker. properties
void setThemeCGPicker(zhThemePicker *picker, NSObject *object, NSString *propertyName) {
    NSString *pickerName = [NSString stringWithFormat:@"zh_%@Picker", propertyName];
    objc_setAssociatedObject(object, NSSelectorFromString(pickerName), picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [object setValue:(__bridge id _Nullable)(picker.themeColor.CGColor) forKeyPath:propertyName];
    NSMutableDictionary *pickers = [object valueForKey:@"zh_CGpickers"];
    [pickers setObject:picker forKey:propertyName];
}

// for picker. parameters is NSInteger selector.
void makeThemeStatePicker(zhThemePicker *picker, NSObject *object, SEL aSelector, NSInteger state) {
    id value = getPickerValue(picker, NSStringFromSelector(aSelector));
    performSelectorWithObjAndInteger(object, aSelector, value, state);
    NSMutableDictionary *pickers = [object valueForKey:@"zh_pickers"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, zhThemePicker *> *dictionary = [pickers objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:picker forKey:NSStringFromSelector(aSelector)];
    [pickers setObject:dictionary forKey:stateKey];
}

// for enum type.
void makeThemeEnumDictionary(NSObject *object, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict) {
    if (![dict.allKeys containsObject:ThemeManager.currentStyle]) return;
    NSInteger value = 0;
    id obj = [dict objectForKey:ThemeManager.currentStyle];
    if ([obj isKindOfClass:[NSNumber class]]) value = [((NSNumber *)obj) integerValue];
    performSelectorWithInteger(object, aSelector, value);
    NSString *lowerName = NSStringFromSelector(aSelector).lowercaseString;
    if ([lowerName rangeOfString:@"keyboard"].location != NSNotFound) {
        performSelector(object, NSSelectorFromString(@"reloadInputViews"));
    }
    NSMutableDictionary *sets = [object valueForKey:@"zh_enumDicts"];
    [sets setObject:dict forKey:NSStringFromSelector(aSelector)];
}

// for textAttributes. 
void makeThemeAttributes(NSObject *object, SEL aSelector, NSDictionary<NSString *,id> *dict) {
    __block NSMutableDictionary *textAttr = dict.mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = getPickerValue(obj, key);
        }
    }];
    performSelectorWithObj(object, aSelector, textAttr);
    NSMutableDictionary *attributes = [object valueForKey:@"zh_attributes"];
    [attributes setObject:dict forKey:NSStringFromSelector(aSelector)];
}

// for textAttributes. with state
void makeThemeStateAttributes(NSObject *object, SEL aSelector, NSDictionary<NSString *,id> *dict, NSInteger state) {
    __block NSMutableDictionary *textAttr = dict.mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = getPickerValue(obj, key);
        }
    }];
    performSelectorWithObjAndInteger(object, aSelector, textAttr, state);
    NSMutableDictionary *attributes = [object valueForKey:@"zh_attributes"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, NSDictionary *> *dictionary = [attributes objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:dict forKey:NSStringFromSelector(aSelector)];
    [attributes setObject:dictionary forKey:stateKey];
}

// for a picker
void deployThemePicker1(NSObject *object, SEL aSelector, zhThemePicker *picker) {
    id value = getPickerValue(picker, NSStringFromSelector(aSelector));
    performSelectorWithObj(object, aSelector, value);
    NSMutableDictionary *customPickers = [object valueForKey:@"zh_customPickers"];
    [customPickers setObject:picker forKey:NSStringFromSelector(aSelector)];
}

// for two picker.
void deployThemePicker2(NSObject *object, SEL aSelector, zhThemePicker *picker1, zhThemePicker *picker2) {
    id value1 = getPickerValue(picker1, NSStringFromSelector(aSelector));
    id value2 = getPickerValue(picker2, NSStringFromSelector(aSelector));
    performSelectorWithObjAndObj(object, aSelector, value1, value2);
    NSMutableDictionary *customPickers = [object valueForKey:@"zh_customPickers"];
    [customPickers setObject:@[picker1, picker2] forKey:NSStringFromSelector(aSelector)];
}

id getPickerValue(zhThemePicker *picker, NSString *byString) {
    NSString *lowerName = byString.lowercaseString;
    if ([lowerName rangeOfString:@"color"].location != NSNotFound) return picker.themeColor;
    if ([lowerName rangeOfString:@"image"].location != NSNotFound) return picker.themeImage;
    if ([lowerName rangeOfString:@"font"].location != NSNotFound) return picker.themeFont;
    return picker.themeDouble; //...unidentified method: `byString`
}

void performSelector(id object, SEL selector) {
    ((void(*)(id, SEL))objc_msgSend)(object, selector);
}

void performSelectorWithObj(id object, SEL selector, id obj) {
    ((void(*)(id, SEL, id))objc_msgSend)(object, selector, obj);
}

void performSelectorWithObjAndObj(id object, SEL selector, id obj1, id obj2) {
    ((void(*)(id, SEL, id, id))objc_msgSend)(object, selector, obj1, obj2);
}

void performSelectorWithInteger(id object, SEL selector, NSInteger aInteger) {
    ((void(*)(id, SEL, NSInteger))objc_msgSend)(object, selector, aInteger);
}

void performSelectorWithObjAndInteger(id object, SEL selector, id obj, NSInteger aInteger) {
    ((void(*)(id, SEL, id, NSInteger))objc_msgSend)(object, selector, obj, aInteger);
}

@end

@implementation UIViewController (zh_ThemeDealloc)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(zhThemeDealloc);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL isSuccess = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (isSuccess) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)zhThemeDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:zhThemeUpdateNotification object:nil];
    [self zhThemeDealloc];
}

@end
