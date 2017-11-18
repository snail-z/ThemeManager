//
//  NSObject+zhTheme.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zhTheme.h"
#import "zhThemeUtilities.h"

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, zhThemePicker *> *zh_themePropertiesDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary<NSString *, NSNumber *> *> *zh_themeEnumerationsDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *zh_themeTextAttributesDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary<NSString *, zhThemePicker *> *> *zh_themeMethodStateDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *zh_themeForExternalDict;

@end

@implementation NSObject (zhTheme)

- (BOOL)zh_themeNotificationMarker {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)zh_setThemeNotificationMarker:(BOOL)marker {
    objc_setAssociatedObject(self, @selector(zh_themeNotificationMarker), @(marker), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString *,id> *)zh_themeAddListener:(const void *)key sel:(SEL)aSelector {
    NSMutableDictionary<NSString *, id> *dictionary = objc_getAssociatedObject(self, key);
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:zhThemeUpdateNotification object:nil];
        [self zh_setThemeNotificationMarker:YES];
    }
    return dictionary;
}

- (NSMutableDictionary<NSString *, id> *)zh_themePropertiesDict {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeUpdateForProperties)];
}

- (void)zh_themeUpdateForProperties { // for obj properties.
    [self.zh_themePropertiesDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
        void (^calls)(id) = ^(_Nullable id value) {
            if (picker.valueType == zhThemeValueTypeColor) {
                if ([(zhThemeColorPicker *)picker isAnimated]) {
                    [UIView animateWithDuration:ThemeManager.themeColorChangeInterval animations:^{
                        [self setValue:value forKeyPath:propertyName];
                    }];
                } else {
                    [self setValue:value forKeyPath:propertyName];
                }
            } else {
                [self setValue:value forKeyPath:propertyName];
            }
        };
        
        id value = zh_getThemePickerValue(picker);
        if ([value isKindOfClass:[UIColor class]] && [self isKindOfClass:[CALayer class]]) {
            calls(((__bridge id _Nullable)[value CGColor])); // for CGColorRef
        } else {
            calls(value);
        }
    }];
}

- (NSMutableDictionary<NSString *, id> *)zh_themeEnumerationsDict {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeUpdateForEnumerations)];
}

- (void)zh_themeUpdateForEnumerations { // for keyboardAppearance / statusBarStyle
    [self.zh_themeEnumerationsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSString *,NSNumber *> * _Nonnull dictionary, BOOL * _Nonnull stop) {
        NSNumber *number = [dictionary objectForKey:ThemeManager.currentStyle];
        void(*msgSend)(id, SEL, NSInteger) = (void(*)(id, SEL, NSInteger))objc_msgSend;
        msgSend(self, NSSelectorFromString(selName), [number integerValue]);
        if ([selName.lowercaseString rangeOfString:@"keyboard"].location != NSNotFound) {
            void(*msgSend)(id, SEL) = (void(*)(id, SEL))objc_msgSend;
            msgSend(self, NSSelectorFromString(@"reloadInputViews"));
            *stop = YES;
        }
    }];
}

- (NSMutableDictionary<NSString *, id> *)zh_themeTextAttributesDict {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeUpdateForTextAttributes)];
}

- (void)zh_themeUpdateForTextAttributes { // for textAttributes
    [self.zh_themeTextAttributesDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,id> * _Nonnull dictionary, BOOL * _Nonnull stop) {
        NSMutableDictionary* (^calls)(NSDictionary *) = ^(NSDictionary *dict){
            __block NSMutableDictionary *textAttrs = [dict mutableCopy];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[zhThemePicker class]]) {
                    textAttrs[key] = zh_getThemePickerValue(obj);
                }
            }];
            return textAttrs;
        };

        NSScanner *scan = [NSScanner scannerWithString:key];
        NSInteger var;
        if ([scan scanInteger:&var] && [scan isAtEnd]) {
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSString *, id> * _Nonnull dict, BOOL * _Nonnull stop) {
                void(*msgSend)(id, SEL, NSDictionary*, NSInteger) = (void(*)(id, SEL, NSDictionary*, NSInteger))objc_msgSend;
                msgSend(self, NSSelectorFromString(selName), calls(dict), [key integerValue]);
            }];
        } else {
            void(*msgSend)(id, SEL, NSDictionary*) = (void(*)(id, SEL, NSDictionary*))objc_msgSend;
            msgSend(self, NSSelectorFromString(key), calls(dictionary));
        }
    }];
}

- (NSMutableDictionary<NSString *,id> *)zh_themeMethodStateDict {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeUpdateForMethodState)];
}

- (void)zh_themeUpdateForMethodState { // for picker. with state
    void(*msgSend)(id, SEL, id, NSInteger) = (void(*)(id, SEL, id, NSInteger))objc_msgSend;
    [self.zh_themeMethodStateDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,zhThemePicker *> * _Nonnull dictionary, BOOL * _Nonnull stop) {
        NSInteger state = [key integerValue];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, zhThemePicker * _Nonnull picker, BOOL * _Nonnull stop) {
            id value = zh_getThemePickerValue(picker);
            if (picker.valueType == zhThemeValueTypeColor) {
                if ([(zhThemeColorPicker *)picker isAnimated]) {
                    [UIView animateWithDuration:ThemeManager.themeColorChangeInterval animations:^{
                        msgSend(self, NSSelectorFromString(selName), value, state);
                    }];
                } else {
                    msgSend(self, NSSelectorFromString(selName), value, state);
                }
            } else {
                msgSend(self, NSSelectorFromString(selName), value, state);
            }
        }];
    }];
}

////// for external custom object/ medthod //////
- (NSMutableDictionary<NSString *,id> *)zh_themeForExternalDict {
    return [self zh_themeAddListener:_cmd sel:@selector(zh_themeUpdateForExternal)];
}

/*
 NSInvocation is much slower than objc_msgSend()...
 Do not use it if you have performance issues.
 */
#define __INV_INVOKE(sel) \
NSMethodSignature *sig = [self methodSignatureForSelector:sel]; \
if (!sig) { [self doesNotRecognizeSelector:sel]; } \
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig]; \
if (!inv) { [self doesNotRecognizeSelector:sel];} \
[inv setTarget:self]; \
[inv setSelector:sel]; \
NSUInteger count = [sig numberOfArguments];

#define __CONVERT_SET(type, format) \
switch (type) { \
case 'B': case 'c': case 'i': case 'I': case 'l': case 'L': { \
int value = [format intValue]; \
[inv setArgument:&value atIndex:index]; \
} break; \
case 'q': case 'Q': { \
long long value = [format longLongValue]; \
[inv setArgument:&value atIndex:index]; \
} break; \
case 'f': case 'd': case 'D': { \
double value = [format doubleValue]; \
[inv setArgument:&value atIndex:index]; \
} break; \
case '@': { \
if ([format isKindOfClass:[zhThemePicker class]]) { \
zhThemePicker *picker = (zhThemePicker *)format; \
id value = zh_getThemePickerValue(picker); \
[inv setArgument:&value atIndex:index]; \
} else { \
[inv setArgument:&format atIndex:index]; \
} \
} break; \
case '{': { \
if ([format isKindOfClass:[NSValue class]]) { \
const char *_objcType = [format objCType]; \
if (strcmp(_objcType, @encode(CGPoint)) == 0) { \
CGPoint value = [format CGPointValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(CGSize)) == 0) { \
CGSize value = [format CGSizeValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(CGRect)) == 0) { \
CGRect value = [format CGRectValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(CGVector)) == 0) { \
CGVector value = [format CGVectorValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(CGAffineTransform)) == 0) { \
CGAffineTransform value = [format CGAffineTransformValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(CATransform3D)) == 0) { \
CATransform3D value = [format CATransform3DValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(NSRange)) == 0) { \
NSRange value = [format rangeValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(UIOffset)) == 0) { \
UIOffset value = [format UIOffsetValue]; \
[inv setArgument:&value atIndex:index]; \
} else if (strcmp(_objcType, @encode(UIEdgeInsets)) == 0) { \
UIEdgeInsets value = [format UIEdgeInsetsValue]; \
[inv setArgument:&value atIndex:index]; \
} else {} \
} else { \
[inv setArgument:&format atIndex:index]; \
} \
} break; \
default: break;}

#define __INFO_SET(obj) \
NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init]; \
[mutableDictionary setObject:obj forKey:@"_spValue"]; \
[mutableDictionary setObject:[NSNumber numberWithChar:*type] forKey:@"_spType"]; \
[paramInfo setObject:mutableDictionary forKey:@(index)];

- (void)zh_addThemePickerForSelector:(SEL)sel withArguments:(id)arguments, ... {
    __INV_INVOKE(sel)
    va_list args;
    va_start(args, arguments);
    NSMutableDictionary<NSNumber *, NSMutableDictionary *> *paramInfo =[NSMutableDictionary dictionary];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        if (2 == index) {
            __CONVERT_SET(*type, arguments)
            __INFO_SET(arguments)
        } else {
            switch (*type) { // parameter type  // NSNumber -> base type
                case 'B': case 'c': case 'i': case 'I': case 'l': case 'L': { // 'bool' 'char / BOOL' 'short' 'int' ... -> int
                    int arg = [va_arg(args, NSNumber *) intValue];
                    [inv setArgument:&arg atIndex:index];
                    __INFO_SET([NSNumber numberWithInt:arg])
                } break;
                case 'q': case 'Q': { // 'long long' 'unsigned long' 'NSInteger' ... -> long long
                    long long arg = [va_arg(args, NSNumber*) longLongValue];
                    [inv setArgument:&arg atIndex:index];
                    __INFO_SET([NSNumber numberWithLongLong:arg])
                } break;
                case 'f': case 'd': case 'D': { // 'float' 'CGFloat' 'long double'... -> double
                    double arg = [va_arg(args, NSNumber *) doubleValue];
                    [inv setArgument:&arg atIndex:index];
                    __INFO_SET([NSNumber numberWithDouble:arg])
                } break;
                case '@': {
                    id arg = va_arg(args, id);
                    if ([arg isKindOfClass:[zhThemePicker class]]) {
                        id value = zh_getThemePickerValue(arg);
                        [inv setArgument:&value atIndex:index];
                    } else {
                        [inv setArgument:&arg atIndex:index];
                    }
                    __INFO_SET(arg)
                } break;
                case '{': { // struct
                    if (strcmp(type, @encode(CGPoint)) == 0) {
                        CGPoint arg = [va_arg(args, NSValue *) CGPointValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCGPoint:arg])
                    } else if (strcmp(type, @encode(CGSize)) == 0) {
                        CGSize arg = [va_arg(args, NSValue *) CGSizeValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCGSize:arg])
                    } else if (strcmp(type, @encode(CGRect)) == 0) {
                        CGRect arg = [va_arg(args, NSValue *) CGRectValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCGRect:arg])
                    } else if (strcmp(type, @encode(CGVector)) == 0) {
                        CGVector arg = [va_arg(args, NSValue *) CGVectorValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCGVector:arg])
                    } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                        CGAffineTransform arg = [va_arg(args, NSValue *) CGAffineTransformValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCGAffineTransform:arg])
                    } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                        CATransform3D arg = [va_arg(args, NSValue *) CATransform3DValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithCATransform3D:arg])
                    } else if (strcmp(type, @encode(NSRange)) == 0) {
                        NSRange arg = [va_arg(args, NSValue *) rangeValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithRange:arg])
                    } else if (strcmp(type, @encode(UIOffset)) == 0) {
                        UIOffset arg = [va_arg(args, NSValue *) UIOffsetValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithUIOffset:arg])
                    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                        UIEdgeInsets arg = [va_arg(args, NSValue *) UIEdgeInsetsValue];
                        [inv setArgument:&arg atIndex:index];
                        __INFO_SET([NSValue valueWithUIEdgeInsets:arg])
                    } else {}
                } break;
                default: {
                    [ThemeManager debugLog:@"Unsupported type : %c", *type];
                } break;
            }
        }
    }
    va_end(args);
    [inv invoke];
    NSMutableDictionary *objects = [self valueForKey:@"zh_themeForExternalDict"];
    [objects setObject:paramInfo forKey:NSStringFromSelector(sel)];
}

- (void)zh_themeUpdateForExternal {
    [self.zh_themeForExternalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selName, NSDictionary<NSNumber *, NSMutableDictionary *> * _Nonnull dict, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selName);
        __INV_INVOKE(sel)
        for (int index = 2; index < count; index++) {
            NSDictionary *info = [dict objectForKey:@(index)];
            char _type = [[info objectForKey:@"_spType"] charValue];
            id _format = [info objectForKey:@"_spValue"];
            __CONVERT_SET(_type, _format)
        }
        [inv invoke];
    }];
}

@end

@implementation NSObject (zhThemeSwizzling)

+ (void)load {
    Class class = [self class];
    SEL originalSelector = NSSelectorFromString(@"dealloc");
    SEL swizzledSelector = @selector(zh_themeDealloc);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zh_themeDealloc {
    if ([self zh_themeNotificationMarker]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:zhThemeUpdateNotification object:nil];
    }
    [self zh_themeDealloc];
}

@end
