//
//  zhThemeImagePicker.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemePicker.h"

@interface zhThemePickerHelper : NSObject
@end
@implementation zhThemePickerHelper

+ (NSArray *)preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1, @2, @3];
        } else if (screenScale <= 2) {
            scales = @[@2, @3, @1];
        } else {
            scales = @[@3, @2, @1];
        }
    });
    return scales;
}

+ (NSString *)stringByAppendingNameScale:(CGFloat)scale forString:(NSString *)string {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}

+ (NSString *)stringByAppendingPathScale:(CGFloat)scale forString:(NSString *)string {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    NSString *ext = string.pathExtension;
    NSRange extRange = NSMakeRange(string.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [string stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inBundle:(NSBundle *)bundle {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [bundle pathForResource:name ofType:ext];
    NSString *path = nil;
    NSArray *scales = [self preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [self stringByAppendingNameScale:scale forString:name]
        : [self stringByAppendingPathScale:scale forString:name];
        path = [bundle pathForResource:scaledName ofType:ext];
        if (path) break;
    }
    return path;
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    else name = name.stringByDeletingPathExtension;
    NSString *path = [self pathForScaledResource:name ofType:ext inBundle:bundle];
    return [UIImage imageWithContentsOfFile:path]; // todo... cache
}

+ (UIImage *)imageNamed:(NSString *)name inPath:(NSString *)path {
    NSString *fullPath = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fullPath];
}

// source => bundle or path
+ (UIImage *)imageNamed:(NSString *)name from:(id)from {
    if ([from isKindOfClass:[NSBundle class]]) {
        return [self imageNamed:name inBundle:from];
    } else if ([from isKindOfClass:[NSString class]]) {
        return [self imageNamed:name inPath:from];
    } else return nil;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString) return nil;
    NSString *hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"]) hex = [hex substringFromIndex:1];
    if (hex.length == 6) {
        hex = [hex stringByAppendingString:@"FF"];
    } else if (hex.length != 8) return nil;
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [UIColor colorWithRed:((rgba >> 24)&0xFF) / 255. green:((rgba >> 16)&0xFF) / 255. blue:((rgba >> 8)&0xFF) / 255. alpha:(rgba&0xFF) / 255.];;
}

+ (UIColor *)colorCheck:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        return [self colorFromHexString:obj];
    } else if ([obj isKindOfClass:[UIColor class]]) {
        return (UIColor *)obj;
    } else return nil;
}

+ (UIImage *)imageCheck:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        return [UIImage imageNamed:(NSString *)obj];
    } else if ([obj isKindOfClass:[UIImage class]]) {
        return (UIImage *)obj;
    } else if ([obj isKindOfClass:[NSData class]]) {
        return [UIImage imageWithData:(NSData *)obj];
    } else return nil;
}

@end


@interface zhThemePicker ()

@property (nonatomic, strong, readonly) NSString *pkey;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *pDict;

@end

@implementation zhThemePicker

- (instancetype)initWithKey:(NSString *)key
                       dict:(NSDictionary *)dict
                  valueType:(zhThemeValueType)valueType {
    if (self = [super init]) {
        _pkey = key;
        _pDict = dict;
        _valueType = valueType;
    }
    return self;
}

+ (instancetype)pickerWithKey:(NSString *)pKey {
    NSAssert1(0, @"%@ This method should be handed to the subclass call!", NSStringFromSelector(_cmd));
    return [[self alloc] init];
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    NSAssert1(0, @"%@ This method should be handed to the subclass call!", NSStringFromSelector(_cmd));
    return [[self alloc] init];
}

@end

@implementation zhThemeColorPicker

+ (instancetype)pickerWithKey:(NSString *)pKey {
    return [[self alloc] initWithKey:pKey dict:nil valueType:zhThemeValueTypeColor];
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict valueType:zhThemeValueTypeColor];
}

- (zhThemeColorPicker *(^)(BOOL))animated {
    return ^id(BOOL isAnimated) {
        _isAnimated = isAnimated;
        return self;
    };
}

- (UIColor *)color {
    UIColor* (^callback)(NSDictionary *) = ^(NSDictionary *dict) {
        UIColor *value = nil;
        NSString *currentKey = ThemeManager.currentStyle;
        if ([dict.allKeys containsObject:currentKey]) {
            value = [zhThemePickerHelper colorCheck:dict[currentKey]];
        }
        if (!value) {
            [ThemeManager debugLog:@"Not found key (%@) in dict: %@", currentKey, dict];
        }
        return value;
    };
    
    if (self.pDict) {
        return callback(self.pDict);
    }
    
    NSDictionary<NSString *, NSDictionary *> *dict = ThemeManager.colorLibraries;
    if (![dict.allKeys containsObject:self.pkey]) return nil;
    return callback(dict[self.pkey]);
}

@end

@implementation zhThemeImagePicker

- (instancetype)initWithKey:(NSString *)key
                       dict:(NSDictionary *)dict
                  valueType:(zhThemeValueType)valueType {
    _imageRenderingMode = -1;
    return [super initWithKey:key dict:dict valueType:valueType];
}

+ (instancetype)pickerWithKey:(NSString *)pKey {
    return [[self alloc] initWithKey:pKey dict:nil valueType:zhThemeValueTypeImage];
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict valueType:zhThemeValueTypeImage];
}

- (zhThemeImagePicker *(^)(UIImageRenderingMode))renderingMode {
    return ^id(UIImageRenderingMode imageRenderingMode) {
        _imageRenderingMode = imageRenderingMode;
        return self;
    };
}

- (zhThemeImagePicker *(^)(UIEdgeInsets))resizableCapInsets {
    return ^id(UIEdgeInsets imageCapInsets) {
        _imageCapInsets = imageCapInsets;
        return self;
    };
}

- (UIImage *)image {
    UIImage* (^callback)(NSDictionary *) = ^(NSDictionary *dict) {
        UIImage *value = nil;
        NSString *currentKey = ThemeManager.currentStyle;
        if ([dict.allKeys containsObject:currentKey]) {
            id obj = [dict objectForKey:currentKey];
            UIImage *placeImage = [zhThemePickerHelper imageNamed:obj from:ThemeManager.pathOfImageSources];
            if (placeImage) value = placeImage;
            else value = [zhThemePickerHelper imageCheck:obj];
            if (value) {
                if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, _imageCapInsets)) {
                    value = [value resizableImageWithCapInsets:_imageCapInsets];
                }
                if (_imageRenderingMode >= 0) {
                    value = [value imageWithRenderingMode:_imageRenderingMode];
                }
            }
        }
        if (!value) {
            [ThemeManager debugLog:@"Not found key (%@) in dict: %@", currentKey, dict];
        }
        return value;
    };
    
    if (self.pDict) {
        return callback(self.pDict);
    }
    
    NSDictionary<NSString *, NSDictionary *> *dict = ThemeManager.imageLibraries;
    if (![dict.allKeys containsObject:self.pkey]) return nil;
    return callback(dict[self.pkey]);
}

@end

@implementation zhThemeFontPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict valueType:zhThemeValueTypeFont];
}

- (UIFont *)font {
    UIFont* (^callback)(NSDictionary *) = ^(NSDictionary *dict) {
        UIFont *value = [UIFont systemFontOfSize:UIFont.systemFontSize];
        NSString *currentKey = ThemeManager.currentStyle;
        if ([dict.allKeys containsObject:currentKey]) {
            id obj = [dict objectForKey:currentKey];
            if ([obj isKindOfClass:[UIFont class]]) value = obj;
        }
        if (!value) {
            [ThemeManager debugLog:@"Not found key (%@) in dict: %@", currentKey, dict];
        }
        return value;
    };
    
    if (self.pDict) {
        return callback(self.pDict);
    }
    return nil;
}

@end

@implementation zhThemeTextPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict valueType:zhThemeValueTypeText];
}

- (NSString *)text {
    NSString* (^callback)(NSDictionary *) = ^(NSDictionary *dict) {
        NSString *value = nil;
        NSString *currentKey = ThemeManager.currentStyle;
        if ([dict.allKeys containsObject:currentKey]) {
            id obj = [dict objectForKey:currentKey];
            if ([obj isKindOfClass:[NSString class]]) value = obj;
        }
        if (!value) {
            [ThemeManager debugLog:@"Not found key (%@) in dict: %@", currentKey, dict];
        }
        return value;
    };
    
    if (self.pDict) {
        return callback(self.pDict);
    }
    return nil;
}

@end

@implementation zhThemeNumberPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict valueType:zhThemeValueTypeNumber];
}

- (NSNumber *)number {
    NSNumber* (^callback)(NSDictionary *) = ^(NSDictionary *dict) {
        NSNumber *value = [NSNumber numberWithDouble:1.f];
        NSString *currentKey = ThemeManager.currentStyle;
        if ([dict.allKeys containsObject:currentKey]) {
            id obj = [dict objectForKey:currentKey];
            if ([obj isKindOfClass:[NSNumber class]]) value = obj;
        }
        if (!value) {
            [ThemeManager debugLog:@"Not found key (%@) in dict: %@", currentKey, dict];
        }
        return value;
    };
    
    if (self.pDict) {
        return callback(self.pDict);
    }
    return nil;
}

@end
