//
//  zhThemeUtilities.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/11/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeUtilities.h"

// get picker. properties
id zh_getThemePicker(id instance, const void *key) {
    return objc_getAssociatedObject(instance, key);
}

// for obj properties.
void zh_setThemePicker(zhThemePicker *picker, id instance, NSString *propertyName) {
    NSString *pickerName = [NSString stringWithFormat:@"zh_%@Picker", propertyName];
    objc_setAssociatedObject(instance, NSSelectorFromString(pickerName), picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([instance isKindOfClass:[CALayer class]]) { // CGColorRef
        if (picker.valueType == zhThemeValueTypeColor) {
            id value = (__bridge id _Nullable)([(zhThemeColorPicker *)picker color].CGColor);
            [instance setValue:value forKeyPath:propertyName];
        }
    } else {
        id value = zh_getThemePickerValue(picker);
        [instance setValue:value forKeyPath:propertyName];
    }
    NSMutableDictionary *pickers = [instance valueForKey:@"zh_themePropertiesDict"];
    [pickers setObject:picker forKey:propertyName];
}

// for enumerations type. exp: keyboardAppearance / statusBarStyle
void zh_setThemeEnumerations(id instance, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict) {
    id obj = [dict objectForKey:ThemeManager.currentStyle];
    if ([obj isKindOfClass:[NSNumber class]]) {
        void(*msgSend)(id, SEL, NSInteger) = (void(*)(id, SEL, NSInteger))objc_msgSend;
        msgSend(instance, aSelector, [obj integerValue]);
        NSString *lowerName = NSStringFromSelector(aSelector).lowercaseString;
        if ([lowerName rangeOfString:@"keyboard"].location != NSNotFound) {
            void(*msgSend)(id, SEL) = (void(*)(id, SEL))objc_msgSend;
            msgSend(instance, NSSelectorFromString(@"reloadInputViews"));
        }
        NSMutableDictionary *dictionary = [instance valueForKey:@"zh_themeEnumerationsDict"];
        [dictionary setObject:dict forKey:NSStringFromSelector(aSelector)];
    }
}

// for textAttributes.
void zh_setThemeTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs) {
    __block NSMutableDictionary *textAttr = attrs.mutableCopy;
    [attrs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = zh_getThemePickerValue(obj);
        }
    }];
    void(*msgSend)(id, SEL, NSDictionary*) = (void(*)(id, SEL, NSDictionary*))objc_msgSend;
    msgSend(instance, aSelector, textAttr);
    NSMutableDictionary *attributes = [instance valueForKey:@"zh_themeTextAttributesDict"];
    [attributes setObject:attrs forKey:NSStringFromSelector(aSelector)];
}

// for textAttributes. with state
void zh_setThemeTextAttributesWithState(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs, NSInteger state) {
    __block NSMutableDictionary *textAttr = attrs.mutableCopy;
    [attrs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhThemePicker class]]) {
            textAttr[key] = zh_getThemePickerValue(obj);
        }
    }];
    void(*msgSend)(id, SEL, NSDictionary*, NSInteger) = (void(*)(id, SEL, NSDictionary*, NSInteger))objc_msgSend;
    msgSend(instance, aSelector, textAttr, state);
    NSMutableDictionary *attributes = [instance valueForKey:@"zh_themeTextAttributesDict"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, NSDictionary *> *dictionary = [attributes objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:attrs forKey:NSStringFromSelector(aSelector)];
    [attributes setObject:dictionary forKey:stateKey];
}

// for picker. with state
void zh_setThemePickerWithState(id instance, SEL aSelector, zhThemePicker *picker, NSInteger state) {
    id value = zh_getThemePickerValue(picker);
    void(*msgSend)(id, SEL, id, NSInteger) = (void(*)(id, SEL, id, NSInteger))objc_msgSend;
    msgSend(instance, aSelector, value, state);
    NSMutableDictionary *objects = [instance valueForKey:@"zh_themeMethodStateDict"];
    NSString *stateKey = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary<NSString *, zhThemePicker *> *dictionary = [objects objectForKey:stateKey];
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:picker forKey:NSStringFromSelector(aSelector)];
    [objects setObject:dictionary forKey:stateKey];
}

id zh_getThemePickerValue(zhThemePicker *picker) {
    switch (picker.valueType) {
        case zhThemeValueTypeColor:
            return [(zhThemeColorPicker *)picker color];
        case zhThemeValueTypeImage:
            return [(zhThemeImagePicker *)picker image];
        case zhThemeValueTypeFont:
            return [(zhThemeFontPicker *)picker font];
        case zhThemeValueTypeNumber:
            return [(zhThemeNumberPicker *)picker number];
        case zhThemeValueTypeText:
            return [(zhThemeTextPicker *)picker text];
        default: return nil;
    }
}

UIImage* zh_themeImageFromColor(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
