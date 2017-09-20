//
//  NSObject+zhTheme.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zhTheme.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, zhThemePicker *> *zh_themeProperties;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary<NSString *, NSNumber *> *> *zh_themeEnumerations;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *zh_themeTextAttributes;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_themeCustomObjects;
@property (nonatomic, assign, readonly) BOOL zh_themeMarkerNotification;

@end

@implementation NSObject (zhTheme)

- (BOOL)zh_themeMarkerNotification {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZh_themeMarkerNotification:(BOOL)zh_themeMarkerNotification {
    objc_setAssociatedObject(self, @selector(zh_themeMarkerNotification), @(zh_themeMarkerNotification), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSMutableDictionary<NSString *,id> * zh_addThemeListener(NSObject *object, const void *key, SEL aSelector) {
    NSMutableDictionary<NSString *, id> *dictionary = objc_getAssociatedObject(object, key);
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(object, key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:object selector:aSelector name:zhThemeUpdateNotification object:nil];
        [object setZh_themeMarkerNotification:YES];
    }
    return dictionary;
}

- (NSMutableDictionary<NSString *,id> *)zh_themeProperties {
    return zh_addThemeListener(self, _cmd, @selector(zh_themeUpdateForProperties));
}

- (NSMutableDictionary<NSString *,id> *)zh_themeEnumerations {
    return zh_addThemeListener(self, _cmd, @selector(zh_themeUpdateForEnumerations));
}

- (NSMutableDictionary<NSString *,id> *)zh_themeTextAttributes {
    return zh_addThemeListener(self, _cmd, @selector(zh_themeUpdateForTextAttributes));
}

- (NSMutableDictionary<NSString *,id> *)zh_themeCustomObjects {
    return zh_addThemeListener(self, _cmd, @selector(zh_themeUpdateForCustomObjects));
}

- (void)zh_themeUpdateForProperties { // for obj properties. picker
    [self.zh_themeProperties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
        void (^calls)(id) = ^(_Nullable id value){
            if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                    [self setValue:value forKeyPath:propertyName];
                }];
            } else {
                [self setValue:value forKeyPath:propertyName];
            }
        };
        
        id value = getPickerValue(picker, propertyName);
        if ([value isKindOfClass:[UIColor class]] && [self isKindOfClass:[CALayer class]]) {
            calls(((__bridge id _Nullable)[value CGColor])); // for CGColorRef
        } else {
            calls(value);
        }
    }];
}

- (void)zh_themeUpdateForEnumerations { // keyboardAppearance / statusBarStyle
    [self.zh_themeEnumerations enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSString *,NSNumber *> * _Nonnull dictionary, BOOL * _Nonnull stop) {
        NSNumber *number = [dictionary objectForKey:ThemeManager.currentStyle];
        performSelectorWithArguments(self, NSSelectorFromString(selName), number.integerValue);
        if ([selName.lowercaseString rangeOfString:@"keyboard"].location != NSNotFound) {
            performSelectorWithArguments(self, NSSelectorFromString(@"reloadInputViews"));
        }
    }];
}

- (void)zh_themeUpdateForTextAttributes { // textAttributes
    [self.zh_themeTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,id> * _Nonnull dictionary, BOOL * _Nonnull stop) {
     
        NSMutableDictionary* (^calls)(NSDictionary *) = ^(NSDictionary *dict){
            __block NSMutableDictionary *textAttrs = [dict mutableCopy];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[zhThemePicker class]]) {
                    textAttrs[key] = getPickerValue(obj, key);
                }
            }];
            return textAttrs;
        };
    
        NSScanner *scan = [NSScanner scannerWithString:key];
        NSInteger var;
        if ([scan scanInteger:&var] && [scan isAtEnd]) {
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSString *, id> * _Nonnull dict, BOOL * _Nonnull stop) {
                performSelectorWithArguments(self, NSSelectorFromString(selName), calls(dict), [key integerValue]);
            }];
        } else {
            performSelectorWithArguments(self, NSSelectorFromString(key), calls(dictionary));
        }
    }];
}

- (void)zh_themeUpdateForCustomObjects { // objects ... / custom sel
    [self.zh_themeCustomObjects enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull objcet, BOOL * _Nonnull stop) {
        
        if ([objcet isKindOfClass:[zhThemePicker class]]) {
         
            zhThemePicker *picker = (zhThemePicker *)objcet;
            id value = getPickerValue(objcet, key);
            if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                    performSelectorWithArguments(self, NSSelectorFromString(key), value);
                }];
            } else {
                performSelectorWithArguments(self, NSSelectorFromString(key), value);
            }
            
        } else if ([objcet isKindOfClass:[NSDictionary class]]) {
            
            NSMutableDictionary<NSString *, zhThemePicker *> *dictionary = objcet;
            NSInteger state = [key integerValue];
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
                id value = getPickerValue(picker, selName);
                if ([[picker valueForKey:@"isAnimated"] boolValue]) {
                    [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                        performSelectorWithArguments(self, NSSelectorFromString(selName), value, state);
                    }];
                } else {
                    performSelectorWithArguments(self, NSSelectorFromString(selName), value, state);
                }
            }];
            
        } else if ([objcet isKindOfClass:[NSArray class]]) {
          
            NSArray<zhThemePicker *> *array = (NSArray<zhThemePicker *> *)objcet;
            id value1 = getPickerValue(array.firstObject, key);
            id value2 = getPickerValue(array.lastObject, key);
            if ([[array.firstObject valueForKey:@"isAnimated"] boolValue]) {
                [UIView animateWithDuration:ThemeManager.changeThemeColorAnimationDuration animations:^{
                    performSelectorWithArguments(self, NSSelectorFromString(key), value1, value2);
                }];
            } else {
                performSelectorWithArguments(self, NSSelectorFromString(key), value1, value2);
            }
            
        }
    }];
}

id zh_getThemePicker(id instance, const void *key) {
    return objc_getAssociatedObject(instance, key);
}

// for picker. properties
void zh_setThemePicker(zhThemePicker *picker, id instance, NSString *propertyName) {
    NSString *pickerName = [NSString stringWithFormat:@"zh_%@Picker", propertyName];
    objc_setAssociatedObject(instance, NSSelectorFromString(pickerName), picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([instance isKindOfClass:[CALayer class]]) { // CGColorRef
        id value = (__bridge id _Nullable)(picker.themeColor.CGColor);
        [instance setValue:value forKeyPath:propertyName];
    } else {
        id value = getPickerValue(picker, propertyName);
        [instance setValue:value forKeyPath:propertyName];
    }
    NSMutableDictionary *pickers = [instance valueForKey:@"zh_themeProperties"];
    [pickers setObject:picker forKey:propertyName];
}

// for enumerations type.
void zh_makeThemeEnumerations(id instance, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict) {
    id obj = [dict objectForKey:ThemeManager.currentStyle];
    if ([obj isKindOfClass:[NSNumber class]]) {
        performSelectorWithArguments(instance, aSelector, [obj integerValue]);
        NSString *lowerName = NSStringFromSelector(aSelector).lowercaseString;
        if ([lowerName rangeOfString:@"keyboard"].location != NSNotFound) {
            performSelectorWithArguments(instance, NSSelectorFromString(@"reloadInputViews"));
        }
        NSMutableDictionary *dictionary = [instance valueForKey:@"zh_themeEnumerations"];
        [dictionary setObject:dict forKey:NSStringFromSelector(aSelector)];
    }
}

// for textAttributes.
void zh_makeThemeTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs) {
    __block NSMutableDictionary *textAttr = attrs.mutableCopy;
    [attrs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = getPickerValue(obj, key);
        }
    }];
    performSelectorWithArguments(instance, aSelector, textAttr);
    NSMutableDictionary *attributes = [instance valueForKey:@"zh_themeTextAttributes"];
    [attributes setObject:attrs forKey:NSStringFromSelector(aSelector)];
}

// for textAttributes. with state
void zh_makeThemeStateTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs, NSInteger state) {
    __block NSMutableDictionary *textAttr = attrs.mutableCopy;
    [attrs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = getPickerValue(obj, key);
        }
    }];
    performSelectorWithArguments(instance, aSelector, textAttr, state);
    NSMutableDictionary *attributes = [instance valueForKey:@"zh_themeTextAttributes"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, NSDictionary *> *dictionary = [attributes objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:attrs forKey:NSStringFromSelector(aSelector)];
    [attributes setObject:dictionary forKey:stateKey];
}

// for picker. with state
void zh_makeThemeStatePicker(id instance, SEL aSelector, zhThemePicker *picker, NSInteger state) {
    id value = getPickerValue(picker, NSStringFromSelector(aSelector));
    performSelectorWithArguments(instance, aSelector, value, state);
    NSMutableDictionary *objects = [instance valueForKey:@"zh_themeCustomObjects"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, zhThemePicker *> *dictionary = [objects objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:picker forKey:NSStringFromSelector(aSelector)];
    [objects setObject:dictionary forKey:stateKey];
}

// for a picker
void zh_makeThemePicker1(id instance, SEL aSelector, zhThemePicker *picker) {
    id value = getPickerValue(picker, NSStringFromSelector(aSelector));
    performSelectorWithArguments(instance, aSelector, value);
    NSMutableDictionary *customPickers = [instance valueForKey:@"zh_themeCustomObjects"];
    [customPickers setObject:picker forKey:NSStringFromSelector(aSelector)];
}

// for two picker.
void zh_makeThemePicker2(NSObject *object, SEL aSelector, zhThemePicker *picker1, zhThemePicker *picker2) {
    id value1 = getPickerValue(picker1, NSStringFromSelector(aSelector));
    id value2 = getPickerValue(picker2, NSStringFromSelector(aSelector));
    performSelectorWithArguments(object, aSelector, value1, value2);
    NSMutableDictionary *customPickers = [object valueForKey:@"zh_themeCustomObjects"];
    [customPickers setObject:@[picker1, picker2] forKey:NSStringFromSelector(aSelector)];
}


id getPickerValue(zhThemePicker *picker, NSString *byString) { //todo ...
    NSString *lowerName = byString.lowercaseString;
    if ([lowerName rangeOfString:@"color"].location != NSNotFound) return picker.themeColor;
    if ([lowerName rangeOfString:@"image"].location != NSNotFound) return picker.themeImage;
    if ([lowerName rangeOfString:@"font"].location != NSNotFound)  return picker.themeFont;
    return picker.themeDouble; //...unidentified method: `byString`
}

void performSelectorWithArguments(id instance ,SEL sel, ...) {
    NSMethodSignature *sig = [instance methodSignatureForSelector:sel];
    if (!sig) [instance doesNotRecognizeSelector:sel];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv) [instance doesNotRecognizeSelector:sel];
    [inv setTarget:instance];
    [inv setSelector:sel];
    va_list args;
    va_start(args, sel);
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        switch (*type) { // parameter type
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            {
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            } break;
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;
            case '@': // id => NSString / NSNumber / NSArray / NSDictionary / NSObject / ...
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;
            default: break;
        }
    }
    va_end(args);
    [inv invoke];
}

+ (void)load {
    Class class = [self class];
    SEL originalSelector = NSSelectorFromString(@"dealloc");
    SEL swizzledSelector = @selector(zh_themeDealloc);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zh_themeDealloc {
    if (self.zh_themeMarkerNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:zhThemeUpdateNotification object:nil];
    }
    [self zh_themeDealloc];
}

@end
