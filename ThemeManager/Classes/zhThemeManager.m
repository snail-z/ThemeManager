//
//  zhThemeManager.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeManager.h"

@implementation zhThemeManager (helper)

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

+ (UIColor *)colorWithString:(NSString *)hexString {
    NSString *hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"]) hex = [hex substringFromIndex:1];
    if (hex.length == 6) {
        hex = [hex stringByAppendingString:@"FF"];
    } else if (hex.length != 8) return nil;
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [UIColor colorWithRed:((rgba >> 24)&0xFF) / 255. green:((rgba >> 16)&0xFF) / 255. blue:((rgba >> 8)&0xFF) / 255. alpha:(rgba&0xFF) / 255.];
}

+ (void)debugLog:(NSString *)description, ... {
    if (!ThemeManager.debugLogEnabled || !description) return;
    va_list args;
    va_start(args, description);
    NSString *message = [[NSString alloc] initWithFormat:description locale:[NSLocale currentLocale] arguments:args];
    va_end(args);
    NSLog(@"** zhThemeManager ** %@", message);
}

@end


NSString * const zhThemeUpdateNotification = @"zh.theme.update.notification";
static NSString * const zhThemeStyleStorageKey = @"zhThemeStyleStorageKey";
static NSString * const zhThemeImageResourcePathStorageKey = @"zhThemeImageResourcePathStorageKey";
static NSString * const zhThemeMainBundleKey = @"@(MAINBUNDLE)";
static NSString * const zhThemeSandboxKey = @"@(SANDBOX)";
static NSString * const zhThemeColorKey = @"COLOR";
static NSString * const zhThemeImageKey = @"IMAGE";

@interface zhThemeManager ()

@property (nonatomic, copy) NSMutableDictionary<NSString *, NSString *> *themePaths;
@property (nonatomic, copy) NSMutableDictionary<NSString *, NSDictionary *> *themeLibraries;
@property (nonatomic, copy) NSMutableDictionary<NSString *, UIColor *> *cacheColorLibraries;
@property (nonatomic, copy) NSMutableDictionary<NSString *, UIImage *> *cacheImageLibraries;

@end

@implementation zhThemeManager

+ (instancetype)sharedManager {
    static zhThemeManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeManager alloc] init];
        instance.debugLogEnabled = NO;
        instance.transitionInterval = 0.25;
    });
    return instance;
}

- (NSMutableDictionary<NSString *,UIColor *> *)cacheColorLibraries {
    if (!_cacheColorLibraries) {
        _cacheColorLibraries = [NSMutableDictionary dictionary];
    }
    return _cacheColorLibraries;
}

- (NSMutableDictionary<NSString *,UIImage *> *)cacheImageLibraries {
    if (!_cacheImageLibraries) {
        _cacheImageLibraries = [NSMutableDictionary dictionary];
    }
    return _cacheImageLibraries;
}

- (NSMutableDictionary<NSString *,NSString *> *)themePaths {
    if (!_themePaths) {
        _themePaths = [NSMutableDictionary dictionary];
    }
    return _themePaths;
}

- (NSMutableDictionary<NSString *,NSDictionary *> *)themeLibraries {
    if (!_themeLibraries) {
        _themeLibraries = [NSMutableDictionary dictionary];
    }
    return _themeLibraries;
}

#pragma mark - Setter

- (void)setThemeInfoFilePath:(NSString *)themeInfoFilePath {
    NSParameterAssert(themeInfoFilePath != nil);
    _themeInfoFilePath = themeInfoFilePath;
    [self clearAllLibraries];
}

@synthesize style = _style;

- (NSString *)style {
    if (!_style) {
        _style = [[NSUserDefaults standardUserDefaults] stringForKey:zhThemeStyleStorageKey];
    }
    return _style;
}

- (void)updateThemeStyle:(NSString *)style {
    if (!style || [self.style isEqualToString:style]) return;
    _style = style;
    [[NSUserDefaults standardUserDefaults] setObject:style forKey:zhThemeStyleStorageKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)setImageResourcePath:(NSString *)imageResourcePath {
    if (imageResourcePath && [NSFileManager.defaultManager fileExistsAtPath:imageResourcePath]) {
        _imageResourcePath = imageResourcePath;
        [self.cacheImageLibraries removeAllObjects];
    }
}

#pragma mark - Cache

- (void)clearAllLibraries {
    [self.themeLibraries removeAllObjects];
    [self.cacheColorLibraries removeAllObjects];
    [self.cacheImageLibraries removeAllObjects];
}

- (NSDictionary *)dictionaryWithFilePath:(NSString *)path {
    NSDictionary *dict = nil;
    if ([path.pathExtension isEqualToString:@"plist"]) {
        dict = [NSDictionary dictionaryWithContentsOfFile:path];
    } else if ([path.pathExtension isEqualToString:@"json"]) {
        NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        id obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSAssert1([obj isKindOfClass:[NSDictionary class]],
                  @"Invalid format of the file content: (%@)", path);
        dict = (NSDictionary *)obj;
    }
    if (dict) return [self trimmingKeyWithDictionary:dict];
    return nil;
}

- (NSDictionary *)trimmingKeyWithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *triKey = [key stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        [dictionary setValue:obj forKey:triKey.uppercaseString];
    }];
    return dictionary;
}

- (NSDictionary<NSString *,NSDictionary *> *)librariesForKey:(NSString *)styleKey {
    NSDictionary *libs = [self.themeLibraries objectForKey:styleKey];
    if (libs) return libs;

    NSDictionary *dict = [self dictionaryWithFilePath:self.themeInfoFilePath];
    id obj = [dict objectForKey:styleKey];
    if (!obj || ![obj isKindOfClass:[NSArray class]]) {
        [zhThemeManager debugLog:@"!!! 请检查配置文件内容或Key值是否合法：\nKey = %@\nPath = %@ \nInfo = %@", styleKey, self.themeInfoFilePath, dict];
        return nil;
    }

    NSString *path = nil;
    NSEnumerator *e = [(NSArray *)obj reverseObjectEnumerator];
    NSString *next = nil; NSString *prefix = nil;
    
    while (next = [e nextObject]) {
        NSUInteger loc = [next rangeOfString:@"/"].location;
        prefix = next;
        if (!loc || !next || next.length < 3) continue;
        
        id prefix = next.pathComponents.firstObject;
        NSString *res = [prefix stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString;
        
        if ([res isEqualToString:zhThemeMainBundleKey]) {
            path = [[NSBundle mainBundle].bundlePath stringByAppendingString:[next substringFromIndex:loc]];
            break;
        }
        
        if ([res isEqualToString:zhThemeSandboxKey]) {
            path = [NSHomeDirectory() stringByAppendingString:[next substringFromIndex:loc]];
            break;
        }
    }
    
    if (!path) {
        [zhThemeManager debugLog:@"!!! 请使用 @(MAINBUNDLE) 或 @(SANDBOX) 前缀标记路径位置：%@", prefix];
        return nil;
    }
    
    libs = [self dictionaryWithFilePath:path];
    if (!libs) {
        [zhThemeManager debugLog:@"!!! 未能在该路径下找到配置文件：%@", path];
        return nil;
    }
    
    [self.themeLibraries setObject:libs forKey:styleKey];
    [self.themePaths setObject:path forKey:styleKey];
    return libs;
}

- (NSString *)pathForKey:(NSString *)styleKey {
    NSString *path = [self.themePaths objectForKey:styleKey];
    if (path) return path;
    
    [self librariesForKey:styleKey];
    return [self.themePaths objectForKey:styleKey];
}

- (UIColor *)colorForKey:(NSString *)aKey {
    NSDictionary *libs = [self librariesForKey:self.style];
    NSString *path = [self pathForKey:self.style];
    if (![libs.allKeys containsObject:zhThemeColorKey]) {
        [zhThemeManager debugLog:@"未在配置文件中找到固定键值'COLOR' \npath = %@", path];
        return nil;
    }
    
    id value = [libs[zhThemeColorKey] objectForKey:aKey];
    if (!value || ![value isKindOfClass:[NSString class]]) {
        [zhThemeManager debugLog:@"请检查配置文件颜色表中的键值对是否正确！\npath = %@ \nkey = %@ \nvalue = %@", path, aKey, value];
        return nil;
    }
    return [zhThemeManager colorWithString:value];
}

- (NSString *)colorCacheKeyWithKey:(NSString *)aKey {
    NSDictionary *libs = [self librariesForKey:self.style];
    return [libs[zhThemeColorKey] objectForKey:aKey];
}

- (UIColor *)cacheColorForKey:(NSString *)aKey {
    NSString *cacheKey = [self colorCacheKeyWithKey:aKey];
    UIColor *color = [self.cacheColorLibraries objectForKey:cacheKey];
    if (color) return color;
    color = [self colorForKey:aKey];
    if (color) [self.cacheColorLibraries setObject:color forKey:cacheKey];
    return color;
}

- (UIImage *)imageForKey:(NSString *)aKey {
    NSDictionary *libs = [self librariesForKey:self.style];
    NSString *path = [self pathForKey:self.style];
    if (![libs.allKeys containsObject:zhThemeImageKey]) {
        [zhThemeManager debugLog:@"未在配置文件中找到固定键值'IMAGE' \npath = %@", path];
        return nil;
    }
    
    id value = [libs[zhThemeImageKey] objectForKey:aKey];
    if (!value || ![value isKindOfClass:[NSString class]]) {
        [zhThemeManager debugLog:@"请检查配置文件图片表中的键值对是否正确！\npath = %@ \nkey = %@ \nvalue = %@", path, aKey, value];
        return nil;
    }
    
    if (self.imageResourcePath) {
        NSString *fullPath = [[self.imageResourcePath stringByAppendingString:@"/"] stringByAppendingPathComponent:value];
        return [UIImage imageWithContentsOfFile:fullPath];
    } else {
        NSString *name = (NSString *)value;
        NSString *e = name.pathExtension;
        if (e.length == 0) e = @"png";
        else name = name.stringByDeletingPathExtension;
        NSString *path = [zhThemeManager pathForScaledResource:name ofType:e inBundle:[NSBundle mainBundle]];
        return [UIImage imageWithContentsOfFile:path];
    }
}

- (NSString *)imageCacheKeyWithKey:(NSString *)aKey {
    NSDictionary *libs = [self librariesForKey:self.style];
    return [libs[zhThemeImageKey] objectForKey:aKey];
}

- (UIImage *)cacheImageForKey:(NSString *)aKey {
    NSString *cacheKey = [self imageCacheKeyWithKey:aKey];
    UIImage *image = [self.cacheImageLibraries objectForKey:cacheKey];
    if (image) return image;
    image = [self imageForKey:aKey];
    if (image) [self.cacheImageLibraries setObject:image forKey:cacheKey];
    return image;
}

@end
