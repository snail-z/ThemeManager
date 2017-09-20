//
//  zhThemePicker.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemePicker.h"
#import "zhThemeManager.h"
#import "zhThemeFiles.h"

#ifndef __OPTIMIZE__
#define zhThemeDebugLog(s, ...) NSLog(@"\n =======> [%@ in line %d] ** zhTheme Warning ** %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define zhThemeDebugLog(...) {}
#endif

@implementation NSString (zhThemeImageHelper)

- (NSString *)stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

@end

@interface zhThemeHelper : NSObject

+ (UIImage *)imageNamed:(NSString *)name place:(id)place;
+ (UIImage *)imageFromCheck:(id)object;
+ (UIColor *)colorFromCheck:(id)object;

@end

@implementation zhThemeHelper

+ (UIImage *)imageNamed:(NSString *)name atPath:(NSString *)path {
    NSString *fullPath = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fullPath];
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    else name = name.stringByDeletingPathExtension;
    NSString *path = [self pathForScaledResource:name ofType:ext inBundle:bundle];
    // todo... cache
    return [UIImage imageWithContentsOfFile:path];
}

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

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inBundle:(NSBundle *)bundle {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [bundle pathForResource:name ofType:ext];
    NSString *path = nil;
    NSArray *scales = [self preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [bundle pathForResource:scaledName ofType:ext];
        if (path) break;
    }
    return path;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString) return nil;
    NSString* hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    if (hex.length == 6)
        hex = [hex stringByAppendingString:@"FF"];
    else if (hex.length != 8) return nil;
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    UIColor *color = [UIColor colorWithRed:((rgba >> 24)&0xFF) / 255. green:((rgba >> 16)&0xFF) / 255. blue:((rgba >> 8)&0xFF) / 255. alpha:(rgba&0xFF) / 255.];
    return color;
}

+ (UIImage *)imageNamed:(NSString *)name place:(id)place {
    if ([place isKindOfClass:[NSBundle class]]) {
        return [self imageNamed:name inBundle:place];
    }
    return [self imageNamed:name atPath:place];
}

+ (UIImage *)imageFromCheck:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return [UIImage imageNamed:(NSString *)object];
    } else if ([object isKindOfClass:[UIImage class]]) {
        return (UIImage *)object;
    } else if ([object isKindOfClass:[NSData class]]) {
        return [UIImage imageWithData:(NSData *)object];
    }
    return nil;
}

+ (UIColor *)colorFromCheck:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return [self colorFromHexString:object];
    } else if ([object isKindOfClass:[UIColor class]]) {
        return (UIColor *)object;
    }
    return nil;
}

@end

@interface zhThemePicker ()

@property (nonatomic, strong, readonly) NSString *pkey;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *pDict;
@property (nonatomic, assign, readonly) BOOL isAnimated;
@property (nonatomic, assign, readonly) UIImageRenderingMode isImgRenderingMode;
@end

@implementation zhThemePicker

+ (instancetype)pickerWithKey:(NSString *)pKey {
    return [[self alloc] initWithKey:pKey dict:nil];
}

+ (instancetype)pickerWithDict:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (instancetype)initWithKey:(NSString *)key dict:(NSDictionary *)dict {
    if (self = [super init]) {
        _isImgRenderingMode = -1;
        _isAnimated = YES;
        _pkey = key;
        _pDict = dict;
    }
    return self;
}

- (zhThemePicker *(^)(UIImageRenderingMode))imageRenderingMode {
    return ^id(UIImageRenderingMode renderingMode) {
        _isImgRenderingMode = renderingMode;
        return self;
    };
}

- (zhThemePicker *(^)(BOOL))animated {
    return ^id(BOOL animated) {
        _isAnimated = animated;
        return self;
    };
}

@end

@implementation zhThemePicker (CurrentTheme)

- (NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSString *> *>*)getColorSources {
    return [zhThemeFiles.defaultManager valueForKey:@"colorSources"];
}

- (NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSString *> *>*)getImageSources {
    return [zhThemeFiles.defaultManager valueForKey:@"imageSources"];
}

- (id)getImagePlace {
    return [zhThemeFiles.defaultManager valueForKey:@"imagesPlace"];
}

- (UIColor *)themeColor {
    if (self.pDict) {
        if ([self.pDict.allKeys containsObject:ThemeManager.currentStyle]) {
            id object = self.pDict[ThemeManager.currentStyle];
            return [zhThemeHelper colorFromCheck:object];
        }
        zhThemeDebugLog(@"Not found key (%@) in dict: %@", ThemeManager.currentStyle, self.pDict);
    } else {
        NSDictionary *dict = [self getColorSources];
        if ([dict.allKeys containsObject:self.pkey]) {
            // No judgment type. must be NSDictionary class.
            id value = [dict[self.pkey] objectForKey:ThemeManager.currentStyle];
            UIColor *color = [zhThemeHelper colorFromCheck:value];
            if (!color) zhThemeDebugLog(@"Not hexadecimal color code. %@", value);
            return color;
        }
        zhThemeDebugLog(@"Not found key (%@) in color profile: %@", self.pkey, [zhThemeFiles.defaultManager valueForKey:@"colorFile"]);
    }
    return nil;
}

- (UIImage *)themeImage {
    if (self.pDict) {
        if ([self.pDict.allKeys containsObject:ThemeManager.currentStyle]) {
            UIImage *image = [zhThemeHelper imageFromCheck:self.pDict[ThemeManager.currentStyle]];
            if (self.isImgRenderingMode < 0) return image;
            return [image imageWithRenderingMode:self.isImgRenderingMode];
        }
        zhThemeDebugLog(@"Not found key (%@) in dict: %@", ThemeManager.currentStyle, self.pDict);
        return nil;
    } else {
        NSDictionary *dict = [self getImageSources];
        if ([dict.allKeys containsObject:self.pkey]) {
            // No judgment type. must be NSDictionary class.
            id value = [dict[self.pkey] objectForKey:ThemeManager.currentStyle];
            UIImage *image = nil;
            if ([self getImagePlace]) image = [zhThemeHelper imageNamed:value place:self.getImagePlace];
            else image = [zhThemeHelper imageFromCheck:value];
            if (self.isImgRenderingMode < 0) return image;
            return [image imageWithRenderingMode:self.isImgRenderingMode];
        }
        zhThemeDebugLog(@"Not found key (%@) in image profile: %@", self.pkey, [zhThemeFiles.defaultManager valueForKey:@"imageFile"]);
    }
    return nil;
}

- (UIFont *)themeFont {
    if (self.pDict) {
        if ([self.pDict.allKeys containsObject:ThemeManager.currentStyle]) {
            id object = self.pDict[ThemeManager.currentStyle];
            if ([object isKindOfClass:[UIFont class]]) return (UIFont *)object;
        }
        zhThemeDebugLog(@"Not found key (%@) in dict: %@", ThemeManager.currentStyle, self.pDict);
    }
    return [UIFont systemFontOfSize:UIFont.systemFontSize];
}

- (NSNumber *)themeDouble {
    if (self.pDict) {
        if ([self.pDict.allKeys containsObject:ThemeManager.currentStyle]) {
            id object = self.pDict[ThemeManager.currentStyle];
            if ([object isKindOfClass:[NSNumber class]]) return object;
        }
        zhThemeDebugLog(@"Not found key (%@) in dict: %@", ThemeManager.currentStyle, self.pDict);
    }
    return @1.0;
}

@end
