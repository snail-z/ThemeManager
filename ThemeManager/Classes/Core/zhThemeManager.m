//
//  zhThemeManager.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeManager.h"
#import <objc/runtime.h>

static void *zh_defaultStyleKey = &zh_defaultStyleKey;
static void *zh_defaultThemeColorFileKey = &zh_defaultThemeColorFileKey;
static void *zh_defaultThemeImageFileKey = &zh_defaultThemeImageFileKey;

NSString *const zhThemeFileModelStorageColorKey = @"zhTheme_storageColorFileKey";
NSString *const zhThemeFileModelStorageImageKey = @"zhTheme_storageImageFileKey";

typedef NS_ENUM(NSInteger, zhThemeFilePathType) {
    zhThemeFilePathTypeBundle = 0,
    zhThemeFilePathTypeSandbox,
    zhThemeFilePathTypeUnknown,
};

@interface zhThemeFileModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fixedPath;
@property (nonatomic, assign) zhThemeFilePathType pathType;
+ (instancetype)modelWithFixed:(NSString *)fixedPath pathType:(zhThemeFilePathType)pathType;

@end

@implementation zhThemeFileModel

+ (instancetype)modelWithFixed:(NSString *)fixedPath pathType:(zhThemeFilePathType)pathType {
    zhThemeFileModel *model = [zhThemeFileModel new];
    model.fixedPath = fixedPath;
    model.pathType = pathType;
    return model;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fixedPath forKey:@"fixedPath"];
    [aCoder encodeObject:@(self.pathType) forKey:@"pathType"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.fixedPath = [aDecoder decodeObjectForKey:@"fixedPath"];
        self.pathType = [[aDecoder decodeObjectForKey:@"pathType"] integerValue];
    }
    return self;
}

@end

@interface zhThemeFileManager : NSObject

@property (nonatomic, strong, nonnull) NSString *colorFile;
@property (nonatomic, strong, nonnull) NSString *imageFile;
@property (nonatomic, strong, nullable) NSString *imageSourcesPath;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSDictionary *>* colorDictionary;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSDictionary *>* imageDictionary;
@property (nonatomic, strong, nullable) id imageSources;

@end

@implementation zhThemeFileManager

+ (instancetype)defaultManager {
    static zhThemeFileManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeFileManager alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data1 = [userDefaults objectForKey:zhThemeFileModelStorageColorKey];
        NSData *data2 = [userDefaults objectForKey:zhThemeFileModelStorageImageKey];
        NSArray *storageKeys = [userDefaults dictionaryRepresentation].allKeys;

        if ([storageKeys containsObject:zhThemeFileModelStorageColorKey]) {
            // unarchive the value
            zhThemeFileModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            instance.colorFile = [instance fixedPathFromModel:model];
        } else {
            NSString *file = objc_getAssociatedObject(ThemeManager, zh_defaultThemeColorFileKey);
            [instance colorSourcesFromFile:file];
        }
        
        if ([storageKeys containsObject:zhThemeFileModelStorageImageKey]) {
            zhThemeFileModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
            instance.imageFile = [instance fixedPathFromModel:model];
        } else {
            NSString *file = objc_getAssociatedObject(ThemeManager, zh_defaultThemeImageFileKey);
            [instance imageSourcesFromFile:file];
        }
    });
    return instance;
}

- (NSString *)fixedPathFromModel:(zhThemeFileModel *)model {
    if (!model) return nil;
    switch (model.pathType) {
        case zhThemeFilePathTypeBundle:
            return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:model.fixedPath];
        case zhThemeFilePathTypeSandbox:
            return [NSHomeDirectory() stringByAppendingPathComponent:model.fixedPath];
        default:
            return model.fixedPath;
    }
}

- (zhThemeFileModel *)fileModelFromPath:(NSString *)fullPath {
    NSMutableString *path = fullPath.mutableCopy;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSRange range = [path rangeOfString:[NSBundle mainBundle].bundlePath];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFileModel modelWithFixed:path pathType:zhThemeFilePathTypeBundle];
        }
        range = [path rangeOfString:NSHomeDirectory()];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFileModel modelWithFixed:path pathType:zhThemeFilePathTypeSandbox];
        }
    }
    return [zhThemeFileModel modelWithFixed:path pathType:zhThemeFilePathTypeUnknown];
}

- (zhThemeFileModel *)imageSourcesFromFile:(NSString *)file {
    if (!file || [_imageFile isEqualToString:file]) return nil;
    _imageFile = file;
    zhThemeFileModel *model = [self fileModelFromPath:file];
    if (model.pathType == zhThemeFilePathTypeUnknown) {
        [ThemeManager debugLog:@"Files not exist: %@", file];
    }
    self.imageDictionary = [self parseWorkablePath:file].mutableCopy;
    return model;
}

- (zhThemeFileModel *)colorSourcesFromFile:(NSString *)file {
    if (!file || [_colorFile isEqualToString:file]) return nil;
    _colorFile = file;
    zhThemeFileModel *model = [self fileModelFromPath:file];
    if (model.pathType == zhThemeFilePathTypeUnknown) {
        [ThemeManager debugLog:@"Files not exist: %@", file];
    }
    self.colorDictionary = [self parseWorkablePath:file].mutableCopy;
    return model;
}

- (void)setColorFile:(NSString *)colorFile {
    zhThemeFileModel *model = [self colorSourcesFromFile:colorFile];
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeFileModelStorageColorKey];
    }
}

- (void)setImageFile:(NSString *)imageFile {
    zhThemeFileModel *model = [self imageSourcesFromFile:_imageFile];
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeFileModelStorageImageKey];
    }
}

- (void)setImageSourcesPath:(NSString *)imageResourcesPath {
    if (!imageResourcesPath) self.imageSources = nil;
    if ([_imageSourcesPath isEqualToString:imageResourcesPath]) return;
    _imageSourcesPath = imageResourcesPath;
    zhThemeFileModel *model = [self fileModelFromPath:imageResourcesPath];
    if (model.pathType == zhThemeFilePathTypeUnknown) {
        [ThemeManager debugLog:@"Resources path not exist: %@", imageResourcesPath];
    }
    NSString *path = [self fixedPathFromModel:model];
    self.imageSources = path;
    if (model.pathType == zhThemeFilePathTypeBundle) {
        self.imageSources = [NSBundle bundleWithPath:path];
    }
}

- (NSDictionary *)parseWorkablePath:(NSString *)path {
    NSDictionary *dict = nil;
    if ([path.pathExtension isEqualToString:@"plist"]) {
        dict = [NSDictionary dictionaryWithContentsOfFile:path];
    } else if ([path.pathExtension isEqualToString:@"json"]) {
        NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        id obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSAssert1([obj isKindOfClass:[NSDictionary class]], @"Invalid format of the file content: (%@)", path);
        dict = (NSDictionary *)obj;
    }
    if (dict) return [self trimmingKeyWithDict:dict];
    return nil;
}

- (NSDictionary *)trimmingKeyWithDict:(NSDictionary *)dict {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *triKey = [key stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        [dictionary setObject:obj forKey:triKey];
    }];
    return dictionary;
}

@end


NSNotificationName const zhThemeUpdateNotification = @"zh.theme.update.notification";
NSString *const zhThemeStyleStorageKey = @"zhThemeStyleStorageKey";

@implementation zhThemeManager

+ (instancetype)sharedManager {
    static zhThemeManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeManager alloc] init];
        instance.themeColorChangeInterval = 0.25;
    });
    return instance;
}

- (void)debugLog:(NSString *)description, ... {
    if (!description || !self.debugLogEnabled) return;
    va_list args;
    va_start(args, description);
    NSString *message = [[NSString alloc] initWithFormat:description locale:[NSLocale currentLocale] arguments:args];
    va_end(args);
    NSLog(@"** zhThemeManager ** %@", message);
}

- (void)reloadTheme {
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (BOOL)isEqualCurrentThemeStyle:(zhThemeStyleName)themeStyle {
    return [self.currentStyle isEqualToString:themeStyle];
}

- (zhThemeStyleName)currentStyle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *style = [userDefaults stringForKey:zhThemeStyleStorageKey];
    if (style) return style;
    return objc_getAssociatedObject(self, zh_defaultStyleKey);
}

- (void)setDefaultThemeStyle:(zhThemeStyleName)defaultStyle {
    objc_setAssociatedObject(self, zh_defaultStyleKey, defaultStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateThemeStyle:(zhThemeStyleName)style {
    if (!style || [self isEqualCurrentThemeStyle:style]) return;
    [[NSUserDefaults standardUserDefaults] setObject:style forKey:zhThemeStyleStorageKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)setDefaultThemeColorFile:(NSString *)defaultFile {
    objc_setAssociatedObject(self, zh_defaultThemeColorFileKey, defaultFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateThemeColorFile:(NSString *)file {
    [[zhThemeFileManager defaultManager] setColorFile:file];
    [self reloadTheme];
}

- (void)setDefaultThemeImageFile:(NSString *)defaultFile {
    objc_setAssociatedObject(self, zh_defaultThemeImageFileKey, defaultFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateThemeImageFile:(NSString *)file {
    [[zhThemeFileManager defaultManager] setImageFile:file];
    [self reloadTheme];
}

- (void)setThemeImageResources:(NSString *)resourcesPath {
    [[zhThemeFileManager defaultManager] setImageSourcesPath:resourcesPath];
}

- (NSDictionary<NSString *,NSDictionary *> *)colorLibraries {
    return [zhThemeFileManager defaultManager].colorDictionary;
}

- (NSDictionary<NSString *,NSDictionary *> *)imageLibraries {
    return [zhThemeFileManager defaultManager].imageDictionary;
}

- (id)imageSources {
    return [zhThemeFileManager defaultManager].imageSources;
}

@end
